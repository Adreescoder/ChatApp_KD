import 'package:chatapp_kd/modles/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

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

  Future<void> createChatRoomId()async {

  }

  Future<void> sigOut()async{
  await  auth.signOut();
  }
}
