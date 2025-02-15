import 'dart:math';

import 'package:chatapp_kd/modles/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomeLogic logic = Get.put(HomeLogic());
  final FirebaseAuth _auth = FirebaseAuth.instance; // ✅ FirebaseAuth added

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            logic.sigOut();
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: logic.getUserFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No users found"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              final user = snapshot.data![i];
              bool isCurrentUser = user.id == _auth.currentUser?.uid;

              return isCurrentUser
                  ? const SizedBox() // ✅ Hide current user
                  : Card(
                elevation: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  onTap: () {
                    logic.createChatRoomId(
                      user.id,
                      user.name,
                      user.imageUrl, // Profile Image URL
                      true, // Online Status
                    );
                  },
                  leading: GestureDetector(
                    onTap: () {
                      _showImageDialog(context, user.imageUrl);
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: NetworkImage(user.imageUrl),
                    ),
                  ),
                  title: Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ✅ Image Dialog Function Added
  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
