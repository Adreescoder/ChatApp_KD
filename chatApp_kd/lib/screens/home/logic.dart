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

  Future<void> createChatRoomId(String otherUserId, String receiverName, String receiverImage, bool isOnline) async {
    try {
      String currentUserId = auth.currentUser!.uid;
      String chatRoomId = currentUserId.hashCode <= otherUserId.hashCode
          ? "$currentUserId-$otherUserId"
          : "$otherUserId-$currentUserId";

      DocumentSnapshot chatRoomDoc = await firestore.collection("Chats").doc(chatRoomId).get();

      if (!chatRoomDoc.exists) {

        await firestore.collection('ChatsRoomId').doc(chatRoomId).set({
          'chatRoomId': chatRoomId,
          'participants': [currentUserId, otherUserId],
          'createdAt': FieldValue.serverTimestamp(),
        });
        if (kDebugMode) {
          print("✅ New Chat Room Created: $chatRoomId");
        }
      } else {
        if (kDebugMode) {
          print("⚡ Chat Room Already Exists: $chatRoomId");
        }
      }
      // Navigate to ChatPage
      Get.to(() => ChatPage(
        chatRoomId: chatRoomId,
        receiverId: otherUserId,
        receiverName: receiverName,
        receiverImage: receiverImage,
        isOnline: isOnline,
      ));
    } catch (e) {
      Get.snackbar("Error", "❌ Failed to create chat room: $e");
    }
  }


  Future<void> sigOut()async{
  await  auth.signOut();
  }
}
