import 'dart:io';
import 'package:chatapp_kd/modles/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreenLogic extends GetxController {
  var selectedImage = Rx<File?>(null);
  var isLoading = false.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signupFirebase() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar("Error", "All fields are required!",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
      String userId =  userCredential.user!.uid ;
        UserModel userModel = UserModel(id: userId, name: nameController.text, email: emailController.text, password: passwordController.text,  imageUrl: imageUrl, isOnline: isOnline);
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': nameController.text,
          'email': emailController.text,
          'imageUrl': '',
          'createdAt': Timestamp.now(),
        });

        Get.snackbar("Success", "Signup Successful!",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
/// ok 