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
  Map<String, int>? reactions; // Reactions with count {'❤️': 5, '😂': 3}
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
  Map<String, Timestamp>? readBy; // Read receipts in group chat
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
    this.isPoll,
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
      isPoll: map['isPoll'],
      deviceId: map['deviceId'],
    );
  }
}
