import 'package:chat/firebase_options.dart';
import 'package:chat/views/home_page.dart';
import 'package:chat/views/login_page.dart';
import 'package:chat/views/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.blue,
            selectionHandleColor: Colors.blue,
            selectionColor: Colors.blue.shade100),
      ),
      routes: {
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
        HomePage.id: (context) => const HomePage()
      },
      home: LoginPage(),
    );
  }
}
