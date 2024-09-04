import 'package:flutter/material.dart';
import 'package:flutter_application_16/Screen/Screen_Trinings/Get_Trinings_Screen.dart';
import 'package:flutter_application_16/Service/Service_Trining/Update_Service.dart';
import 'package:flutter_application_16/Model/Trining_Model.dart';

class UpdateTrainingScreen extends StatefulWidget {
  final TrainingModel trainingModel;

  UpdateTrainingScreen({required this.trainingModel});

  @override
  _UpdateTrainingScreenState createState() => _UpdateTrainingScreenState();
}

class _UpdateTrainingScreenState extends State<UpdateTrainingScreen> {
  final _formKey = GlobalKey<FormState>();
  late String trainingName;
  late int numberOfStudents;
  late String trainingDetails;
  late int clientId;
  late int trainingInvoiceId;

  @override
  void initState() {
    super.initState();
    trainingName = widget.trainingModel.trainingName;
    numberOfStudents = widget.trainingModel.numberOfStudents;
    trainingDetails = widget.trainingModel.trainingDetails;
    clientId = widget.trainingModel.clientId;
    trainingInvoiceId = widget.trainingModel.trainingInvoiceId;
  }

  _updateTraining() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _showLoadingDialog();

      try {
        await UpdateService().updateTraining(
          trainingName: trainingName,
          numberOfStudents: numberOfStudents,
          trainingDetails: trainingDetails,
          clientId: clientId,
          trainingInvoiceId: trainingInvoiceId,
          id: widget.trainingModel.id,
        );

        Navigator.of(context).pop();

        _showSuccessDialog();
      } catch (e) {
        Navigator.of(context).pop();
        _showErrorDialog();
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
        title: Text('تحديث التدريب', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff0c2d86), // لون شريط التطبيق
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextFormField(
                  initialValue: trainingName,
                  labelText: 'اسم التدريب',
                  onSaved: (value) => trainingName = value!,
                ),
                SizedBox(height: 16),
                _buildTextFormField(
                  initialValue: numberOfStudents.toString(),
                  labelText: 'عدد الطلاب',
                  keyboardType: TextInputType.number,
                  onSaved: (value) => numberOfStudents = int.parse(value!),
                ),
                SizedBox(height: 16),
                _buildTextFormField(
                  initialValue: trainingDetails,
                  labelText: 'تفاصيل التدريب',
                  onSaved: (value) => trainingDetails = value!,
                ),
                SizedBox(height: 16),
                _buildTextFormField(
                  initialValue: clientId.toString(),
                  labelText: 'معرف العميل',
                  keyboardType: TextInputType.number,
                  onSaved: (value) => clientId = int.parse(value!),
                ),
                SizedBox(height: 16),
                _buildTextFormField(
                  initialValue: trainingInvoiceId.toString(),
                  labelText: 'معرف فاتورة التدريب',
                  keyboardType: TextInputType.number,
                  onSaved: (value) => trainingInvoiceId = int.parse(value!),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateTraining,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0c2d86), // لون الزر
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
      ),
    );
  }

  TextFormField _buildTextFormField({
    required String initialValue,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.amber), // تغيير لون الحواف إلى amber
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى إدخال قيمة';
        }
        return null;
      },
      onSaved: onSaved,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('العملية نجحت'),
          content: Text('تمت عملية التحديث بنجاح'),
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
              Text('جاري التحديث...'),
            ],
          ),
        );
      },
    );
  }
}
