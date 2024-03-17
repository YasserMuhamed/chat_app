import 'package:chat/Widgets/chat_bubble.dart';
import 'package:chat/Widgets/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage(
      {super.key, required this.recieverEmail, required this.recieverId});

  final String recieverEmail;
  final String recieverId;

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
//
//
  final ScrollController _controller = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.recieverId, _messageController.text);
      _messageController.clear();
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: Text(widget.recieverEmail),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _textCard(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.recieverId, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Has Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("waiting ...");
          }
          return ListView(
            controller: _controller,
            reverse: true,
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot docement) {
    Map<String, dynamic> data = docement.data() as Map<String, dynamic>;

    // var alignment = (data["senderId"] == _firebaseAuth.currentUser!.uid)
    //     ? Alignment.centerRight
    //     : Alignment.centerLeft;

    // return Container(
    //   alignment: alignment,
    //   child: Column(
    //     children: [
    //       Text(data["senderEmail"]),
    //       Text(data["message"]),
    //     ],
    //   ),
    // );
    if ((data["senderId"] == _firebaseAuth.currentUser!.uid)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              data["senderEmail"],
            ),
          ),
          SendChatBubbel(message: data["message"]),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(data["senderEmail"]),
          ),
          RecieveChatBubbel(message: data["message"]),
        ],
      );
    }
  }

  Padding _textCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shadowColor: Colors.grey.shade600,
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: (data) {
                        sendMessage();
                      },
                      style: const TextStyle(
                        fontFamily: "NotoSansArabic",
                      ),
                      // minLines: 1,
                      // maxLines: 2,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        hintText: "Type Something ...",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: Colors.transparent)),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide:
                              BorderSide(width: 2, color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey.shade800,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            height: 50,
            width: 50,
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
