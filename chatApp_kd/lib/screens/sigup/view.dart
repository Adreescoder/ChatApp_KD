import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'logic.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final logic = Get.put(SignupScreenLogic());

  bool _termsAccepted = false;

  Uint8List? _webImage; // For web

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        logic.selectedImage.value = File(pickedFile.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildProfileImagePicker(),
                  _buildAnimatedTextField("Name", logic.nameController, Icons.person),
                  _buildAnimatedTextField("Email", logic.emailController, Icons.email),
                  _buildAnimatedTextField("Password", logic.passwordController, Icons.lock, obscureText: true),
                  _buildTermsCheckbox(),
                  _buildSignUpButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Obx(() {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)],
          ),
          child: ClipOval(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _webImage != null
                  ? Image.memory(_webImage!, fit: BoxFit.cover, key: ValueKey(_webImage))
                  : logic.selectedImage.value != null
                  ? Image.file(logic.selectedImage.value!, fit: BoxFit.cover, key: ValueKey(logic.selectedImage.value))
                  : const Icon(Icons.add_a_photo, color: Colors.white70, size: 50, key: ValueKey("default")),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAnimatedTextField(String label, TextEditingController controller, IconData icon, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 2)],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.white),
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white70),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: _termsAccepted,
          onChanged: (bool? value) => setState(() => _termsAccepted = value!),
          activeColor: Colors.white,
          checkColor: Colors.black,
        ),
        const Text("I accept the terms", style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Obx(() {
        return GestureDetector(
          onTap: () {
            if (_termsAccepted) {
              logic.signupFirebase();
            } else {
              Get.snackbar("Terms", "Please accept the terms before signing up.", snackPosition: SnackPosition.BOTTOM);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: _termsAccepted ? 180 : 150,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 2)],
            ),
            child: Center(
              child: logic.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text("Sign Up", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      }),
    );
  }
}
