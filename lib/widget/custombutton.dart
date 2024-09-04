import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({super.key, this.ontap, required this.text});
  VoidCallback? ontap;
  String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Color(0xff0c2d86),
                    Color.fromARGB(255, 81, 119, 245)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10, color: Colors.grey, offset: Offset(5, 10))
                ]),
            child: Center(
                child: Text(
              text,
              style:
                  TextStyle(color: Colors.amber, fontWeight: FontWeight.w900),
            )),
          ),
        ),
        onTap: ontap);
  }
}
