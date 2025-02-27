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
const Color pastelOffWhite = Color(0xFFFEF5F4);
const Color pastelGreen = Color(0xFFCCDDC0);
const Color pastelBeige = Color(0xFFF8E4C4);
const Color pastelBlue = Color(0xFFC9E0EC);
const Color pastelLavender = Color(0xFFF7DFEF);

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
          // 🎨 Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [pastelPink, pastelLavender],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),


          // 🌟 Signup Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60),
                  Center(
                    child: Text(
                      "Welcome",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: pastelPink,
                        fontSize: 26,
                      ),
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
                      child: Container(
                        alignment: Alignment.center,
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: pastelLavender,
                          borderRadius: BorderRadius.circular(75),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: bytesFromPicker != null
                              ? Image.memory(bytesFromPicker!, fit: BoxFit.cover)
                              : Icon(Icons.camera, color: pastelPink, size: 50),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // 📝 Form Fields
                  textFieldBuild(
                    controller: logic.nameController,
                    hintText: "Enter your name",
                    icon: Icons.person,
                  ),
                  textFieldBuild(
                    controller: logic.emailController,
                    hintText: "Enter your email",
                    icon: Icons.email,
                  ),
                  textFieldBuild(
                    controller: logic.passwordController,
                    hintText: "Enter your password",
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  SizedBox(height: 20),

                  // 🎯 Signup Button
                  Center(
                    child: ElevatedButton(
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
                        shadowColor: pastelGreen.withOpacity(0.4),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // 🔄 Login Navigation
                  Center(
                    child: InkWell(
                      onTap: () {
                        Get.to(() => LoginPage());
                      },
                      child: Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: pastelBeige,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // 🔗 Social Media Signup
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        socialIcon(FontAwesomeIcons.google, Colors.red, "Google"),
                        SizedBox(width: 10),
                        socialIcon(FontAwesomeIcons.facebook, Colors.blue, "Facebook"),
                        SizedBox(width: 10),
                        socialIcon(FontAwesomeIcons.github, Colors.black, "GitHub"),
                      ],
                    ),
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
Widget textFieldBuild({
  required TextEditingController controller,
  required String hintText,
  required IconData icon,
  bool isPassword = false,
}) {
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
