import 'package:flutter/material.dart';

class LikeHeart extends StatefulWidget {
  @override
  _LikeHeartState createState() => _LikeHeartState();
}

class _LikeHeartState extends State<LikeHeart> {
  bool _isLiked = false; // لتخزين حالة الإعجاب (مثل/عدم إعجاب)

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          _isLiked ? 'تم الاعجاب' : 'تسجيل الاعجاب',
          style: TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        IconButton(
          iconSize: 20,
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? Colors.red : Colors.grey,
          ),
          onPressed: _toggleLike,
        ),
      ],
    );
  }
}
