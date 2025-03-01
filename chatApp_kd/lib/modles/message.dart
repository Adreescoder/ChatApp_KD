import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String senderId;
  String receiverId;
  String text;
  String messageType; // 'text', 'image', 'video', 'audio'
  bool isRead;
  String status; // 'sent', 'delivered', 'read'
  Timestamp timestamp;
  String? replyToMessageId;
  Map<String, int>? reactions;
  bool isEdited;
  bool isDeleted;
  String? audioUrl;
  int? audioDuration;
  Timestamp? seenAt;
  Timestamp? expiresAt;
  String? forwardedFrom;
  String? encryptedText;
  String? decryptionKey;
  bool isTyping;
  Map<String, Timestamp>? readBy;
  bool isPinned;
  Timestamp? deliveredAt;
  Map<String, int>? pollOptions;
  bool? isPoll;
  String? deviceId;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.messageType,
    required this.isRead,
    required this.status,
    required this.timestamp,
    this.replyToMessageId,
    this.reactions,
    this.isEdited = false,
    this.isDeleted = false,
    this.audioUrl,
    this.audioDuration,
    this.seenAt,
    this.expiresAt,
    this.forwardedFrom,
    this.encryptedText,
    this.decryptionKey,
    this.isTyping = false,
    this.readBy,
    this.isPinned = false,
    this.deliveredAt,
    this.pollOptions,
    this.isPoll = false,
    this.deviceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'messageType': messageType,
      'isRead': isRead,
      'status': status,
      'timestamp': timestamp,
      'replyToMessageId': replyToMessageId,
      'reactions': reactions,
      'isEdited': isEdited,
      'isDeleted': isDeleted,
      'audioUrl': audioUrl,
      'audioDuration': audioDuration,
      'seenAt': seenAt,
      'expiresAt': expiresAt,
      'forwardedFrom': forwardedFrom,
      'encryptedText': encryptedText,
      'decryptionKey': decryptionKey,
      'isTyping': isTyping,
      'readBy': readBy,
      'isPinned': isPinned,
      'deliveredAt': deliveredAt,
      'pollOptions': pollOptions,
      'isPoll': isPoll,
      'deviceId': deviceId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      text: map['text'],
      messageType: map['messageType'],
      isRead: map['isRead'],
      status: map['status'],
      timestamp: map['timestamp'],
      replyToMessageId: map['replyToMessageId'],
      reactions: map['reactions'] != null ? Map<String, int>.from(map['reactions']) : null,
      isEdited: map['isEdited'] ?? false,
      isDeleted: map['isDeleted'] ?? false,
      audioUrl: map['audioUrl'],
      audioDuration: map['audioDuration'],
      seenAt: map['seenAt'],
      expiresAt: map['expiresAt'],
      forwardedFrom: map['forwardedFrom'],
      encryptedText: map['encryptedText'],
      decryptionKey: map['decryptionKey'],
      isTyping: map['isTyping'] ?? false,
      readBy: map['readBy'] != null ? Map<String, Timestamp>.from(map['readBy']) : null,
      isPinned: map['isPinned'] ?? false,
      deliveredAt: map['deliveredAt'],
      pollOptions: map['pollOptions'] != null ? Map<String, int>.from(map['pollOptions']) : null,
      isPoll: map['isPoll'] ?? false,
      deviceId: map['deviceId'],
    );
  }

  Future<void> sendMessage() async {
    await FirebaseFirestore.instance.collection('messages').doc(id).set(toMap());
  }

  Future<void> updateMessage() async {
    isEdited = true;
    await FirebaseFirestore.instance.collection('messages').doc(id).update(toMap());
  }

  Future<void> deleteMessage() async {
    isDeleted = true;
    await FirebaseFirestore.instance.collection('messages').doc(id).update({'isDeleted': true});
  }

  Future<void> markAsRead() async {
    isRead = true;
    seenAt = Timestamp.now();
    await FirebaseFirestore.instance.collection('messages').doc(id).update({'isRead': true, 'seenAt': seenAt});
  }

  Future<void> addReaction(String emoji) async {
    reactions ??= {};
    reactions![emoji] = (reactions![emoji] ?? 0) + 1;
    await updateMessage();
  }

  Future<void> removeReaction(String emoji) async {
    if (reactions != null && reactions!.containsKey(emoji)) {
      reactions!.remove(emoji);
      await updateMessage();
    }
  }

  Future<void> markAsDelivered() async {
    status = 'delivered';
    deliveredAt = Timestamp.now();
    await FirebaseFirestore.instance.collection('messages').doc(id).update({'status': 'delivered', 'deliveredAt': deliveredAt});
  }

  Future<void> votePoll(String option) async {
    if (isPoll == true && pollOptions != null) {
      pollOptions![option] = (pollOptions![option] ?? 0) + 1;
      await updateMessage();
    }
  }

  void encryptMessage(String key) {
    decryptionKey = key;
    encryptedText = 'Encrypted(${text})';
    text = '[Encrypted Message]';
  }

  void decryptMessage() {
    if (encryptedText != null && decryptionKey != null) {
      text = encryptedText!.replaceFirst('Encrypted(', '').replaceFirst(')', '');
    }
  }

  Future<void> forwardMessage(String newReceiverId) async {
    Message forwarded = Message(
      id: FirebaseFirestore.instance.collection('messages').doc().id,
      senderId: senderId,
      receiverId: newReceiverId,
      text: text,
      messageType: messageType,
      isRead: false,
      status: 'sent',
      timestamp: Timestamp.now(),
      forwardedFrom: id,
    );
    await forwarded.sendMessage();
  }

  Future<void> togglePin() async {
    isPinned = !isPinned;
    await updateMessage();
  }
}
