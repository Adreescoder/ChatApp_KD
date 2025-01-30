import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ToggleController extends GetxController {
  var selectedIndex = 0.obs;
}

class ToggleButton extends StatelessWidget {
  final ToggleController controller = Get.put(ToggleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Obx(
              () => AnimatedContainer(
            duration: Duration(milliseconds: 700),
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(controller.selectedIndex.value == 0
                  ? -0.3
                  : controller.selectedIndex.value == 2
                  ? 0.35
                  : 0.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.greenAccent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.transparent,
            ),
            width: 180,
            height: 40,
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 150),
                  left: controller.selectedIndex.value * 60.0,
                  child: Container(
                    width: 60,
                    height: 40,
                    color: Colors.greenAccent,
                  ),
                ),
                Row(
                  children: List.generate(3, (index) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => controller.selectedIndex.value = index,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Option ${index + 1}',
                            style: TextStyle(
                              color: controller.selectedIndex.value == index
                                  ? Colors.black
                                  : Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
