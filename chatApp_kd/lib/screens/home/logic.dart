import 'package:chatapp_kd/modles/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeLogic extends GetxController {
  List<UserModel> myUsers = [];
  var myFbAuth = FirebaseAuth.instance;
  var myFbFs = FirebaseFirestore.instance;

  // Fetch all users from Firebase
  Future<List<UserModel>> getUsersOnFirebase() async {
    try {
      myUsers.clear(); // ✅ FIXED: Clear the list before fetching

      QuerySnapshot myAllDocs = await myFbFs.collection('KD').get();
      for (var element in myAllDocs.docs) {
        UserModel myUser = UserModel.fromJson(element.data() as Map<String, dynamic>);

        // ✅ FIXED: Avoid adding duplicate users
        if (!myUsers.any((user) => user.id == myUser.id)) {
          myUsers.add(myUser);
        }
      }
      return myUsers;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch users: $e");
      return [];
    }
  }
}
