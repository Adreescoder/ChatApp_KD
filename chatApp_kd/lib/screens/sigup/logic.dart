import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modles/user.dart';
import '../home/view.dart';

class SignupLogic extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  var isLoading = false.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signupUser(String imageUrl) async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please fill all the fields");
      return;
    }

    isLoading.value = true;

    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      String userId = userCredential.user!.uid;

      UserModel newUser = UserModel(
        id: userId,
        name: name,
        email: email,
        password: password,
        imageUrl: imageUrl,
        isOnline: true,
      );

      await _firestore.collection("users").doc(userId).set(newUser.toJson());

      Get.offAll(() => HomePage());
      Get.snackbar("Success", "Account created successfully!");
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Signup Failed", e.message ?? "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> uploadImage(String folderPath, Uint8List image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _firebaseStorage.ref().child(folderPath).child(fileName);

      // Fix: Use await to ensure upload completes
      UploadTask uploadTask = ref.putData(image);
      TaskSnapshot snapshot = await uploadTask;

      // Fix: Return the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Download URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
