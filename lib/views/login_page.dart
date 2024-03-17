// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:chat/Widgets/custom_button.dart';
import 'package:chat/Widgets/custom_textfield.dart';
import 'package:chat/Widgets/show_snack_bar.dart';
import 'package:chat/views/home_page.dart';
import 'package:chat/views/register_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:validators/validators.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  static String id = "loginpage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  bool _obscured = false;

  @override
  void initState() {
    _obscured = true;
    super.initState();
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  GlobalKey<FormState> loginformkey = GlobalKey();

  String? email;
  String? password;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    var ScreenWidth = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    var ScreenHeight = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        // backgroundColor: Colors.grey.shade300,
        body: Form(
          key: loginformkey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, ScreenHeight * .06, 0, 20),
                  width: ScreenWidth * .36,
                  child: Image.asset('assets/images/Chat_Icon.png'),
                ),
              ),
              Center(
                child: Text(
                  'Chatti',
                  style: TextStyle(
                      fontSize: 34,
                      fontFamily: "Pacifico",
                      color: Colors.grey.shade800),
                ),
              ),
              SizedBox(height: ScreenHeight * .06),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Text('Sign In',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.grey.shade800,
                        // fontWeight: FontWeight.w500,
                        fontFamily: "Poppins")),
              ),
              CustomTxtField(
                preicon: const Icon(Icons.email),
                txtlabel: 'Email',
                onChange: (data) {
                  email = data;
                },
                // ignore: body_might_complete_normally_nullable
                validate: (data) {
                  if (data.toString().isEmpty) {
                    return "Enter An Email";
                  } else if (isEmail(data) != true) {
                    return "this form isn't acceptable";
                  }
                },
              ),
              SizedBox(height: ScreenHeight * .015),
              CustomTxtField(
                preicon: const Icon(Icons.lock_rounded),
                obscure: _obscured,
                suficon: IconButton(
                    onPressed: _toggleObscured,
                    icon: Icon(
                      _obscured
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                    )),
                txtlabel: 'Password',
                onChange: (data) {
                  password = data;
                },
                // ignore: body_might_complete_normally_nullable
                validate: (data) {
                  if (data.toString().isEmpty) {
                    return "Enter An Password";
                  }
                },
              ),
              SizedBox(height: ScreenHeight * .05),
              CustomButton(
                ontap: () async {
                  if (loginformkey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      await loginUser();
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, HomePage.id,
                          arguments: email);

                      // ignore: use_build_context_synchronously
                      // showSnackBar(context, "logged in successfully");
                    } on FirebaseAuthException catch (ex) {
                      if (ex.code == 'user-not-found') {
                        // ignore: use_build_context_synchronously
                        showSnackBar(context, 'No user found for that email.');
                      } else if (ex.code == 'wrong-password') {
                        // ignore: use_build_context_synchronously
                        showSnackBar(
                            context, 'Wrong password provided for that user.');
                      }
                      // ignore: use_build_context_synchronously
                      // showSnackBar(context, "email or password is wrong");
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                ButtonLable: "Login",
              ),
              SizedBox(
                height: ScreenHeight * .01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't Have An Account ",
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterPage.id);
                      },
                      child: const Text(
                        "register",
                        style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    // ignore: unused_local_variable
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
    _fireStore.collection('users').doc(userCredential.user!.uid).set(
        {"email": email, "uid": userCredential.user!.uid},
        SetOptions(merge: true));
  }

//   TextField Password_Field_login() {
//     return TextField(
//       obscureText: _obscured,
//       decoration: InputDecoration(
//         prefixIcon: Icon(Icons.lock_rounded, size: 24),
//         suffixIcon: IconButton(
//             onPressed: _toggleObscured, icon: Icon(Icons.visibility_rounded)),
//         label: Text("Password"),
//         labelStyle: TextStyle(color: Colors.black87),
//         focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(width: 2, color: Colors.black)),
//         enabledBorder: OutlineInputBorder(
//           borderSide:
//               BorderSide(width: 2, color: Colors.black38), //<-- SEE HERE
//         ),
//       ),
//     );
//   }
// }

// class Email_Field_login extends StatelessWidget {
//   const Email_Field_login({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: InputDecoration(
//         prefixIcon: Icon(Icons.mail, size: 24),
//         label: Text("Email"),
//         labelStyle: TextStyle(color: Colors.black87),
//         focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(width: 2, color: Colors.black)),
//         enabledBorder: OutlineInputBorder(
//           borderSide:
//               BorderSide(width: 2, color: Colors.black38), //<-- SEE HERE
//         ),
//       ),
//     );
//   }
}
