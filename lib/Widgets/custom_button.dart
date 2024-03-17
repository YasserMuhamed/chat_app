import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({super.key, this.ontap, required this.ButtonLable});

  final String ButtonLable;
  VoidCallback? ontap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      child: Text(
        ButtonLable,
        style: const TextStyle(color: Colors.white, fontSize: 22),
      ),
    );
  }
}
