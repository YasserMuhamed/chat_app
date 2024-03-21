import 'package:flutter/material.dart';
// import 'package:validators/validators.dart';

// ignore: must_be_immutable
class CustomTxtField extends StatelessWidget {
  CustomTxtField(
      {super.key,
      this.preicon,
      this.txtlabel,
      this.onChange,
      this.suficon,
      this.obscure,
      this.validate,
      this.key_type});
  bool? obscure;
  Icon? preicon;
  IconButton? suficon;
  String? txtlabel;
  Function(String)? onChange;
  FormFieldValidator? validate;
  TextInputType? key_type;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: key_type ?? TextInputType.name,
      validator: validate,
      obscureText: obscure ?? false,
      onChanged: onChange,
      decoration: InputDecoration(
        fillColor: Colors.grey.shade200,
        filled: true,
        suffixIcon: suficon,
        prefixIcon: preicon,
        hintText: txtlabel,
        hintStyle: const TextStyle(color: Colors.grey),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.white)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.grey.shade200),
        ),
        // ignore: prefer_const_constructors
        errorBorder: OutlineInputBorder(
          borderSide: (const BorderSide(
              width: 2, color: Color.fromRGBO(183, 28, 28, 0.6))),
        ),

        // ignore: prefer_const_constructors
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 2, color: Color.fromRGBO(183, 28, 28, .6))),
      ),
    );
  }
}
