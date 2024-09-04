import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Attendances_Model.dart';
import 'package:flutter_application_16/Service/Service_Attendance/Update_Service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';

class UpdateAttendanceScreen extends StatefulWidget {
  final AttendanceModel attendanceModel;

  UpdateAttendanceScreen({required this.attendanceModel});

  @override
  _UpdateAttendanceScreenState createState() => _UpdateAttendanceScreenState();
}

class _UpdateAttendanceScreenState extends State<UpdateAttendanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _trainingNameController = TextEditingController();
  final TextEditingController _trainingIdController = TextEditingController();
  DateTime? _selectedDate;
  File?
      _imageFile; // You may not need this for attendance unless you plan to use an image for attendance
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _trainingNameController.text = widget.attendanceModel.trainingName;
    _trainingIdController.text = widget.attendanceModel.trainingId.toString();
    _selectedDate = widget.attendanceModel.attendanceDate;
  }

  Future<void> _selectDate() async {
    DateTime initialDate = _selectedDate ?? DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _updateAttendance() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _showLoadingDialog();

    try {
      await UpdateServiceAttendance().updateAttendance(
        id: widget.attendanceModel.id,
        attendanceDate: _selectedDate!,
        trainingId: int.parse(_trainingIdController.text),
        trainingName: _trainingNameController.text,
      );

      Navigator.of(context).pop();
      _showSuccessDialog();
    } catch (e) {
      Navigator.of(context).pop();
      _showErrorDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('نجاح'),
          content: Text('تمت عملية التحديث بنجاح.'),
          actions: <Widget>[
            TextButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(true);
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
          title: Text('خطأ'),
          content: Text('حدث خطأ أثناء التحديث. حاول مرة أخرى.'),
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
              Text('جارٍ التحديث...'),
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
          color: Colors.white,
        ),
        backgroundColor: Color(0xff0c2d86),
        title:
            Text('تحديث بيانات الحضور', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _trainingNameController,
                  decoration: InputDecoration(
                    labelText: 'اسم التدريب',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    contentPadding: EdgeInsets.only(right: 8.0),
                  ),
                  textAlign: TextAlign.right,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم التدريب';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _trainingIdController,
                  decoration: InputDecoration(
                    labelText: 'معرف التدريب',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    contentPadding: EdgeInsets.only(right: 8.0),
                  ),
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال معرف التدريب';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'تاريخ الحضور غير محدد'
                            : 'تاريخ الحضور: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: _selectDate,
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color(0xff0c2d86),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'اختيار تاريخ',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: _updateAttendance,
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Color(0xff0c2d86),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'تحديث',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
