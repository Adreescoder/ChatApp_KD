import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signup_controller.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String gender = "Male";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: confirmEmailController,
                decoration: const InputDecoration(labelText: "Confirm Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
              ),
              TextField(
                controller: dobController,
                decoration: const InputDecoration(labelText: "Date of Birth"),
                keyboardType: TextInputType.datetime,
              ),
              Row(
                children: [
                  const Text("Gender: "),
                  Radio(
                    value: "Male",
                    groupValue: gender,
                    onChanged: (value) {
                      gender = value!;
                    },
                  ),
                  const Text("Male"),
                  Radio(
                    value: "Female",
                    groupValue: gender,
                    onChanged: (value) {
                      gender = value!;
                    },
                  ),
                  const Text("Female"),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.signUp(
                    username: usernameController.text,
                    email: emailController.text,
                    confirmEmail: confirmEmailController.text,
                    password: passwordController.text,
                    confirmPassword: confirmPasswordController.text,
                    dob: dobController.text,
                    gender: gender,
                  );
                },
                child: const Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUp({
    required String username,
    required String email,
    required String confirmEmail,
    required String password,
    required String confirmPassword,
    required String dob,
    required String gender,
  }) async {
    try {
      // Validation
      if (email != confirmEmail) {
        Get.snackbar("Error", "Emails do not match!");
        return;
      }
      if (password != confirmPassword) {
        Get.snackbar("Error", "Passwords do not match!");
        return;
      }

      // Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user details in Firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "username": username,
        "email": email,
        "dob": dob,
        "gender": gender,
        "uid": userCredential.user!.uid,
      });

      Get.snackbar("Success", "User Registered Successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
