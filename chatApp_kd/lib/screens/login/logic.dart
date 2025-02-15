import 'package:chatapp_kd/screens/home/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginLogic extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  var isLoading = false.obs; // Observable for loading state

  Future<void> loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter email and password");
      return;
    }

    isLoading.value = true; // Show loading

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Success", "Login Successful!");
      Get.to(()=> HomePage()); // Navigate to HomeScreen
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", e.message ?? "Something went wrong");
    } finally {
      isLoading.value = false; // Hide loading
    }
  }
}
