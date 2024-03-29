import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      this.ontap,
      required this.buttonLabel,
      this.buttonColor,
      this.fontColor,
      this.height,
      this.width});

  final String buttonLabel;
  Color? fontColor;
  Color? buttonColor;
  double? height;
  double? width;
  VoidCallback? ontap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: ontap ?? () {},
        style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor ?? Colors.blueGrey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        child: Text(
          buttonLabel,
          style: TextStyle(color: fontColor ?? Colors.white, fontSize: 22),
        ),
      ),
    );
  }
}
