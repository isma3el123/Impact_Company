import 'package:flutter/material.dart';
import 'package:flutter_application_16/Screen/Login_Screen/login.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          _buildPage(
            'مرحبا بك في مركز تطويرنا!',
            'في مركزنا، نقدم لك فرصاً متميزة في التطوير والتدريب لتحسين مهاراتك وتوسيع آفاقك المهنية. استعد لاكتشاف مجموعة من البرامج التدريبية والخدمات التي ستساعدك على الوصول إلى أهدافك.',
            Icons.waving_hand,
            'images/5.png',
          ),
          _buildPage(
            'تدريب مخصص لمهاراتك',
            'استفد من برامجنا التدريبية المتنوعة التي تغطي مجالات مختلفة مثل البرمجة، الإدارة، التسويق، والعديد من التخصصات الأخرى. نحن هنا لدعمك في كل خطوة على الطريق لتحقيق النجاح في مجالك.',
            Icons.bookmarks,
            'images/6.png',
          ),
          _buildPage(
            'احجز الآن وابدأ رحلتك',
            'تتيح لك منصتنا حجز المواعيد بسهولة واختيار البرامج التدريبية التي تناسب احتياجاتك. إذا كان لديك أي استفسار، لا تتردد في التواصل معنا للحصول على الدعم والمساعدة التي تحتاجها.',
            Icons.beenhere,
            'images/7.png',
          ),
        ],
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildPageIndicator(),
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildPage(
      String title, String description, IconData icon, String imagePath) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imagePath,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Icon(icon, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,

              color: Colors.blue,
              fontFamily: 'Arial', // استخدم خطًا مناسبًا للغة العربية
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                description,
                textDirection: TextDirection.rtl, // الاتجاه الصحيح للغة العربية
                textAlign: TextAlign
                    .justify, // محاذاة النص بشكل متساوٍ على اليمين واليسار
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontFamily: 'Arial', // استخدم خطًا مناسبًا للغة العربية
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildDot(0),
        _buildDot(1),
        _buildDot(2),
      ],
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.blue : Colors.grey,
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildSkipButton(),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildSkipButton() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Text('تخطي',
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue,
            fontWeight: FontWeight.w900,
          )),
    );
  }

  Widget _buildNextButton() {
    return TextButton(
      onPressed: () {
        if (_pageController.page == 2) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          _pageController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      },
      child: Text('التالي',
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue,
            fontWeight: FontWeight.w900,
          )),
    );
  }
}
