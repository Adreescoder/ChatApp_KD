import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'logic.dart';

class SignupScreen extends StatelessWidget {
  final SignupScreenLogic logic = Get.put(SignupScreenLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: logic.nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: logic.emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: logic.passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Obx(() => logic.isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: logic.signupFirebase,
              child: Text("Signup"),
            )),
          ],
        ),
      ),
    );
  }
}
