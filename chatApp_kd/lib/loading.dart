import 'dart:math';
import 'package:flutter/material.dart';


class LoaderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: RotatingLoader(),
      ),
    );
  }
}

class RotatingLoader extends StatefulWidget {
  @override
  _RotatingLoaderState createState() => _RotatingLoaderState();
}

class _RotatingLoaderState extends State<RotatingLoader> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(vsync: this, duration: Duration(seconds: 1))..repeat();
    _controller2 = AnimationController(vsync: this, duration: Duration(milliseconds: 1100))..repeat();
    _controller3 = AnimationController(vsync: this, duration: Duration(milliseconds: 1150))..repeat();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          buildRotatingCircle(_controller1, Colors.blueAccent, 0),
          buildRotatingCircle(_controller2, Colors.purpleAccent, pi / 6),
          buildRotatingCircle(_controller3, Colors.indigoAccent, -pi / 6),
          Text(
            "Loading...",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildRotatingCircle(AnimationController controller, Color color, double initialAngle) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateX(0.5)
            ..rotateY(initialAngle)
            ..rotateZ(controller.value * 2 * pi),
          child: child,
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 3)),
      ),
    );
  }
}
