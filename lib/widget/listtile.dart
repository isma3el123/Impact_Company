import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  CustomListTile(
      {required this.text,
      required this.icon,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
          ),
          SizedBox(width: 8),
          Icon(
            icon,
            color: Color(0xff9d7b23),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
