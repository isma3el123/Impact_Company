import 'package:flutter/material.dart';
import 'package:flutter_application_16/Service/Service_Trainers/Post_Service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';

class PostTrainersScreen extends StatefulWidget {
  @override
  _PostTrainerScreenState createState() => _PostTrainerScreenState();
}

class _PostTrainerScreenState extends State<PostTrainersScreen> {
  final TextEditingController _trainerNameController = TextEditingController();
  final TextEditingController _listSkillsController = TextEditingController();
  final TextEditingController _trainerSpecializationController =
      TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _cvController = TextEditingController();
  File? _selectedImage;

  Future<void> _sendData() async {
    if (_trainerNameController.text.isEmpty ||
        _listSkillsController.text.isEmpty ||
        _trainerSpecializationController.text.isEmpty ||
        _summaryController.text.isEmpty ||
        _cvController.text.isEmpty ||
        _selectedImage == null) {
      print('جميع الحقول مطلوبة، بما في ذلك الصورة.');
      return;
    }

    _showLoadingDialog();

    try {
      String media = await _uploadImage(_selectedImage!);

      final result = await PostTrainers().addTrainers(
        trainerName: _trainerNameController.text,
        imgLink: media,
        listSkills: _listSkillsController.text,
        trainerSpecialization: _trainerSpecializationController.text,
        summary: _summaryController.text,
        cv: _cvController.text,
      );

      print('تمت إضافة المدرب بنجاح: ${result.trainerName}');

      Navigator.of(context).pop();
      _showSuccessDialog();
    } catch (e) {
      print('فشل في إضافة المدرب: $e');

      Navigator.of(context).pop();
      _showErrorDialog();
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
      print('Failed to upload image.');
      throw Exception('Failed to upload image.');
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
      print('تم اختيار صورة : ${pickedFile.path}');
    } else {
      print('لم يتم اختيار صورة.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('العملية نجحت'),
          content: Text('تمت عملية الإضافة بنجاح'),
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

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('خطأ', style: TextStyle(color: Colors.red)),
          content: Text('حدث خطأ أثناء الإضافة. حاول مرة أخرى.'),
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
          color: Colors.white,
        ),
        title: Text('إضافة مدرب', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _trainerNameController,
                decoration: InputDecoration(
                  labelText: 'اسم المدرب',
                  border: OutlineInputBorder(),
                ),
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
              SizedBox(height: 16),
              TextField(
                controller: _listSkillsController,
                decoration: InputDecoration(
                  labelText: 'قائمة المهارات',
                  border: OutlineInputBorder(),
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _trainerSpecializationController,
                decoration: InputDecoration(
                  labelText: 'تخصص المدرب',
                  border: OutlineInputBorder(),
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _summaryController,
                decoration: InputDecoration(
                  labelText: 'ملخص',
                  border: OutlineInputBorder(),
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _cvController,
                decoration: InputDecoration(
                  labelText: 'رابط السيرة الذاتية',
                  border: OutlineInputBorder(),
                ),
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

var cloudinary = Cloudinary.fromStringUrl(
    'cloudinary://268338396499843:_T9MHdwRZhhIubdAI-Hr3uOrcS8@dn9nuvyzl');
