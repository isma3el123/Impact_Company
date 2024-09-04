import 'package:flutter/material.dart';
import 'package:flutter_application_16/Screen/Halls_Screen/Get_Halls.dart';
import 'package:flutter_application_16/Service/Service_Halls/Post_Service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';

class PostHallScreens extends StatefulWidget {
  final int centerId;

  PostHallScreens({required this.centerId});

  @override
  _PostHallScreensState createState() => _PostHallScreensState();
}

class _PostHallScreensState extends State<PostHallScreens> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hallNameController = TextEditingController();
  final TextEditingController _listDetailsController = TextEditingController();
  File? _selectedImage;

  Future<void> _sendData() async {
    if (!_formKey.currentState!.validate()) {
      print('يرجى ملء جميع الحقول بشكل صحيح.');
      return;
    }

    _showLoadingDialog();

    try {
      String imgLink = '';

      if (_selectedImage != null) {
        imgLink = await _uploadImage(_selectedImage!);
      } else {
        imgLink = ''; // أو يمكن تعيين قيمة افتراضية أو إظهار رسالة خطأ
      }

      final result = await PostHall().addHall(
        hallName: _hallNameController.text,
        imgLink: imgLink,
        centerId: widget.centerId,
        listDetails: _listDetailsController.text,
      );

      print('تمت إضافة القاعة بنجاح: ${result.hallName}');

      Navigator.of(context).pop();
      _showSuccessDialog();
    } catch (e) {
      print('فشل في إضافة القاعة: $e');

      Navigator.of(context).pop();
      _showErrorDialog();
    }
  }

  Future<String> _uploadImage(File image) async {
    var uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

    var response = await cloudinary.uploader().upload(
          image,
          params: UploadParams(
            publicId: uniqueId,
            uniqueFilename: true,
            overwrite: false,
          ),
        );

    if (response != null) {
      print('Upload response: ${response.data}');
      print('Image URL: ${response.data?.secureUrl}');

      String transformedUrl = _generateTransformedUrl(uniqueId);
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
          content: Text('تمت إضافة القاعة بنجاح.'),
          actions: <Widget>[
            TextButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HallsPage(centerId: widget.centerId),
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
          content: Text('حدث خطأ أثناء إضافة القاعة. يرجى المحاولة مرة أخرى.'),
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
              Text('جارٍ الإضافة...'),
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
        title: Text('إضافة قاعة', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _hallNameController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: 'اسم القاعة',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم القاعة';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _listDetailsController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: 'تفاصيل القاعة',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال تفاصيل القاعة';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff0c2d86),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 200,
                    height: 50,
                    child: Center(
                      child: Text(
                        "تحميل صورة",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: _selectedImage != null
                      ? Text('تم اختيار صورة: ${_selectedImage!.path}',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w900))
                      : Text('لم يتم اختيار صورة.',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900)),
                ),
                SizedBox(height: 16),
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
      ),
    );
  }
}

// إنشاء مثيل من Cloudinary باستخدام معلوماتك
var cloudinary = Cloudinary.fromStringUrl(
  'cloudinary://268338396499843:_T9MHdwRZhhIubdAI-Hr3uOrcS8@dn9nuvyzl',
);
