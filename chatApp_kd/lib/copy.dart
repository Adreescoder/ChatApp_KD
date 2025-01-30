import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String gender = "Male";
  bool termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField("Username", usernameController, TextInputType.text),
              _buildTextField("Email address", emailController, TextInputType.emailAddress),
              _buildTextField("Confirm Email address", confirmEmailController, TextInputType.emailAddress),
              _buildTextField("Password", passwordController, TextInputType.text, obscureText: true),
              _buildTextField("Confirm Password", confirmPasswordController, TextInputType.text, obscureText: true),
              _buildTextField("Date of Birth", dobController, TextInputType.datetime),
              _buildGenderSelection(),
              _buildTermsCheckbox(),
              _buildSignUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType inputType, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
        keyboardType: inputType,
        obscureText: obscureText,
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      children: [
        const Text("Gender:"),
        Radio<String>(
          value: "Male",
          groupValue: gender,
          onChanged: (value) {
            setState(() {
              gender = value!;
            });
          },
        ),
        const Text("Male"),
        Radio<String>(
          value: "Female",
          groupValue: gender,
          onChanged: (value) {
            setState(() {
              gender = value!;
            });
          },
        ),
        const Text("Female"),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: termsAccepted,
          onChanged: (bool? value) {
            setState(() {
              termsAccepted = value!;
            });
          },
        ),
        const Text("I agree to the terms and conditions"),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ElevatedButton(
        onPressed: () {
          if (termsAccepted) {
            // Handle Sign Up Logic
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sign Up button pressed')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please accept the terms and conditions')),
            );
          }
        },
        child: const Text("Sign Up"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
