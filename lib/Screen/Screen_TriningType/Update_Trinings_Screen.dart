import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/TriningType_Model.dart';
import 'package:flutter_application_16/Screen/Centers_Screen/Post_Centers.dart';
import 'package:flutter_application_16/Service/Service_TriningType/Update_Service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';

class UpdateTrainingTypeScreen extends StatefulWidget {
  final TrainingTypeModel trainingTypeModel;

  UpdateTrainingTypeScreen({required this.trainingTypeModel});

  @override
  _UpdateTrainingTypeScreenState createState() =>
      _UpdateTrainingTypeScreenState();
}

class _UpdateTrainingTypeScreenState extends State<UpdateTrainingTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  late String trainingTypeName;
  late String imgLink;
  late int id;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    trainingTypeName = widget.trainingTypeModel.trainingTypeName;
    imgLink = widget.trainingTypeModel.imgLink;
    id = widget.trainingTypeModel.id;
  }

  Future<void> _updateTrainingType() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _showLoadingDialog();

      try {
        String updatedImgLink = imgLink;

        // رفع الصورة إذا تم اختيار صورة جديدة
        if (_selectedImage != null) {
          updatedImgLink = await _uploadImage(_selectedImage!);
        }

        await UpdateTriningType().updateTriningType(
          trainingTypeName: trainingTypeName,
          imgLink: updatedImgLink,
          id: id,
        );

        Navigator.of(context).pop();
        _showSuccessDialog();
      } catch (e) {
        Navigator.of(context).pop();
        _showErrorDialog();
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
          title: Text('نجاح'),
          content: Text('تم التحديث بنجاح.'),
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
          title: Text('خطأ', style: TextStyle(color: Colors.red)),
          content: Text('حدث خطأ أثناء التحديث. الرجاء المحاولة مرة أخرى.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0c2d86),
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title: Text('تحديث نوع التدريب', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: trainingTypeName,
                decoration: InputDecoration(
                  labelText: 'اسم نوع التدريب',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم نوع التدريب';
                  }
                  return null;
                },
                onSaved: (value) {
                  trainingTypeName = value!;
                },
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: imgLink,
                decoration: InputDecoration(
                  labelText: 'رابط الصورة',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رابط الصورة';
                  }
                  return null;
                },
                onSaved: (value) {
                  imgLink = value!;
                },
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
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
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _updateTrainingType,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0c2d86),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'تحديث',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
