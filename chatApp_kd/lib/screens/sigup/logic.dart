import 'package:chatapp_kd/modles/user.dart';
import 'package:chatapp_kd/screens/home/view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupLogic extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<void> signupFirebase() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String userId = userCredential.user!.uid;
      UserModel userModel = UserModel(
        id: userId,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
        imageUrl: "imageUrl",
        isOnline: true,
      );

      /// Save user to Firestore
      await firestore.collection("KD").doc(userId).set(userModel.toJson());

      Get.snackbar("Success", "Account created successfully!");

      Get.offAll(
            () => HomePage(),
        transition: Transition.circularReveal,
        curve: Curves.easeInOutCubic,
        duration: Duration(seconds: 4),
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Auth Error", e.message ?? "Something went wrong");
    } on FirebaseException catch (e) {
      Get.snackbar("Database Error", e.message ?? "Firestore issue occurred");
    } catch (e) {
      Get.snackbar("Signup Failed", "Unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
