import 'package:flutter/material.dart';

class TextFaildScreen extends StatelessWidget {
   TextFaildScreen({super.key,this.hintText,this.inputType,this.onchange,this.obscureText,});
  Function(String)? onchange;
  String? hintText;
  bool? obscureText;
  TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText!,
      onChanged: onchange,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(16)
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(16)
        )
      ),
    );
  }
}