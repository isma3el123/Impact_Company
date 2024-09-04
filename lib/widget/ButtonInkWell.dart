import 'package:flutter/material.dart';

class InkWellButton extends StatelessWidget {
   InkWellButton({super.key,required this.ontap,required this.text});
 VoidCallback? ontap;
   String text;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      child:InkWell(
              onTap: ontap,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.add, color: Colors.white),
                  ],
                ),
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0000FF),
                      Color(0xFF4169E1),
                      Color(0xFF00BFFF),
                      Color(0xFF7DF9FF),
                      Color(0xFF00FFFF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
              ),
            ),
      
      );
}}