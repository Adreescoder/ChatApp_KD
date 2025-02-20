import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modles/message.dart';
import 'logic.dart';

class TestChatPage extends StatelessWidget {
  TestChatPage({Key? key}) : super(key: key);

  final TestChatLogic logic = Get.put(TestChatLogic());
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => logic.messages.isEmpty
                ? Center(child: Text("No messages yet"))
                : ListView.builder(
              reverse: true,
              itemCount: logic.messages.length,
              itemBuilder: (context, index) {
                Message msg = logic.messages[index];
                return ChatBubble(msg: msg);
              },
            )),
          ),

          // Typing Indicator
          Obx(() => logic.isTyping.value
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Typing..."),
            ),
          )
              : SizedBox()),

          // Message Input Field
          ChatInputField(chatController: logic, messageController: messageController),
        ],
      ),
    );
  }
}

// 🔹 Chat Bubble Widget
class ChatBubble extends StatelessWidget {
  final Message msg;
  ChatBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    bool isSender = msg.senderId == "user1"; // Replace with actual user logic

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSender ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(msg.text, style: TextStyle(color: isSender ? Colors.white : Colors.black)),
            if (msg.isEdited)
              Text("Edited", style: TextStyle(fontSize: 10, color: Colors.grey)),
            if (msg.reactions != null)
              Wrap(
                children: msg.reactions!.entries.map((e) => Text("${e.key} ${e.value}")).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Message Input Field
class ChatInputField extends StatelessWidget {
  final TestChatLogic chatController;
  final TextEditingController messageController;

  ChatInputField({required this.chatController, required this.messageController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              onChanged: (value) => chatController.toggleTyping(value.isNotEmpty),
              decoration: InputDecoration(hintText: "Type a message...", border: InputBorder.none),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                chatController.sendMessage(messageController.text, "user1", "user2");
                messageController.clear();
                chatController.toggleTyping(false);
              }
            },
          ),
        ],
      ),
    );
  }
}
