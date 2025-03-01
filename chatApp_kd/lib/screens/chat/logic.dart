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

  void sendMessage(String chatRoomId, String messageText,String receiverId){
     String senderId = auth.currentUser!.uid ;
    firestore.collection("ChattingKD").doc(chatRoomId).collection("Message").add({
      senderId : senderId ,
      messageText : messageText ,
   //   DateTime : DateTime.timestamp(),
      receiverId : receiverId ,
    });
  }
}
