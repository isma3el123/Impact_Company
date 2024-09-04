import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Color color;
  final Color backgroundColor;
  double size;
  final Color borderColor;
  String? text;
  IconData? icon;
  bool isicon;
  AppButton(
      {super.key,
      this.isicon = false,
      this.text = "HI",
      this.icon,
      required this.backgroundColor,
      required this.borderColor,
      required this.color,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1),
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: isicon == false
            ? Text(
                text!,
                style: TextStyle(color: color),
              )
            : Icon(
                icon,
                color: color,
              ),
      ),
    );
  }
}
