import 'package:flutter/material.dart';
import 'package:flutter_application_16/Screen/Centers_Screen/Get_Centers.dart';
import 'package:flutter_application_16/Service/Service_Centers/Post_Service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';

class PostCenterScreen extends StatefulWidget {
  @override
  _PostCenterState createState() => _PostCenterState();
}

class _PostCenterState extends State<PostCenterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _centerNameController = TextEditingController();
  final TextEditingController _centerLocationController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  File? _selectedImage;

  Future<void> _sendData() async {
    if (!_formKey.currentState!.validate()) {
      print('يرجى ملء جميع الحقول بشكل صحيح.');
      return;
    }

    if (_selectedImage == null) {
      print('الصورة مطلوبة.');
      return;
    }

    _showLoadingDialog();

    try {
      String media = await _uploadImage(_selectedImage!);

      // طباعة الرابط المعدل الذي تم تمريره إلى media
      print('رابط الصورة المعدل: $media');

      final result = await PostCenter().addCenter(
        centerName: _centerNameController.text,
        centerLocation: _centerLocationController.text,
        phoneNumber: _phoneNumberController.text,
        media: media,
      );

      print('تمت إضافة المركز بنجاح: ${result.centerName}');

      Navigator.of(context).pop();
      _showSuccessDialog();
    } catch (e) {
      print('فشل في إضافة المركز: $e');

      Navigator.of(context).pop();
      _showErrorDialog();
    }
  }

  Future<String> _uploadImage(File image) async {
    // استخدم publicId فريد أو يمكنك إنشاء publicId مخصص لكل صورة
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

      // تحديث URL الصورة المعدلة بعد التحميل
      String transformedUrl = _generateTransformedUrl(publicId);
      print('Transformed Image URL: $transformedUrl');

      return transformedUrl;
    } else {
      print('Failed to upload image.');
      throw Exception('Failed to upload image.');
    }
  }

  String _generateTransformedUrl(String publicId) {
    // إنشاء URL للصورة المعدلة
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
          title: Text('نجاح'),
          content: Text('تمت إضافة المركز بنجاح.'),
          actions: <Widget>[
            TextButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CentersPage(),
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
          title: Text('خطأ'),
          content: Text('حدث خطأ. يرجى المحاولة مرة أخرى.'),
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
        backgroundColor: Color(0xff0c2d86),
        title: Text('إضافة مركز', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _centerNameController,
                  decoration: InputDecoration(
                    labelText: 'اسم المركز',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.amber,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.amber,
                        width: 2.0,
                      ),
                    ),
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  ),
                  textDirection: TextDirection.rtl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم المركز';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _centerLocationController,
                  decoration: InputDecoration(
                    labelText: 'موقع المركز',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.amber,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.amber,
                        width: 2.0,
                      ),
                    ),
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  ),
                  textDirection: TextDirection.rtl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال موقع المركز';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.amber,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.amber,
                        width: 2.0,
                      ),
                    ),
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  ),
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.rtl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم الهاتف';
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
                        borderRadius: BorderRadius.circular(10)),
                    width: 200,
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
                InkWell(
                  onTap: _sendData,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xff0c2d86),
                        borderRadius: BorderRadius.circular(10)),
                    width: 200,
                    height: 50,
                    child: Center(
                      child: Text(
                        "اضافة المركز",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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

var cloudinary = Cloudinary.fromStringUrl(
    'cloudinary://268338396499843:_T9MHdwRZhhIubdAI-Hr3uOrcS8@dn9nuvyzl');
