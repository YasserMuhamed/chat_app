import 'package:chat/views/login_page.dart';
import 'package:chat/views/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String id = "homepage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //
    Future<void> signOut() async {
      await FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      await Navigator.pushNamed(context, LoginPage.id);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: Text(
          "ChatApp",
          style: TextStyle(fontFamily: "Pacifico", color: Colors.grey.shade800),
        ),
        centerTitle: true,
      ),
      body: _streamBuilder(),
    );
  }

  Widget _streamBuilder() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Has Error"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("waiting ..."));
          }
          return ListView(
              children: snapshot.data!.docs
                  .map<Widget>((doc) => _builderUserListItem(doc))
                  .toList());
        });
  }

  Widget _builderUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    if (_auth.currentUser!.email != data["email"]) {
      return ListTile(
        title: Card(
          shadowColor: Colors.grey.shade600,
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              data["email"],
              style: const TextStyle(fontFamily: "Poppins", fontSize: 16),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewChatPage(
                        recieverEmail: data["email"],
                        recieverId: data["uid"],
                      )));
        },
      );
    } else {
      return Container();
    }
  }
}
