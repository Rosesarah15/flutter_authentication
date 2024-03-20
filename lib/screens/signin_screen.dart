import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication/reusable_widgets/reusable_widgets.dart';
import 'package:flutter_authentication/screens/home_screen.dart';
import 'package:flutter_authentication/screens/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: buildGradient(context),
        ),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.15, 20, 0),
          child: Column(children: [
            Image.asset('images/logins.png'),
            const SizedBox(
              height: 30,
            ),
            reusableTextField('Enter Email', Icons.email_outlined, false,
                _emailTextController),
            const SizedBox(
              height: 20,
            ),
            reusableTextField('Enter Password', Icons.lock_outline, true,
                _passwordTextController),
            const SizedBox(
              height: 20,
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : signInSignUpButton(context, true, () {
                    setState(() {
                      _isLoading = true;
                    });
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    }).catchError((error) {
                      setState(() {
                        _isLoading = false;
                      });
                      // showDialog(
                      //     context: context,
                      //     builder: (context) => AlertDialog(
                      //           title: const Text("Error"),
                      //           content: Text(error.toString()),
                      //           actions: [
                      //             TextButton(
                      //                 onPressed: () {
                      //                   Navigator.of(context).pop();
                      //                 },
                      //                 child: const Text('OK'))
                      //           ],
                      //         ));
                    });
                  }),
            signUpOption(context)
          ]),
        )),
      ),
    );
  }
}

Row signUpOption(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "Don't have account?",
        style: TextStyle(color: Colors.white70),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()));
        },
        child: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}
