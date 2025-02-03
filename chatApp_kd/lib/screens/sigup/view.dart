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
  final SignupScreenLogic = Get.put(SignupScreenLogic());

  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _termsAccepted = false;
  String _status = "Offline"; // User status (Online/Offline)
  DateTime? _lastOnlineTime; // Timestamp for last online activity

  File? _imageFile; // For mobile
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
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    }
  }

  void _updateStatus() {
    setState(() {
      _status = "Online";
      _lastOnlineTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildProfileImagePicker(),
                  _buildAnimatedTextField("Username", _usernameController, Icons.person),
                  _buildAnimatedTextField("Email", _emailController, Icons.email),
                  _buildAnimatedTextField("Password", _passwordController, Icons.lock, obscureText: true),
                  _buildGenderSelection(),
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
      child: AnimatedContainer(
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
                : _imageFile != null
                ? Image.file(_imageFile!, fit: BoxFit.cover, key: ValueKey(_imageFile))
                : const Icon(Icons.add_a_photo, color: Colors.white70, size: 50, key: ValueKey("default")),
          ),
        ),
      ),
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
      child: GestureDetector(
        onTap: () {
          if (_termsAccepted) {
            _updateStatus(); // Mark as online when sign up happens
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign Up Successful!')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please accept the terms!')));
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
          child: const Center(
            child: Text("Sign Up", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
