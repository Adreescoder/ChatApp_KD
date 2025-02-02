import 'package:chatapp_kd/screens/home/view.dart';
import 'package:chatapp_kd/screens/sigup/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while waiting
        } else if (snapshot.hasData) {
          return HomePage(); // User is logged in
        } else {
          return SignupPage(); // User is not logged in
        }
      },
    );
  }
}
