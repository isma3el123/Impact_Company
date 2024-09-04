import 'package:flutter/material.dart';
import 'package:flutter_application_16/Screen/Centers_Screen/Post_Centers.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';
import 'package:flutter_application_16/Model/SupTrinings_Model.dart';
import 'package:flutter_application_16/Service/Service_SupTrinings/Update_Service.dart';

class UpdateSubTrainingsScreen extends StatefulWidget {
  final SubTrainingModel subTrainingModel;

  UpdateSubTrainingsScreen({required this.subTrainingModel});

  @override
  _UpdateSubTrainingsScreenState createState() =>
      _UpdateSubTrainingsScreenState();
}

class _UpdateSubTrainingsScreenState extends State<UpdateSubTrainingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late String subTrainingName;
  String? imgLink;
  late String subTrainingDescription;
  late int trainingTypeId;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    subTrainingName = widget.subTrainingModel.subTrainingName;
    imgLink = widget.subTrainingModel.imgLink;
    subTrainingDescription = widget.subTrainingModel.subTrainingDescription;
    trainingTypeId = widget.subTrainingModel.trainingTypeId;
  }

  Future<void> _updateSubTraining() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _showLoadingDialog();

      try {
        String updatedImgLink = imgLink ?? '';

        // رفع الصورة إذا تم اختيار صورة جديدة
        if (_selectedImage != null) {
          updatedImgLink = await _uploadImage(_selectedImage!);
        }

        await UpdateSubTraining().updateSubTraining(
          id: widget.subTrainingModel.id,
          subTrainingName: subTrainingName,
          imgLink: updatedImgLink,
          subTrainingDescription: subTrainingDescription,
          trainingTypeId: trainingTypeId,
        );

        Navigator.of(context).pop(); // Close the loading dialog
        _showSuccessDialog(); // Show success dialog
      } catch (e) {
        Navigator.of(context).pop(); // Close the loading dialog
        _showErrorDialog(); // Show error dialog
      }
    }
  }

  Future<String> _uploadImage(File image) async {
    var publicId = DateTime.now().millisecondsSinceEpoch.toString();

    var response = await cloudinary.uploader().upload(
          image,
          params: UploadParams(
            publicId: publicId,
            uniqueFilename: true,
            overwrite: false,
          ),
        );

    if (response != null) {
      print('Upload response: ${response.data}');
      print('Image URL: ${response.data?.secureUrl}');

      String transformedUrl = _generateTransformedUrl(publicId);
      print('Transformed Image URL: $transformedUrl');

      return transformedUrl;
    } else {
      print('فشل في رفع الصورة.');
      throw Exception('فشل في رفع الصورة.');
    }
  }

  String _generateTransformedUrl(String publicId) {
    final transformedUrl = cloudinary
        .image(publicId)
        .transformation(Transformation()
          ..resize(Resize.fill()
            ..width(500)
            ..height(500)))
        .toString();
    return transformedUrl;
  }

  void _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      print('تم اختيار صورة: ${pickedFile.path}');
    } else {
      print('لم يتم اختيار صورة.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('نجاح', style: TextStyle(color: Colors.green)),
          content: Text('تمت عملية التحديث بنجاح.'),
          actions: <Widget>[
            TextButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop(); // Close success dialog
                Navigator.of(context)
                    .pop(true); // Return to previous screen with result
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
                Navigator.of(context).pop(); // Close error dialog
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title:
            Text('تحديث التدريب الفرعي', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff0c2d86), // لون خلفية شريط العنوان
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: subTrainingName,
                decoration: InputDecoration(
                  labelText: 'اسم التدريب الفرعي',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                  labelStyle:
                      TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم التدريب الفرعي';
                  }
                  return null;
                },
                onSaved: (value) {
                  subTrainingName = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: imgLink,
                decoration: InputDecoration(
                  labelText: 'رابط الصورة',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                  labelStyle:
                      TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                readOnly: true, // Prevent user from editing this field directly
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: _pickImage,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff0c2d86),
                      borderRadius: BorderRadius.circular(10)),
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      "تحميل صورة",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              _selectedImage != null
                  ? Text('تم اختيار صورة',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w900))
                  : Text('لم يتم اختيار صورة.',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w900)),
              SizedBox(height: 16),
              TextFormField(
                initialValue: subTrainingDescription,
                decoration: InputDecoration(
                  labelText: 'وصف التدريب الفرعي',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                  labelStyle:
                      TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال وصف التدريب الفرعي';
                  }
                  return null;
                },
                onSaved: (value) {
                  subTrainingDescription = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: trainingTypeId.toString(),
                decoration: InputDecoration(
                  labelText: 'رقم نوع التدريب',
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم نوع التدريب';
                  }
                  if (int.tryParse(value) == null) {
                    return 'يرجى إدخال رقم صحيح';
                  }
                  return null;
                },
                onSaved: (value) {
                  trainingTypeId = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateSubTraining,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff0c2d86), // لون خلفية الزر
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
}
