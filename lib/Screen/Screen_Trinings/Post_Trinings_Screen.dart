import 'package:flutter/material.dart';
import 'package:flutter_application_16/Screen/Screen_Trinings/Get_Trinings_Screen.dart';
import 'package:flutter_application_16/Service/Service_Trining/Post_Service.dart';

class PostTrainingScreen extends StatefulWidget {
  @override
  _PostTrainingScreenState createState() => _PostTrainingScreenState();
}

class _PostTrainingScreenState extends State<PostTrainingScreen> {
  final TextEditingController _trainingNameController = TextEditingController();
  final TextEditingController _numberOfStudentsController =
      TextEditingController();
  final TextEditingController _trainingDetailsController =
      TextEditingController();
  final TextEditingController _clientIdController = TextEditingController();
  final TextEditingController _trainingInvoiceIdController =
      TextEditingController();

  Future<void> _sendData() async {
    if (_trainingNameController.text.isEmpty ||
        _numberOfStudentsController.text.isEmpty ||
        _trainingDetailsController.text.isEmpty ||
        _clientIdController.text.isEmpty ||
        _trainingInvoiceIdController.text.isEmpty) {
      _showErrorDialog('جميع الحقول مطلوبة.');
      return;
    }

    _showLoadingDialog(); // عرض دائرة التحميل

    try {
      final int numberOfStudents =
          int.tryParse(_numberOfStudentsController.text) ?? 0;
      final int clientId = int.tryParse(_clientIdController.text) ?? 0;
      final int trainingInvoiceId =
          int.tryParse(_trainingInvoiceIdController.text) ?? 0;

      final result = await PostTraining().addTraining(
        trainingName: _trainingNameController.text,
        numberOfStudents: numberOfStudents,
        trainingDetails: _trainingDetailsController.text,
        clientId: clientId,
        trainingInvoiceId: trainingInvoiceId,
      );

      print('تمت إضافة التدريب بنجاح: ${result.trainingName}');
      Navigator.of(context).pop(); // Close the loading dialog
      _showSuccessDialog(); // Show success dialog
    } catch (e) {
      print('فشل في إضافة التدريب: $e');
      Navigator.of(context).pop(); // Close the loading dialog
      _showErrorDialog('فشل في إضافة التدريب. يرجى المحاولة مرة أخرى.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('نجاح'),
          content: Text('تمت إضافة التدريب بنجاح'),
          actions: <Widget>[
            TextButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainingsPage(),
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
      barrierDismissible: false, // Prevent dismissal
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
        backgroundColor: Color(0xff0c2d86),
        title: Text('إضافة تدريب', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl, // جعل النصوص من اليمين لليسار
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextField(
                  controller: _trainingNameController,
                  labelText: 'اسم التدريب',
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _numberOfStudentsController,
                  labelText: 'عدد الطلاب',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _trainingDetailsController,
                  labelText: 'تفاصيل التدريب',
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _clientIdController,
                  labelText: 'رقم العميل',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _trainingInvoiceIdController,
                  labelText: 'رقم فاتورة التدريب',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _sendData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0c2d86), // لون الزر
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
      ),
    );
  }

  TextField _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.amber), // تغيير لون الحواف إلى amber
        ),
      ),
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      keyboardType: keyboardType,
    );
  }
}
