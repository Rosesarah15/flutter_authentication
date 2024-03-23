import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication/reusable_widgets/reusable_widgets.dart';
import 'package:flutter_authentication/screens/signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String _userName = '';

  void inputData() {
    final User? user = auth.currentUser;
    final name = user?.displayName;
    setState(() {
      _userName = name ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    inputData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Welcome ${auth.currentUser?.displayName}",
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: buildGradient(context),
        ),
        child: Center(
          child: ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                });
              },
              child: const Text('LogOut')),
        ),
      ),
    );
  }
}
