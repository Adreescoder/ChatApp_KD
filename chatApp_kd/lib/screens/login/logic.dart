import 'package:chatapp_kd/screens/home/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginLogic extends GetxController {
  // Controllers for text fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Reactive variables for password visibility
  RxBool isPasswordHidden = true.obs;

  // Reactive variable for loading state (used during login process)
  RxBool isLoading = false.obs;

  // Form key for validation
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> loginFirebase() async {
    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;

      try {
        // Firebase Authentication login
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Get.to(() => HomePage(),
            transition: Transition.circularReveal,
            curve: Curves.easeInOutCubic,
            duration: Duration(seconds: 4));
        Get.snackbar('Success', 'Login Successfully .');

      } on FirebaseAuthException catch (e) {
        // Handle Firebase authentication errors
        print("Error: ${e.message}");
        if (e.code == 'user-not-found') {
          Get.snackbar('Error', 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Error', 'Incorrect password.');
        } else {
          Get.snackbar('Error', e.message ?? 'An error occurred');
        }
      } catch (e) {
        // Handle any other errors
        print("Unexpected error: $e");
        Get.snackbar('Error', 'An unexpected error occurred');
      } finally {
        isLoading.value = false;
      }
    }
  }

}
