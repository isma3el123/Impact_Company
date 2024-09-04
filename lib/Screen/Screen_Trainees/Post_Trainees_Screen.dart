import 'package:flutter/material.dart';
import 'package:flutter_application_16/Screen/Screen_Trainees/Get_Screen_Trainees.dart';
import 'package:flutter_application_16/Service/Service_Trainees/Post_Service.dart';

class PostTraineesScreen extends StatefulWidget {
  @override
  _PostTraineesScreenState createState() => _PostTraineesScreenState();
}

class _PostTraineesScreenState extends State<PostTraineesScreen> {
  final TextEditingController _traineeNameController = TextEditingController();
  final TextEditingController _listAttendanceStatusController =
      TextEditingController();
  final TextEditingController _trainingIdController = TextEditingController();

  Future<void> _sendData() async {
    if (_traineeNameController.text.isEmpty ||
        _listAttendanceStatusController.text.isEmpty ||
        _trainingIdController.text.isEmpty) {
      _showErrorDialog('يرجى ملء جميع الحقول');
      return;
    }

    _showLoadingDialog();

    try {
      final int trainingId = int.tryParse(_trainingIdController.text) ?? 0;

      final result = await PostTrainees().addTrainees(
        traineeName: _traineeNameController.text,
        listAttendanceStatus: _listAttendanceStatusController.text,
        trainingId: trainingId,
      );

      Navigator.of(context).pop();
      _showSuccessDialog();
    } catch (e) {
      Navigator.of(context).pop();
      _showErrorDialog('فشلت عملية الإضافة، يرجى المحاولة مرة أخرى.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('العملية نجحت', style: TextStyle(color: Colors.green)),
          content: Text('تمت عملية الإضافة بنجاح'),
          actions: <Widget>[
            TextButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TraineesPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('خطأ', style: TextStyle(color: Colors.red)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('جاري الإضافة...'),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title: Text('إضافة متدرب', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _traineeNameController,
                decoration: InputDecoration(
                  labelText: 'اسم المتدرب',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                  labelStyle:
                      TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _listAttendanceStatusController,
                decoration: InputDecoration(
                  labelText: 'حالة الحضور',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                  labelStyle:
                      TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _trainingIdController,
                decoration: InputDecoration(
                  labelText: 'رقم التدريب',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                  labelStyle:
                      TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff0c2d86),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'إرسال البيانات',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
