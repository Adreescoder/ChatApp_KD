import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../modles/message.dart';

class TestChatLogic extends GetxController {
  RxList<Message> messages = <Message>[].obs;
  RxBool isTyping = false.obs;
  RxString replyToMessage = ''.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Send Message to Firestore
  void sendMessage(String text, String senderId, String receiverId) async {
    Message newMessage = Message(
      id: _firestore.collection('messages').doc().id,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      messageType: 'text',
      isRead: false,
      status: 'sent',
      timestamp: Timestamp.now(),
    );

    await _firestore.collection('messages').doc(newMessage.id).set(newMessage.toMap());
    messages.add(newMessage);
  }

  // ✅ Delete Message
  void deleteMessage(String messageId) async {
    await _firestore.collection('messages').doc(messageId).delete();
    messages.removeWhere((msg) => msg.id == messageId);
  }

  // ✅ Edit Message
  void editMessage(String messageId, String newText) async {
    await _firestore.collection('messages').doc(messageId).update({
      'text': newText,
      'isEdited': true,
    });

    int index = messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      messages[index].text = newText;
      messages[index].isEdited = true;
      messages.refresh();
    }
  }

  // ✅ Send Reaction
  void sendReaction(String messageId, String reaction) async {
    int index = messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      messages[index].reactions ??= {};
      messages[index].reactions![reaction] = (messages[index].reactions![reaction] ?? 0) + 1;
      messages.refresh();

      await _firestore.collection('messages').doc(messageId).update({
        'reactions': messages[index].reactions,
      });
    }
  }

  // ✅ Toggle Typing Indicator
  void toggleTyping(bool value) {
    isTyping.value = value;
  }

  // ✅ Set Reply Message
  void setReplyTo(String messageText) {
    replyToMessage.value = messageText;
  }

  // ✅ Fetch Messages Real-time from Firestore
  void fetchMessages(String senderId, String receiverId) {
    _firestore
        .collection('messages')
        .where('senderId', whereIn: [senderId, receiverId])
        .where('receiverId', whereIn: [senderId, receiverId])
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList();
    });
  }

  @override
  void onInit() {
    super.onInit();
    fetchMessages("user1", "user2"); // 🔹 Actual user IDs replace karo
  }
}
