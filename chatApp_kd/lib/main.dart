/*
import 'package:chatapp_kd/screens/chat.dart';
import 'package:chatapp_kd/screens/sigup/view.dart';
import 'package:chatapp_kd/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

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

    Get.put(AuthController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatApp KD'.toUpperCase(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: ()=> FirebaseInitializer() ),
        GetPage(
            name: '/chat',
            page: () {
              final arguments = Get.arguments as Map<String, dynamic>?;
              return ChatScreen(
                userId: arguments?['userId'] ?? '', // Use a default value if 'userId' is missing
                userName: arguments?['userName'] ?? '', // Use a default value if 'userName' is missing
              );
            }
        ),
      ],
    );
  }
}


*/
