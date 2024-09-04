import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        centerTitle: true,
        title: Text(
          'حول شركتنا',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff0c2d86), // تغيير لون شريط التطبيق
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[100], // خلفية خفيفة اللون
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة شعار الشركة
              Center(
                child: Image.asset(
                  'images/7.png', // ضع شعار الشركة في مجلد assets
                  height: 120,
                ),
              ),
              SizedBox(height: 20),
              // عنوان الصفحة
              Center(
                child: Text(
                  'مرحبا بكم في شركتنا',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0c2d86),
                    shadows: [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // قسم عن الشركة
              _buildSection(
                title: 'عن الشركة',
                content:
                    'نحن شركة رائدة في مجال حجوزات القاعات وتقديم الخدمات المتعلقة بها. نقدم لعملائنا مجموعة شاملة من الحلول التي تلبي كافة احتياجاتهم الخاصة بإقامة الفعاليات والمناسبات.',
              ),
              SizedBox(height: 20),
              // قسم رؤيتنا
              _buildSection(
                title: 'رؤيتنا',
                content:
                    'تسعى شركتنا إلى تحقيق التميز والابتكار في تقديم خدماتنا، مع التركيز على رضا العملاء وتقديم تجربة لا تُنسى لكل مناسبة.',
              ),
              SizedBox(height: 20),
              // قسم مهمتنا
              _buildSection(
                title: 'مهمتنا',
                content:
                    'توفير أفضل الحلول والخدمات لعملائنا من خلال فريق عمل محترف ومؤهل، وباستخدام أحدث التقنيات في صناعة الأحداث والفعاليات.',
              ),
              SizedBox(height: 20),
              // قسم اتصل بنا

              SizedBox(height: 20),
              // شكرًا
              Center(
                child: Text(
                  'شكرًا لاهتمامكم!',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget لبناء الأقسام
  Widget _buildSection({required String title, required String content}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xff9d7b23),
            ),
            textAlign: TextAlign.end,
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl, // الاتجاه الصحيح للغة العربية
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
