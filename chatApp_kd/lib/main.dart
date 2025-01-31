import 'package:chatapp_kd/screens/home/view.dart';
import 'package:chatapp_kd/screens/sigup/view.dart';
import 'package:chatapp_kd/test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'button.dart';
import 'copy.dart';
import 'firebase_options.dart';
import 'loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatApp KD'.toUpperCase(),
      home:  AnimatedSignUpScreen(),
    );
  }
}



////Malik sab