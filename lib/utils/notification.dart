import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:music_chat/library.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission for iOS
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.title}');
      notification(message: message);
    });

    // Handle background and terminated messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
    });

    // Handle when the app is completely closed
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

    // Background message handler
    static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
      print('Handling a background message: ${message.messageId}');
  }

  Future<void> sendFCMNotification(String token) async {
    const String serverKey = 
    'BO2AfmCXcDsZeE1fnQu1Qq1cfB59roB-FMGZqsS_mYJiT0BsJUkofX9MZOywoR15x1DsrwRyyHDsESMKJJ11EtA'; // Replace with your server key
    const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    final Dio dio = Dio();

    final Map<String, dynamic> notification = {
      'title': 'Incoming Call',
      'body': '${CommonController().partnerName.value} is calling you..',
    };

    final Map<String, dynamic> data = {
      'to': token,
      'notification': notification,
      'priority': 'high',
    };

    final Options options = Options(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
    );

    try {
      final response = await dio.post(
        fcmUrl,
        data: json.encode(data),
        options: options,
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.statusCode}');
        print('Response: ${response.data}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<void> notification({required RemoteMessage message}) async {
    NotificationService().showNotification(
        id: 1,
        title: '${message.notification?.title}',
        body: "${message.notification?.body}",
        payLoad: "");
  }
}

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          debugPrint(payload);
        });

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onSelectNotifications);
  }

  notificationDetails() {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alert'),
      enableLights: true,
      showBadge: true,
    );
    return NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            playSound: true,
            priority: Priority.high,
            color: Colors.deepOrange,
            channelDescription: channel.description,

            // sound:  UriAndroidNotificationSound("assets/alert.mp3"),

            sound: const RawResourceAndroidNotificationSound('alert'),
            icon: "ic_launcher",
            importance: Importance.max));
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    notificationsPlugin.show(id, title, body, await notificationDetails(),
        payload: payLoad);
  }

  onSelectNotifications(NotificationResponse notificationResponse) async {
    LocalStorageService.storeData('alertStop', true);
    // Get.toNamed("voice_call");
  }
}

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;
  Timer? audioTimerOpt1;

  AudioProvider() {
    _audioPlayer.onPlayerStateChanged.listen((event) async {
      if (event == PlayerState.playing) {
        _isPlaying = true;
        LocalStorageService.storeData('alertStop', false);
        audioTimerOpt1 =
            Timer.periodic(const Duration(milliseconds: 500), (timer) async {
          await LocalStorageService.getData('alertStop').then((value) {
            if (value == true) {
              stopAudio();
              LocalStorageService.storeData('alertStop', false);
            }
          });
        });
      } else {
        _isPlaying = false;
        audioTimerOpt1?.cancel();
      }
      notifyListeners();
    });
  }

  void playAudio() async {
    await _audioPlayer.play(AssetSource("alert.mp3"));
    notifyListeners();
  }

  void stopAudio() async {
    await _audioPlayer.stop();
    notifyListeners();
  }
}
