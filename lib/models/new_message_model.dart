import 'package:cloud_firestore/cloud_firestore.dart';

class NewChatModel {
  final String message;
  final String senderId;
  final String senderEmail;
  final String reciverId;

  final Timestamp timestamp;

  NewChatModel(
      {required this.message,
      required this.senderId,
      required this.senderEmail,
      required this.reciverId,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "senderEmail": senderEmail,
      "reciverId": reciverId,
      "timestamp": timestamp,
      "message": message
    };
  }
}
