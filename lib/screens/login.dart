import '../library.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false;

  void _login() async {
    try {
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        User? user = userCredential.user;

        if (user != null && user.emailVerified == true) {
          LocalStorageService.storeData('uid', user.uid);
          LocalStorageService.storeData('email', user.email);
          LocalStorageService.storeData(
              'user_created_at', user.metadata.creationTime.toString());
          LocalStorageService.storeData(
              'user_last_signin_at', user.metadata.lastSignInTime.toString());

          if (mounted) {
            toast("User Signin Successful!", context);
          }
          Get.offAllNamed("dashboard");
        } else if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
          if (mounted) {
            toast("Verification email sent! Please check your inbox.", context);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        toast("Invalid Email or password.", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double dh = MediaQuery.of(context).size.height;
    double dw = MediaQuery.of(context).size.width;
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          return;
        },
        child: Scaffold(
            backgroundColor: blackColor,
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/app_logo/login_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                // Center the content
                child: Padding(
                  padding: EdgeInsets.all(dh * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _emailController,
                        style: TextStyle(color: whiteColor),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: whiteColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: whiteColor),
                          ),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: dw * 0.01),
                        ),
                      ),
                      SizedBox(height: dh * .02),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: TextStyle(color: whiteColor),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: whiteColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: whiteColor),
                          ),
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: whiteColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: dw * 0.01),
                        ),
                      ),
                      SizedBox(height: dh * .1),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: green,
                          foregroundColor: whiteColor,
                        ),
                        child: Text('Play Your Tune',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      SizedBox(height: dh * .02),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed("signup");
                        },
                        child: Text(
                            '🎵 Ready to drop the beat? Sign up now! 🎶',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelMedium),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}
