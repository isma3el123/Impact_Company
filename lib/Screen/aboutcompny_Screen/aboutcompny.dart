import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_16/Screen/Home_Page.dart';
import 'package:flutter_application_16/Screen/Screen_Attendances/attendance_home.dart';
import 'package:flutter_application_16/Screen/Screen_Trinings/trining_home.dart';
import 'package:flutter_application_16/Screen/aboutcompny_Screen/aboutcompany.dart';

class Aboutcompny extends StatefulWidget {
  @override
  _AboutcompnyState createState() => _AboutcompnyState();
}

class _AboutcompnyState extends State<Aboutcompny> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ImageFadeDemo(), // عرض صورة متحركة
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: CurvedNavigationBar(
                key: _bottomNavigationKey,
                index: _page,
                items: <Widget>[
                  _buildNavBarIcon(Icons.home, 'الرئيسية', 0),
                  _buildNavBarIcon(Icons.list, 'حول الشركة', 1),
                  _buildNavBarIcon(Icons.compare_arrows, 'الحضور', 2),
                  _buildNavBarIcon(Icons.call_split, 'التدريبات', 3),
                ],
                color: Color(0xFF0c2d86),
                buttonBackgroundColor: Colors.white,
                backgroundColor: Colors.transparent,
                animationCurve: Curves.easeInOut,
                animationDuration: Duration(milliseconds: 600),
                onTap: (index) {
                  setState(() {
                    _page = index;
                  });

                  switch (index) {
                    case 0:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CombinedPage(),
                        ),
                      );
                      break;
                    case 1:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Aboutcompny(),
                        ),
                      );

                      break;
                    case 2:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Attendanceshome(),
                        ),
                      );
                      break;
                    case 3:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Trainingshome(),
                        ),
                      );
                      break;
                  }
                },
                letIndexChange: (index) => true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarIcon(IconData icon, String label, int index) {
    bool isActive = _page == index;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isActive ? Color(0xFF9d7b23) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 30.0,
            color: isActive ? Colors.black : Colors.white,
          ),
        ),
        SizedBox(height: 4.0),
        if (!isActive)
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
      ],
    );
  }
}

class ImageFadeDemo extends StatefulWidget {
  @override
  _ImageFadeDemoState createState() => _ImageFadeDemoState();
}

class _ImageFadeDemoState extends State<ImageFadeDemo>
    with SingleTickerProviderStateMixin {
  final List<String> _imagePaths = [
    'images/1.jpg',
    'images/2.jpg',
    'images/3.jpg'
  ];
  int _currentIndex = 0;
  late Timer _timer;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    );

    _startImageTransition();
  }

  void _startImageTransition() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _imagePaths.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: AboutUsPage());
  }
}
