import './library.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:background_fetch/background_fetch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  PushNotificationService().initialize();
  await NotificationService().initNotification();
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await Permission.location.isDenied.then((value) {
    if (value) {
      Permission.location.request();
    }
  });

  Permission.bluetoothScan.request();

  runApp(MyApp());
}

// class MyApp extends StatefulWidget {
//   MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final GlobalKey<NavigatorState> appNavigateKey = GlobalKey<NavigatorState>();

//   final GlobalKey<ScaffoldMessengerState> appScaffoldMessKey =
//       GlobalKey<ScaffoldMessengerState>();

//   @override
//   void initState() {
//     super.initState();
//     initBackgroundFetch();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Isai Janan',
//       theme: AppTheme.darkTheme,
//       home: const SplashScreen(),
//       initialBinding: GlobalBinding(),
//       scaffoldMessengerKey: appScaffoldMessKey,
//       navigatorKey: appNavigateKey,
//       routes: <String, WidgetBuilder>{
//         'splashScreen': (BuildContext context) => const SplashScreen(),
//         'login': (BuildContext context) => LoginScreen(),
//         'signup': (BuildContext context) => SignupScreen(),
//         'dashboard': (BuildContext context) => DashboardScreen(),
//         'chat': (BuildContext context) => ChatScreen(),
//         'voice_call': (BuildContext context) => CallPage(),
//         'video_call': (BuildContext context) => VideoCallPage(),
//       },
//       initialRoute: "Splash",
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothScanPage(),
    );
  }
}

class BluetoothScanPage extends StatefulWidget {
  @override
  _BluetoothScanPageState createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends State<BluetoothScanPage> {
  // FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<BluetoothDevice> devicesList = [];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  // Request Bluetooth permissions
  Future<void> _requestPermissions() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.locationWhenInUse.request();
    _startScan();
  }

  // Start scanning for Bluetooth devices
  void _startScan() async {
    // Start scanning for devices
    print("start ojdjfd");
    FlutterBluePlus.startScan(timeout: Duration(seconds: 15));

    // Listen to the scan results
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        // Add the device to the list if it's not already added
        if (!devicesList.contains(result.device)) {
          setState(() {
            devicesList.add(result.device);
          });
        }
      }
    });
    // _startScan();
    // Stop scanning after 4 seconds
    FlutterBluePlus.stopScan();
  }

  // Display the list of nearby devices
  Widget _buildDeviceList() {
    return ListView.builder(
      itemCount: devicesList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(devicesList[index].name.isEmpty
              ? 'Unnamed Device'
              : devicesList[index].name),
          subtitle: Text(devicesList[index].id.toString()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Device Scan'),
      ),
      body: Center(
        child: devicesList.isEmpty
            ? CircularProgressIndicator()
            : _buildDeviceList(),
      ),
    );
  }
}

void backgroundFetchHeadlessTask(String taskId) async {
  print("Headless Task: $taskId");
  scanBluetoothDevices();
  BackgroundFetch.finish(taskId);
}

void initBackgroundFetch() {
  BackgroundFetch.configure(
    BackgroundFetchConfig(
      minimumFetchInterval: 1,
      stopOnTerminate: false,
      enableHeadless: true,
      startOnBoot: true,
      requiredNetworkType: NetworkType.ANY,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
    ),
    (String taskId) async {
      print("Background Fetch Event: $taskId");
      scanBluetoothDevices();
      BackgroundFetch.finish(taskId);
    },
  );
}

void scanBluetoothDevices() {
  print("Starting Bluetooth Scan...");
  FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

  FlutterBluePlus.scanResults.listen((results) {
    for (ScanResult result in results) {
      print("Device: ${result.device.name}, RSSI: ${result.rssi}");
    }
  });

  FlutterBluePlus.stopScan();
}
