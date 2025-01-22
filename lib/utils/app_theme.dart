import '../library.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: createMaterialColor(spearmint),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Courier Prime',
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: Colors.white),
    iconTheme: const IconThemeData(color: Color(0xff668f70)),
    textTheme: TextTheme(
      bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: whiteColor,
          letterSpacing: 1.2),
      bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: whiteColor,
          letterSpacing: 1.2),
      bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: whiteColor,
          letterSpacing: 1.4),
      labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: blackColor,
          letterSpacing: 1),
      labelMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: blackColor,
          letterSpacing: 1),
      labelLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: blackColor,
          letterSpacing: 1),
      titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: blackColor,
          letterSpacing: 1),
      titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: blackColor,
          letterSpacing: 1),
      titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.normal,
          color: blackColor,
          letterSpacing: 1),
      displaySmall: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.normal,
          color: blackColor,
          letterSpacing: 1),
      displayMedium: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.normal,
          color: blackColor,
          letterSpacing: 1),
      displayLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: blackColor,
          letterSpacing: 1),
    ),
    dialogBackgroundColor: Colors.white,
    unselectedWidgetColor: Colors.black,
    dividerColor: Color(0xff406850),
    cardColor: Colors.white,
    dialogTheme: DialogTheme(shape: dialogShape()),
    appBarTheme: AppBarTheme(
      color: whiteColor,
      iconTheme: const IconThemeData(color: Colors.white),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: createMaterialColor(whiteColor),
    // blackColor: whiteColor,
    scaffoldBackgroundColor: whiteColor,
    fontFamily: 'Courier Prime',
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: whiteColor),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: whiteColor,
          letterSpacing: 1.2),
      bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: whiteColor,
          letterSpacing: 1.2),
      bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: whiteColor,
          letterSpacing: 1.4),
      labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.normal,
          color: whiteColor,
          letterSpacing: 1),
      labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: whiteColor,
          letterSpacing: 1),
      labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: whiteColor,
          letterSpacing: 1),
      titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: whiteColor,
          letterSpacing: 1),
      titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: whiteColor,
          letterSpacing: 1),
      titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.normal,
          color: whiteColor,
          letterSpacing: 1),
      displaySmall: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.normal,
          color: whiteColor,
          letterSpacing: 1),
      displayMedium: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.normal,
          color: whiteColor,
          letterSpacing: 1),
      displayLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: whiteColor,
          letterSpacing: 1),
    ),
    dialogBackgroundColor: blackColor,
    unselectedWidgetColor: Colors.white60,
    dividerColor: Colors.white12,
    cardColor: blackColor,
    dialogTheme: DialogTheme(shape: dialogShape()),
    appBarTheme: AppBarTheme(
      backgroundColor: blackColor,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
