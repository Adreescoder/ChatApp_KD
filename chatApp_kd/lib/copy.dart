import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

class AnimatedSignUpScreen extends StatefulWidget {
  const AnimatedSignUpScreen({super.key});

  @override
  _AnimatedSignUpScreenState createState() => _AnimatedSignUpScreenState();
}

class _AnimatedSignUpScreenState extends State<AnimatedSignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _gender = "Male";
  bool _termsAccepted = false;
  String _status = "Offline"; // Status (Online/Offline)
  DateTime? _lastOnlineTime; // Timestamp for when the user was last online

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

  Future<void> _updateStatus() async {
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
          _buildAnimatedBackground(),
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

  Widget _buildAnimatedBackground() {
    return AnimatedContainer(
      duration: Duration(seconds: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _gender == "Male"
              ? [Colors.blue.shade900, Colors.blueAccent]
              : [Colors.pink.shade900, Colors.pinkAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)],
        ),
        child: ClipOval(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: _webImage != null
                ? Image.memory(_webImage!, fit: BoxFit.cover, key: ValueKey(_webImage))
                : _imageFile != null
                ? Image.file(_imageFile!, fit: BoxFit.cover, key: ValueKey(_imageFile))
                : Icon(Icons.add_a_photo, color: Colors.white70, size: 50, key: ValueKey("default")),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField(String label, TextEditingController controller, IconData icon, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Focus(
        onFocusChange: (hasFocus) => setState(() {}),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
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
              labelStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            keyboardType: obscureText ? TextInputType.visiblePassword : TextInputType.text,
            obscureText: obscureText,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGenderRadio("Male", Icons.male, Colors.blue),
        SizedBox(width: 20),
        _buildGenderRadio("Female", Icons.female, Colors.pink),
      ],
    );
  }

  Widget _buildGenderRadio(String value, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: _gender == value ? color.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: _gender == value ? 3 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(width: 10),
            Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
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
        Text("I accept the terms", style: TextStyle(color: Colors.white)),
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign Up Successful!')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please accept the terms!')));
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: _termsAccepted ? 180 : 150,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 2)],
          ),
          child: Center(
            child: Text("Sign Up", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
