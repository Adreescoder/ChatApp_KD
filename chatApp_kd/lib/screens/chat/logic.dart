import 'package:chatapp_kd/modles/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatLogic extends GetxController {
  TextEditingController messageController = TextEditingController() ;

  var message = <Message>[].obs ;
  FirebaseFirestore firestore = FirebaseFirestore.instance ;
  FirebaseAuth auth = FirebaseAuth.instance ;

  Future<void> sendMessage(String chatRoomId, String messageText, String receiverId) async {
    try {
      String senderId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('Chatting').doc(chatRoomId).collection('Messages').add({
        'senderId': senderId,
        'receiverId': receiverId,
        'messageText': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e');
    }
  }
}
