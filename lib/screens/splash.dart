import './../library.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double dh = MediaQuery.of(context).size.height;
    double dw = MediaQuery.of(context).size.width;

    Future.delayed(Duration(seconds: 3), () {
      // if(LocalStorageService.getData('logged')??false){
      if (FirebaseAuth.instance.currentUser != null) {
        Get.offAllNamed("dashboard");
      } else {
        Get.offAllNamed("login");
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        return;
      },
      child: Scaffold(
        backgroundColor: blackColor,
        body: Center(
          child: Container(
            height: dh * .3,
            width: dw * .6,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  filterQuality: FilterQuality.medium,
                  fit: BoxFit.fill,
                  image: AssetImage("assets/app_logo/splash_gif_dark.gif")),
            ),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Powered By RhythmPals',
                      style: Theme.of(context).textTheme.displaySmall),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
