import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication/reusable_widgets/reusable_widgets.dart';
import 'package:flutter_authentication/screens/signin_screen.dart';

class HomeScreen extends StatefulWidget {
  UserCredential userCredential;
  final bool isDarkMode;
  HomeScreen(
    UserCredential value, {
    required this.userCredential,
    required this.isDarkMode,
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool isDarkMode;
  late LinearGradient currentGradient;
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? userCredential;

  @override
  void initState() {
    super.initState();
    userCredential = widget.userCredential;

    isDarkMode = widget.isDarkMode;
    currentGradient = buildGradient(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          //"Welcome ${userCredential!.user!.email}",
          "Welcome ${userCredential!.user!.displayName}",
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: currentGradient),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextButton(
              child: Text(
                isDarkMode ? 'Switch to Light Theme' : 'Switch to Dark Theme',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                  currentGradient = isDarkMode
                      ? buildDarkGradient(context)
                      : buildLightGradient(context);
                });
              },
            ),
            ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInScreen(
                                  isDarkMode: isDarkMode,
                                )));
                  });
                },
                child: const Text('LogOut')),
          ]),
        ),
      ),
    );
  }
}

LinearGradient buildLightGradient(BuildContext context) {
  return const LinearGradient(
    colors: [Colors.lightBlue, Colors.white24],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

LinearGradient buildDarkGradient(BuildContext context) {
  return const LinearGradient(
    colors: [Colors.black, Colors.grey],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
