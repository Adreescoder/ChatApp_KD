import 'dart:io';
import 'package:chatapp_kd/screens/login/view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'logic.dart';

// 🎨 Pastel Colors
const Color pastelPink = Color(0xFFF3D5DB);
const Color pastelLavender = Color(0xFFF7DFEF);
const Color pastelGreen = Color(0xFFCCDDC0);
const Color pastelBeige = Color(0xFFF8E4C4);
const Color pastelBlue = Color(0xFFC9E0EC);

class SignupPage extends StatefulWidget {
  SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final SignupLogic logic = Get.put(SignupLogic());
  Uint8List? bytesFromPicker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌆 Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image.png"), // <-- 🖼 Background Image
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🌟 Signup Form with Transparent Background
          Center(
            child: Container(
              padding: EdgeInsets.all(16),
              width: 340,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85), // 🔹 Slight Transparency
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: pastelPink,
                      fontSize: 26,
                    ),
                  ),
                  SizedBox(height: 20),

                  // 📸 Profile Image Picker
                  Center(
                    child: InkWell(
                      onTap: () async {
                        if (kIsWeb) {
                          bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
                          setState(() {});
                        } else if (Platform.isAndroid || Platform.isIOS) {
                          Get.snackbar("Error", "This feature is only available on Web.");
                        }
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: pastelLavender,
                        backgroundImage:
                        bytesFromPicker != null ? MemoryImage(bytesFromPicker!) : null,
                        child: bytesFromPicker == null
                            ? Icon(Icons.camera, color: pastelPink, size: 40)
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // 📝 Form Fields
                  textFieldBuild(logic.nameController, "Enter your name", Icons.person),
                  textFieldBuild(logic.emailController, "Enter your email", Icons.email),
                  textFieldBuild(logic.passwordController, "Enter your password", Icons.lock,
                      isPassword: true),
                  SizedBox(height: 20),

                  // 🎯 Signup Button
                  ElevatedButton(
                    onPressed: () async {
                      if (bytesFromPicker != null) {
                        String folderPath = "profile_images";
                        String? imageUrl = await logic.uploadImage(folderPath, bytesFromPicker!);

                        if (imageUrl != null) {
                          await logic.signupUser(imageUrl);
                        } else {
                          Get.snackbar("Error", "Image upload failed.");
                        }
                      } else {
                        Get.snackbar("Error", "Please select an image.");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: pastelBlue,
                      elevation: 5,
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // 🔄 Login Navigation
                  InkWell(
                    onTap: () {
                      Get.to(() => LoginPage());
                    },
                    child: Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: pastelBeige,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // 🔗 Social Media Signup
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      socialIcon(FontAwesomeIcons.google, Colors.red, "Google"),
                      SizedBox(width: 10),
                      socialIcon(FontAwesomeIcons.facebook, Colors.blue, "Facebook"),
                      SizedBox(width: 10),
                      socialIcon(FontAwesomeIcons.github, Colors.black, "GitHub"),
                    ],
                  ),
                 ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🎨 Custom TextField
Widget textFieldBuild(TextEditingController controller, String hintText, IconData icon,
    {bool isPassword = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: pastelGreen),
        hintText: hintText,
        filled: true,
        fillColor: pastelLavender.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}

// 🔗 Social Media Icons
Widget socialIcon(IconData icon, Color color, String name) {
  return IconButton(
    icon: FaIcon(icon, color: color, size: 30),
    onPressed: () {
      Get.snackbar("Social Login", "$name Login Pressed");
    },
  );
}
