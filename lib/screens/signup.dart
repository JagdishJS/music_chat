import '../library.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false;

  Future signUp() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) {
        toast("User SignUp Successful!", context);
      }
      Get.toNamed("login");
    } on FirebaseAuthException {
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
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          Get.back();
          return;
        },
        child: Scaffold(
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
                    onPressed: signUp,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: green,
                      foregroundColor: whiteColor,
                    ),
                    child: Text('Compose Your Journey',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  SizedBox(height: dh * .02),
                  GestureDetector(
                    onTap: () {
                      Get.offAllNamed("login");
                    },
                    child: Text('🎧 Got your rhythm? Sign in now! 🎶',
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
