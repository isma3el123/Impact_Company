import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  int _currentRating = 0;
  void _rateStar(int rating) {
    setState(() {
      _currentRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$_currentRating',
          style: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.amber),
        ),
        SizedBox(width: 1), // استخدام SizedBox لتحديد التباعد بين الأيقونات

        for (int i = 1; i <= 5; i++)
          IconButton(
            iconSize: 20,
            icon: Icon(
              i <= _currentRating ? Icons.star : Icons.star_border,
              color: Colors.amber,
            ),
            onPressed: () => _rateStar(i),
          ),
      ],
    );
  }
}
