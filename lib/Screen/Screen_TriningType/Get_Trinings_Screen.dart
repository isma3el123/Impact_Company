import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/TriningType_Model.dart';
import 'package:flutter_application_16/Screen/Screen_TriningType/Post_Trinings_Screen.dart';
import 'package:flutter_application_16/Screen/Screen_TriningType/Update_Trinings_Screen.dart';
import 'package:flutter_application_16/Service/Service_TriningType/Delete_Service.dart';
import 'package:flutter_application_16/Service/Service_TriningType/Get_Service.dart';
import 'package:flutter_application_16/widget/custombutton.dart';

class TrainingTypePage extends StatefulWidget {
  @override
  _TrainingTypePageState createState() => _TrainingTypePageState();
}

class _TrainingTypePageState extends State<TrainingTypePage> {
  late Future<List<TrainingTypeModel>> _trainingtypefuture;

  @override
  void initState() {
    super.initState();
    _loadTrainings();
  }

  void _loadTrainings() {
    setState(() {
      _trainingtypefuture = ServicegGetTrainingTypes().fetchTrainingType();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title: Text('أنواع التدريب', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: Column(
        children: [
          CustomButton(
            text: 'إضافة نوع تدريب',
            ontap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostTriningTypeScreen(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TrainingTypeModel>>(
              future: _trainingtypefuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('لا توجد أنواع تدريب متاحة'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final trainingtype = snapshot.data![index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Color(0xff0c2d86),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Card(
                          color: Color(0xff0c2d86),
                          margin: EdgeInsets.all(0.0),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child: trainingtype.imgLink != null &&
                                          trainingtype.imgLink!.isNotEmpty
                                      ? Image.network(
                                          trainingtype.imgLink,
                                          height: 120.0,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          height: 150.0,
                                          width: double.infinity,
                                          color: Colors.grey,
                                          child: Center(
                                            child: Text(
                                              'الصورة غير متوفرة',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  trainingtype.trainingTypeName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.white),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateTrainingTypeScreen(
                                            trainingTypeModel: trainingtype,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 10.0),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          context, trainingtype);
                                    },
                                  ),
                                  SizedBox(width: 10.0),
                                ],
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, TrainingTypeModel training) {
    Service_Delete_TrainingTypes service_delete_trainingTypes =
        Service_Delete_TrainingTypes();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text(
              'هل أنت متأكد أنك تريد حذف نوع التدريب: ${training.trainingTypeName}?'),
          actions: <Widget>[
            TextButton(
              child: Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('حذف'),
              onPressed: () async {
                try {
                  await service_delete_trainingTypes
                      .deleteTrainingTypes(training.id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم حذف نوع التدريب بنجاح')),
                  );
                  _loadTrainings();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('خطأ في حذف نوع التدريب: ${e.toString()}')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
