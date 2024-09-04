import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Centers_Model.dart';
import 'package:flutter_application_16/Model/Halls_Model.dart';
import 'package:flutter_application_16/Screen/Centers_Screen/Post_Centers.dart';
import 'package:flutter_application_16/Service/Service_Centers/Update_Centers.dart';
import 'package:flutter_application_16/Service/Service_Halls/Update_Service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';

class UpdatehallsScreen extends StatefulWidget {
  final HallsModel hallsModel;

  UpdatehallsScreen({required this.hallsModel});

  @override
  _UpdatehallsScreenState createState() => _UpdatehallsScreenState();
}

class _UpdatehallsScreenState extends State<UpdatehallsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _centerNameController = TextEditingController();
  final TextEditingController _centerLocationController =
      TextEditingController();
  File? _imageFile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _centerNameController.text = widget.hallsModel.hallName;
    _centerLocationController.text = widget.hallsModel.listDetails!;
    _imageUrl = widget.hallsModel.imgLink!.isNotEmpty
        ? widget.hallsModel.imgLink
        : null;
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _updateCenter() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _showLoadingDialog();

    try {
      String imgLink = widget.hallsModel.imgLink!;

      if (_imageFile != null) {
        imgLink = await _uploadImage(_imageFile!);
      }

      await UpdateServiceHalls().updateHalls(
        id: widget.hallsModel.id,
        hallName: _centerNameController.text,
        imgLink: imgLink,
        centerId: widget.hallsModel
            .centerId, // Assuming `centerId` is available in `CentersModel`
        listDetials: _centerLocationController.text,
      );

      Navigator.of(context).pop();
      _showSuccessDialog();
    } catch (e) {
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
      String transformedUrl = _generateTransformedUrl(publicId);
      return transformedUrl;
    } else {
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
            Text('تحديث بيانات المركز', style: TextStyle(color: Colors.white)),
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
                      return 'يرجى إدخال موقع المركز';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _imageFile == null
                                ? _imageUrl == null
                                    ? 'لا توجد صورة مختارة'
                                    : 'الصورة الحالية: $_imageUrl'
                                : 'الصورة المحددة: ${_imageFile!.path.split('/').last}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          if (_imageFile != null) SizedBox(height: 10),
                          if (_imageFile != null)
                            Image.file(
                              _imageFile!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: _pickImage,
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color(0xff0c2d86),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'اختيار صورة',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: _updateCenter,
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
