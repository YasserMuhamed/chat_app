import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class SendChatBubble extends StatelessWidget {
  const SendChatBubble({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      clipper: ChatBubbleClipper6(type: BubbleType.sendBubble),
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(top: 4, bottom: 20),
      backGroundColor: Colors.blue,
      child: Container(
        padding: const EdgeInsets.only(left: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontFamily: "NotoSansArabic"),
        ),
      ),
    );
  }
}

class RecieveChatBubbel extends StatelessWidget {
  const RecieveChatBubbel({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 4, bottom: 20),
      backGroundColor: Color(0xffE7E7ED),
      child: Container(
        padding: const EdgeInsets.only(left: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.black, fontFamily: "NotoSansArabic"),
        ),
      ),
    );
  }
}
