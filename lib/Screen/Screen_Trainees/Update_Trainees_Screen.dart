import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Trainees_Model.dart';
import 'package:flutter_application_16/Service/Service_Trainees/Update_Service.dart';

class UpdateTraineesScreen extends StatefulWidget {
  final TraineesModel traineesModel;

  UpdateTraineesScreen({required this.traineesModel});

  @override
  _UpdateTraineesScreenState createState() => _UpdateTraineesScreenState();
}

class _UpdateTraineesScreenState extends State<UpdateTraineesScreen> {
  final _formKey = GlobalKey<FormState>();
  late String traineeName;
  late String listAttendanceStatus;
  late int trainingId;

  @override
  void initState() {
    super.initState();
    traineeName = widget.traineesModel.traineeName;
    listAttendanceStatus = widget.traineesModel.listAttendanceStatus;
    trainingId = widget.traineesModel.trainingId;
  }

  Future<void> _updateTraining() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _showLoadingDialog();

      try {
        await UpdateServiceTrainees().updateTrainees(
          traineeName: traineeName,
          listAttendanceStatus: listAttendanceStatus,
          trainingId: trainingId,
          id: widget.traineesModel.id,
        );

        Navigator.of(context).pop(); // Close the loading dialog

        _showSuccessDialog(); // Show success dialog
      } catch (e) {
        Navigator.of(context).pop(); // Close the loading dialog
        _showErrorDialog(); // Show error dialog
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title: Text('تحديث المتدرب', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: traineeName,
                decoration: InputDecoration(
                  labelText: 'اسم المتدرب',
                  border: OutlineInputBorder(),
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم المتدرب';
                  }
                  return null;
                },
                onSaved: (value) {
                  traineeName = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: listAttendanceStatus,
                decoration: InputDecoration(
                  labelText: 'حالة الحضور',
                  border: OutlineInputBorder(),
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال حالة الحضور';
                  }
                  return null;
                },
                onSaved: (value) {
                  listAttendanceStatus = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: trainingId.toString(),
                decoration: InputDecoration(
                  labelText: 'رقم التدريب',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم التدريب';
                  }
                  if (int.tryParse(value) == null) {
                    return 'يرجى إدخال رقم صحيح';
                  }
                  return null;
                },
                onSaved: (value) {
                  trainingId = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateTraining,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff0c2d86),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'تحديث',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('العملية نجحت', style: TextStyle(color: Colors.green)),
          content: Text('تمت عملية التحديث بنجاح'),
          actions: <Widget>[
            TextButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the success dialog
                Navigator.of(context)
                    .pop(true); // Go back to the previous screen
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('خطأ', style: TextStyle(color: Colors.red)),
          content: Text('حدث خطأ أثناء التحديث. حاول مرة أخرى.'),
          actions: <Widget>[
            TextButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the error dialog
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
              Text('جاري التحديث...'),
            ],
          ),
        );
      },
    );
  }
}
