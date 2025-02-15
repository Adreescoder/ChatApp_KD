import 'dart:io';

import 'package:chatapp_kd/screens/login/view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'logic.dart';

class SigupPage extends StatefulWidget {
  SigupPage({Key? key}) : super(key: key);

  @override
  State<SigupPage> createState() => _SigupPageState();
}

class _SigupPageState extends State<SigupPage> {
  final SignupLogic logic = Get.put(SignupLogic());
  Uint8List? bytesFromPicker ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome",style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18
              ),),
              Center(
                child: InkWell(
                  onTap: ()async{
                    if(kIsWeb){
                   bytesFromPicker  = await ImagePickerWeb.getImageAsBytes();
                   setState(() {});
                    }else if(Platform.isAndroid || Platform.isIOS){
                      Get.snackbar("Ye app mobile pir work nai karti", "Sorry Sir");
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(75)
                    ),
                    child: ClipOval(
                      child: bytesFromPicker!=null ?Image.memory(bytesFromPicker!): Icon(Icons.camera),
                    ),
                  ),
                ),
              ),
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
                isPassword: true, // Hide password
              ),
              ElevatedButton(
                onPressed: () async {
                  if (bytesFromPicker != null) {
                    String folderPath = "profile_images"; // Define folder path
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
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Bigger padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // More rounded button
                  ),
                  backgroundColor: Colors.transparent, // Gradient effect will be applied
                  elevation: 5, // Adds a slight shadow effect
                  shadowColor: Colors.deepPurple.withOpacity(0.4), // Smooth shadow
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent], // Gradient colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30), // Match button shape
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 16),
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
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: () {
                  Get.to(() => LoginPage());
                },
                child: Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline, // Adds underline effect
                  ),
                ),
              )



            ],
          ),
        ));
  }
}




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
      obscureText: isPassword, // Hide text if it's a password field
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.purple),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
