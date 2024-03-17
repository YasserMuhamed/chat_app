import 'package:chat/models/new_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//Send Message

// Get Users info
  Future<void> sendMessage(String reciverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

// Create New Message

    NewChatModel newMessage = NewChatModel(
      message: message,
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      reciverId: reciverId,
      timestamp: timestamp,
    );

    //Construct Chat Room Id For Current User and Reciever

    List<String> ids = [currentUserId, reciverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    //add data to firestore

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //Get Message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}
