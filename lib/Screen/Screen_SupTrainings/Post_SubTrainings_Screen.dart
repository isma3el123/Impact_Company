import 'package:flutter/material.dart';
import 'package:flutter_application_16/Screen/Centers_Screen/Post_Centers.dart';
import 'package:flutter_application_16/Screen/Screen_Trainees/Get_Screen_Trainees.dart';
import 'package:flutter_application_16/Service/Service_SupTrinings/Post_Service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';

class PostSubTriningsScreens extends StatefulWidget {
  @override
  _PostSubTriningsScreensState createState() => _PostSubTriningsScreensState();
}

class _PostSubTriningsScreensState extends State<PostSubTriningsScreens> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subTrainingNameController =
      TextEditingController();
  final TextEditingController _subTrainingDescriptionController =
      TextEditingController();
  final TextEditingController _trainingTypeIdController =
      TextEditingController();
  File? _selectedImage;

  Future<void> _sendData() async {
    if (!_formKey.currentState!.validate() || _selectedImage == null) {
      print('يرجى ملء جميع الحقول بشكل صحيح، بما في ذلك الصورة.');
      return;
    }

    _showLoadingDialog();

    try {
      String imgLink = await _uploadImage(_selectedImage!);

      final int trainingTypeId =
          int.tryParse(_trainingTypeIdController.text) ?? 0;

      final result = await PostSubTraining().addSubTraining(
        subTrainingName: _subTrainingNameController.text,
        imgLink: imgLink,
        subTrainingDescription: _subTrainingDescriptionController.text,
        trainingTypeId: trainingTypeId,
      );

      print('تمت إضافة التدريب بنجاح: ${result.subTrainingName}');

      Navigator.of(context).pop();
      _showSuccessDialog();
    } catch (e) {
      print('فشل في إضافة التدريب: $e');

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
          title: Text('نجاح', style: TextStyle(color: Colors.green)),
          content: Text('تمت عملية الإضافة بنجاح.'),
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

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('خطأ', style: TextStyle(color: Colors.red)),
          content: Text('حدث خطأ أثناء الإضافة. يرجى المحاولة مرة أخرى.'),
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
          color: Colors.white,
        ),
        title: Text('إضافة تدريب', style: TextStyle(color: Colors.white)),
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
                  controller: _subTrainingNameController,
                  textAlign: TextAlign.right,
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
                  controller: _subTrainingDescriptionController,
                  textAlign: TextAlign.right,
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
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _trainingTypeIdController,
                  textAlign: TextAlign.right,
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
                    return null;
                  },
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
                    'اضافة',
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
