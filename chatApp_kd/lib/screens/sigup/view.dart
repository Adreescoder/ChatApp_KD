import 'package:chatapp_kd/screens/login/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'logic.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final SignupLogic logic = Get.put(SignupLogic());

  @override
  Widget build(BuildContext context) {
    var smallSize = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Signup",
          style: TextStyle(color: Colors.white), // White text color for better contrast
        ),
        backgroundColor: Colors.purple, // Dark purple background for the AppBar
        elevation: 4, // Optional: Adding slight shadow for elevation
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img.png"),
            fit: BoxFit.cover, // Ensures the image covers the full screen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(

              children: [
                Text("Welcome Sky_Nova".toUpperCase(),style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),
                smallSize
                    ? Center(
                  child: Image.asset(
                    "assets/logo.png",
                    height: 150,
                    width: 150,
                  ),
                )
                    : Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/logo.png",
                    height: 200,
                    width: 200,
                  ),
                ),
                SizedBox(height: 20),
                // Form container with dynamic width based on screen size
                Form(
                  key: logic.formKey,
                  child: SizedBox(
                    width: smallSize ? double.infinity : 500, // Dynamic width
                    child: Column(
                      crossAxisAlignment: smallSize
                          ? CrossAxisAlignment.center // Center align for small screens
                          : CrossAxisAlignment.center, // Left align for large screens
                      children: [
                        TextFormField(
                          controller: logic.nameController,
                          style: TextStyle(color: Colors.white), // White text color
                          decoration: InputDecoration(
                            labelText: "Name",
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your name";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: logic.emailController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        Obx(() => TextFormField(
                          controller: logic.passwordController,
                          obscureText: logic.isPasswordHidden.value,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                logic.isPasswordHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: logic.togglePasswordVisibility,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        )),
                        SizedBox(height: 16),
                        Obx(() => TextFormField(
                          controller: logic.confirmPasswordController,
                          obscureText: logic.isConfirmPasswordHidden.value,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                logic.isConfirmPasswordHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: logic.toggleConfirmPasswordVisibility,
                            ),
                          ),
                          validator: (value) {
                            if (value != logic.passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        )),
                        SizedBox(height: 20),
                        Obx(() => ElevatedButton(
                          onPressed: logic.isLoading.value
                              ? null
                              : logic.signupFirebase,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: logic.isLoading.value
                              ? CircularProgressIndicator(
                              color: Colors.white)
                              : Text(
                            "Signup",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                        SizedBox(height: 20,),
                        TextButton(
                          onPressed: () {
                            Get.to(()=> LoginPage(),
                              transition: Transition.circularReveal,
                              curve: Curves.easeInOutCubic,
                              duration: Duration(milliseconds: 1200),);
                          },
                          child: const Text(
                            "Already have an account? Login",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
