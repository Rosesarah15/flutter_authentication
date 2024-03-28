import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication/reusable_widgets/reusable_widgets.dart';
import 'package:flutter_authentication/screens/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, required this.isDarkMode}) : super(key: key);
  final bool isDarkMode;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  bool _isLoading = false;

  void navigateToSignInScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => SignInScreen(isDarkMode: widget.isDarkMode)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Sign Up',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: buildGradient(context),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.1, 20, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      labelText: 'Enter UserName',
                      icon: Icons.person_outline,
                      isObscure: false,
                      controller: _userNameTextController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      labelText: 'Enter Email',
                      icon: Icons.email_outlined,
                      isObscure: false,
                      controller: _emailTextController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        } else if (!_isValidEmail(value)) {
                          return 'Enter a valid Email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      labelText: 'Enter Password',
                      icon: Icons.lock_outlined,
                      isObscure: true,
                      controller: _passwordTextController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        } else if (!_isValidPassword(value)) {
                          return 'Password must contain at least two letters and two numbers';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    signInSignUpButton(context, false, () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        final UserCredential user = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text);

                        await user.user
                            ?.updateDisplayName(_userNameTextController.text);
                        setState(() {
                          _isLoading = false;
                        });
                        navigateToSignInScreen();
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ]),
    );
  }
}

bool _isValidEmail(String value) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
}

bool _isValidPassword(String value) {
  return RegExp(r'^(?=.*[a-zA-Z].*[a-zA-Z])(?=.*\d.*\d).{6,}$').hasMatch(value);
}
