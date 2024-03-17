import 'package:chat/Widgets/custom_button.dart';
import 'package:chat/Widgets/custom_textfield.dart';
import 'package:chat/Widgets/show_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:validators/validators.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  static String id = "registerpage";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  bool _obscured1 = false;

  @override
  void initState() {
    _obscured1 = true;
    super.initState();
  }

  void _toggleObscured1() {
    setState(() {
      _obscured1 = !_obscured1;
    });
  }

  GlobalKey<FormState> formkey = GlobalKey();
  bool isLoading = false;

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    double ScreenWidth = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    double ScreenHeight = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
          body: Form(
        key: formkey,
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
                      color: Colors.grey.shade800,
                      fontFamily: "Pacifico"),
                ),
              ),
              SizedBox(height: ScreenHeight * .06),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Text('Register',
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 22,
                        // fontWeight: FontWeight.w500,
                        fontFamily: "Poppins")),
              ),
              CustomTxtField(
                onChange: (data) {
                  email = data;
                },
                // ignore: body_might_complete_normally_nullabl, body_might_complete_normally_nullable
                validate: (data) {
                  if (data.toString().isEmpty) {
                    return "Enter An Email";
                  } else if (isEmail(data) == false) {
                    return "this form isn't acceptable";
                  }
                },
                preicon: const Icon(Icons.email),
                txtlabel: 'Email',
              ),
              SizedBox(height: ScreenHeight * .015),
              CustomTxtField(
                onChange: (data) {
                  password = data;
                },
                // ignore: body_might_complete_normally_nullable
                validate: (data) {
                  if (data.toString().isEmpty) {
                    return "Enter A Password";
                  }
                },
                preicon: const Icon(Icons.lock_rounded),
                obscure: _obscured1,
                suficon: IconButton(
                    onPressed: _toggleObscured1,
                    icon: Icon(
                      _obscured1
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                    )),
                txtlabel: 'Password',
              ),
              SizedBox(height: ScreenHeight * .05),
              CustomButton(
                ButtonLable: "Register",
                ontap: () async {
                  if (formkey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      // ignore: unused_local_variable
                      await registerUser();
                      // ignore: use_build_context_synchronously
                      showSnackBar(context, 'account created successfully');
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'week-password') {
                        // ignore: use_build_context_synchronously
                        showSnackBar(context, 'weak Password');
                      } else if (e.code == 'email-already-in-use') {
                        // ignore: use_build_context_synchronously
                        showSnackBar(context, 'this email already exists');
                      }
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      showSnackBar(context, 'there was an error');
                    }

                    setState(() {
                      isLoading = false;
                    });
                    // ignore: use_build_context_synchronously
                  } else {}
                },
              ),
              SizedBox(
                height: ScreenHeight * .01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already Have An Account ",
                    style: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                      ))
                ],
              )
            ]),
      )),
    );
  }

  Future<void> registerUser() async {
    // ignore: unused_local_variable
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);

    _fireStore
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({"email": email, "uid": userCredential.user!.uid});
  }
}









//   TextField Password_Field_register() {
//     return TextField(
//       obscureText: _obscured1,
//       decoration: InputDecoration(
//         prefixIcon: const Icon(Icons.lock_rounded, size: 24),
//         suffixIcon: IconButton(
//             onPressed: _toggleObscured1,
//             icon: const Icon(Icons.visibility_rounded)),
//         label: const Text("Password"),
//         labelStyle: const TextStyle(color: Colors.black87),
//         focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(width: 2, color: Colors.black)),
//         enabledBorder: const OutlineInputBorder(
//           borderSide:
//               BorderSide(width: 2, color: Colors.black38), //<-- SEE HERE
//         ),
//       ),
//     );
//   }
// }

// class Email_field_register extends StatelessWidget {
//   const Email_field_register({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return const TextField(
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

