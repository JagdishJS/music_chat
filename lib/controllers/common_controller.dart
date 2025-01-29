import 'dart:convert';
import 'package:dio/dio.dart';
import "../library.dart";
import 'package:intl/intl.dart';

class CommonController extends GetxController {
  // Define user variables
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userUid = ''.obs;
  var lastSeenTime = ''.obs;
  var partnerName = ''.obs;
  var partnerEmail = ''.obs;
  var partnerLastSeen = ''.obs;
  var partnerUid = ''.obs;
  var partnerFcmToken = ''.obs;
  var userFcmToken = ''.obs;

  // for zigo cloud
  var appId = 479352876;
  var appSign =
      'f52dbbb0997b9aeaa388d0729f0722be155c1df4f3652e7457a371bde67af089';
  var callerId = "Isai_Janan";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    loadLocalData();
  }

  loadLocalData() {
    User? user = _auth.currentUser;
    userUid.value = user?.uid ?? "";
    userName.value = user?.email == null
        ? "-"
        : user?.email == "jagadeeswaran.s3@gmail.com"
            ? "Janan"
            : "Isai";
    partnerName.value = user?.email == null
        ? "-"
        : user?.email == "jagadeeswaran.s3@gmail.com"
            ? "Isai"
            : "Janan";
    userEmail.value = user?.email ?? "";
    updateLastOpenedTime();
    fetchLastOpenedTime();
  }

  void updateLastOpenedTime() async {
    User? user = _auth.currentUser;
    String? token = await _fcm.getToken();
    userFcmToken.value = token!;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userName.value).get();

      if (userDoc.exists) {
        await _firestore.collection('users').doc(userName.value).update({
          'lastOpened': FieldValue.serverTimestamp(),
          'fcm_token': token,
        });
      } else {
        await _firestore.collection('users').doc(userName.value).set({
          'email': user.email,
          'name': userName.value,
          'uid': user.uid,
          'fcm_token': token,
          'lastOpened': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  void fetchLastOpenedTime() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(partnerName.value).get();
      if (userDoc.exists) {
        Timestamp lastOpenedTimestamp =
            userDoc['lastOpened'] ?? Timestamp.now();
        partnerLastSeen.value = DateFormat('MMM dd, yyyy hh:mm a')
            .format(lastOpenedTimestamp.toDate());
        partnerName.value = userDoc['name'];
        partnerEmail.value = userDoc['email'];
        partnerUid.value = userDoc['uid'];
        partnerFcmToken.value = userDoc['fcm_token'];
      }
      update();
    }
  }

  void signOut() async {
    LocalStorageService.clearAllData();
    await _auth.signOut();
    Get.offAllNamed("splashScreen");
  }

  // Function to get the access token for your service account
  Future<String> getAccessToken(String title, String body) async {
    final String serviceAccountJson = await rootBundle
        .loadString('music-chat-8a625-firebase-adminsdk-fbsvc-edd108fb04.json');
    final Map<String, dynamic> serviceAccount = jsonDecode(serviceAccountJson);

    try {
      // Send POST request with Dio
      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(serviceAccount),
        ['https://www.googleapis.com/auth/cloud-platform'],
      );

      final notificationData = {
        'message': {
          'token': partnerFcmToken.value,
          'notification': {'title': title, 'body': body}
        },
      };

      final response = await client.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/music-chat-8a625/messages:send'),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode(notificationData),
      );

      client.close();
      if (response.statusCode == 200) {
        return "Success!"; // Success!
      }
      return "Failed!"; // Failed!
    } catch (e) {
      throw Exception('Failed to retrieve access token');
    }
  }

  // Function to get the access token for your service account
  Future<String> voiceCallAccessToken(String title, String body) async {
    final String serviceAccountJson = await rootBundle
        .loadString('music-chat-8a625-firebase-adminsdk-fbsvc-edd108fb04.json');
    final Map<String, dynamic> serviceAccount = jsonDecode(serviceAccountJson);

    try {
      // Send POST request with Dio
      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(serviceAccount),
        ['https://www.googleapis.com/auth/cloud-platform'],
      );

      final notificationData = {
        'message': {
          'token': partnerFcmToken.value,
            "notification": {"title": title, "body": body},
            "data": {
            "type": "voice_call",
            "action": "incoming",
            "call_id": callerId, // Custom data for identifying the call
            "accept_action": "accept_call",
            "reject_action": "reject_call"
          }
        },
      };

      final response = await client.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/music-chat-8a625/messages:send'),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode(notificationData),
      );

      client.close();
      if (response.statusCode == 200) {
        return "Success!"; // Success!
      }
      return "Failed!"; // Failed!
    } catch (e) {
      throw Exception('Failed to retrieve access token');
    }
  }

    // Function to get the access token for your service account
  Future<String> videoCallAccessToken(String title, String body) async {
    final String serviceAccountJson = await rootBundle
        .loadString('music-chat-8a625-firebase-adminsdk-fbsvc-edd108fb04.json');
    final Map<String, dynamic> serviceAccount = jsonDecode(serviceAccountJson);

    try {
      // Send POST request with Dio
      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(serviceAccount),
        ['https://www.googleapis.com/auth/cloud-platform'],
      );

      final notificationData = {
        'message': {
          'token': partnerFcmToken.value,
            "notification": {"title": title, "body": body},
            "data": {
            "type": "video_call",
            "action": "incoming",
            "call_id": callerId, // Custom data for identifying the call
            "accept_action": "accept_video_call",
            "reject_action": "reject_video_call"
          }
        },
      };

      final response = await client.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/music-chat-8a625/messages:send'),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode(notificationData),
      );

      client.close();
      if (response.statusCode == 200) {
        return "Success!"; // Success!
      }
      return "Failed!"; // Failed!
    } catch (e) {
      throw Exception('Failed to retrieve access token');
    }
  }
}
