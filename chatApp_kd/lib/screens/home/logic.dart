import 'package:chatapp_kd/modles/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../chat/view.dart';

class HomeLogic extends GetxController {
  List<UserModel> userModelList = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance ;

  Future<List<UserModel>> getUserFirebase() async {
    QuerySnapshot data = await firestore.collection("users").get();

    // 🔥 Clear list to prevent duplicates
    userModelList.clear();

    // ✅ Corrected Loop
    for (var element in data.docs) {
      UserModel newUser = UserModel.fromJson(element.data() as Map<String, dynamic>);
      userModelList.add(newUser);
    }

    return userModelList;
  }

  Future<void> createChatRoomId(
      String otherUserId, String receiverName, String receiverImage, bool isOnline) async {
    String currentUserId = auth.currentUser!.uid;

    // ✅ Correct ChatRoomId Generation
    String chatRoomId = currentUserId.hashCode <= otherUserId.hashCode
        ? "$currentUserId-$otherUserId"
        : "$otherUserId-$currentUserId";

    // ✅ Correct Firestore Collection Name
    DocumentSnapshot chatDoc = await firestore.collection("Chats_Man").doc(chatRoomId).get();

    if (!chatDoc.exists) {
      await firestore.collection("Chats_Man").doc(chatRoomId).set({
        'chatRoomId': chatRoomId,
        'participants': [currentUserId, otherUserId],
        'createdAt': FieldValue.serverTimestamp(),
      });

      // ✅ Navigate to ChatPage
      Get.to(() => ChatPage());

      if (kDebugMode) {
        print("✅ New Chat Room Created: $chatRoomId");
      }
    } else {
      if (kDebugMode) {
        print("⚡ Chat Room Already Exists: $chatRoomId");
      }
    }
  }


  Future<void> sigOut()async{
  await  auth.signOut();
  }
}
