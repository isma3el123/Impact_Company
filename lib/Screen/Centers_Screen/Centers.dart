import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Centers_Model.dart';
import 'package:flutter_application_16/Service/Service_Centers/Get_Service.dart';

class Centers extends StatefulWidget {
  @override
  _CenterPageState createState() => _CenterPageState();
}

class _CenterPageState extends State<Centers> {
  late Future<List<CentersModel>> _centerFuture;

  @override
  void initState() {
    super.initState();
    _centerFuture = ServicegGetCenters().fetchCenters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder<List<CentersModel>>(
            future: _centerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Container(
                  height: 200,
                  color: Colors.red,
                  child: Center(child: Text('Error: ${snapshot.error}')),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Center(child: Text('No images available')),
                );
              } else {
                final centers = snapshot.data!;
                final imageUrls =
                    centers.map((center) => center.media).toList();
                return SlidingImageWidget(imageUrls: imageUrls);
              }
            },
          ),
        ],
      ),
    );
  }
}

class SlidingImageWidget extends StatefulWidget {
  final List<String> imageUrls;

  SlidingImageWidget({required this.imageUrls});

  @override
  _SlidingImageWidgetState createState() => _SlidingImageWidgetState();
}

class _SlidingImageWidgetState extends State<SlidingImageWidget> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Timer to auto-scroll images
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % widget.imageUrls.length;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    // Listen to page changes
    _pageController.addListener(() {
      final page = _pageController.page;
      if (page != null) {
        setState(() {
          _currentPage = page.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
            ),
            clipBehavior: Clip.antiAlias,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                return Image.network(widget.imageUrls[index],
                    fit: BoxFit.fitWidth);
              },
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
            ),
          ),

          // Space between image slider and progress bar
          SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.fromLTRB(150, 0, 0, 0),
            // Adjust this to move the progress bar
            child: Container(
                height: 20,
                width: 200,
                child: CustomPaint(
                  painter: ProgressBarPainter(
                    currentPage: _currentPage,
                    totalPages: widget.imageUrls.length,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class ProgressBarPainter extends CustomPainter {
  final int currentPage;
  final int totalPages;

  ProgressBarPainter({
    required this.currentPage,
    required this.totalPages,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    final double dotRadius = 6.0;
    final double spacing = 8.0;
    final double totalWidth = (dotRadius * 2 + spacing) * totalPages - spacing;

    for (int i = 0; i < totalPages; i++) {
      paint.color =
          i == currentPage ? Color.fromARGB(255, 255, 183, 0) : Colors.grey;
      final double x = (dotRadius * 2 + spacing) * i;
      canvas.drawCircle(
          Offset(x + dotRadius, size.height / 2), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    final oldPainter = oldDelegate as ProgressBarPainter;
    return oldPainter.currentPage != currentPage ||
        oldPainter.totalPages != totalPages;
  }
}
