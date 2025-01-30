import 'package:flutter/material.dart';

class FlipLoginSignupScreen extends StatefulWidget {
  @override
  _FlipLoginSignupScreenState createState() => _FlipLoginSignupScreenState();
}

class _FlipLoginSignupScreenState extends State<FlipLoginSignupScreen> {
  bool isLogin = true; // Toggle state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              isLogin = !isLogin;
            });
          },
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final rotate = Tween(begin: 1.0, end: 0.0).animate(animation);
              return AnimatedBuilder(
                animation: rotate,
                builder: (context, childWidget) {
                  final value = rotate.value;
                  return Transform(
                    transform: Matrix4.rotationY(value * 3.1416),
                    alignment: Alignment.center,
                    child: childWidget,
                  );
                },
                child: child,
              );
            },
            child: isLogin ? loginForm() : signupForm(),
          ),
        ),
      ),
    );
  }

  Widget loginForm() {
    return formContainer(
      key: ValueKey(1),
      title: "Log In",
      fields: [
        animatedInputField("Email", Icons.email),
        animatedInputField("Password", Icons.lock, isPassword: true),
      ],
      buttonText: "Let's Go!",
    );
  }

  Widget signupForm() {
    return formContainer(
      key: ValueKey(2),
      title: "Sign Up",
      fields: [
        animatedInputField("Name", Icons.person),
        animatedInputField("Email", Icons.email),
        animatedInputField("Password", Icons.lock, isPassword: true),
      ],
      buttonText: "Confirm!",
    );
  }

  Widget formContainer({required Key key, required String title, required List<Widget> fields, required String buttonText}) {
    return Container(
      key: key,
      width: 300,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0077BE), Color(0xFF3B8DF2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 7,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 15),
          ...fields,
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isLogin = !isLogin;
              });
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              backgroundColor: Color(0xFF3B8DF2),
              shadowColor: Colors.black,
              elevation: 5,
            ),
            child: Text(buttonText, style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget animatedInputField(String hint, IconData icon, {bool isPassword = false}) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400),
      tween: Tween<double>(begin: 50, end: 0),
      builder: (context, double value, child) {
        return Opacity(
          opacity: (50 - value) / 50,
          child: Transform.translate(
            offset: Offset(0, value),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: TextField(
          obscureText: isPassword,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            prefixIcon: Icon(icon, color: Colors.white),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }
}
