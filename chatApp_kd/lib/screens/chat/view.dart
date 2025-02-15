import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key}) : super(key: key);

  final ChatLogic logic = Get.put(ChatLogic());

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
