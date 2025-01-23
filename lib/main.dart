import './library.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  PushNotificationService().initialize();
  await NotificationService().initNotification();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> appNavigateKey = GlobalKey<NavigatorState>();

  final GlobalKey<ScaffoldMessengerState> appScaffoldMessKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Isai Janan',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      initialBinding: GlobalBinding(),
      scaffoldMessengerKey: appScaffoldMessKey,
      navigatorKey: appNavigateKey,
      routes: <String, WidgetBuilder>{
        'splashScreen': (BuildContext context) => const SplashScreen(),
        'login': (BuildContext context) => LoginScreen(),
        'signup': (BuildContext context) => SignupScreen(),
        'dashboard': (BuildContext context) => DashboardScreen(),
        'chat': (BuildContext context) => ChatScreen(),
        'voice_call': (BuildContext context) => CallPage(),
        'video_call': (BuildContext context) => VideoCallPage(),
      },
      initialRoute: "Splash",
    );
  }
}
