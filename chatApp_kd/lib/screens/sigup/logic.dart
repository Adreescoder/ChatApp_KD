import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SigupLogic extends GetxController {
  
  TextEditingController nameController = TextEditingController() ;
  TextEditingController emailController = TextEditingController() ;
  TextEditingController passwordController = TextEditingController() ;
  final FirebaseAuth _auth = FirebaseAuth.instance ;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance ;

  Future<void> sigupUser()async{
    
    String name = nameController.text ;
    String email = nameController.text ;
    String password = nameController.text ;
    
    if(name.isEmpty|| email.isEmpty||password.isEmpty){
      Get.snackbar(
          "Error",
          "Please fil the all filled");
      return ;
    }
    else{

     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password) ;
     userCredential.
    }
  }
  
}
