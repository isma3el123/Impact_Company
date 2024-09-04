import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/SupTrinings_Model.dart';
import 'package:flutter_application_16/Screen/Screen_SupTrainings/Post_SubTrainings_Screen.dart';
import 'package:flutter_application_16/Screen/Screen_SupTrainings/Select_Trainers.dart';
import 'package:flutter_application_16/Screen/Screen_SupTrainings/Update_SubTrainings_Screen.dart';
import 'package:flutter_application_16/Service/Service_SupTrinings/Delete_Service.dart';
import 'package:flutter_application_16/Service/Service_SupTrinings/Get_Service.dart';
import 'package:flutter_application_16/widget/custombutton.dart';

class SupTrainingsPage extends StatefulWidget {
  @override
  _TrainingsPageState createState() => _TrainingsPageState();
}

class _TrainingsPageState extends State<SupTrainingsPage> {
  late Future<List<SubTrainingModel>> subtrainingFuture;

  @override
  void initState() {
    super.initState();
    _loadTrainings();
  }

  void _loadTrainings() {
    setState(() {
      subtrainingFuture = ServicegGetSubTraining().fetchSubTraining();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title: Text('التدريبات الفرعية', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: Column(
        children: [
          CustomButton(
            text: 'اضافة تدريبات فرعية',
            ontap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostSubTriningsScreens(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SubTrainingModel>>(
              future: subtrainingFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('لا توجد تدريبات فرعية متاحة'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final subtraining = snapshot.data![index];
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
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12.0)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.amber)),
                                  child: subtraining.imgLink != null &&
                                          subtraining.imgLink!.isNotEmpty &&
                                          Uri.tryParse(subtraining.imgLink!)
                                                  ?.isAbsolute ==
                                              true
                                      ? Image.network(
                                          subtraining.imgLink!,
                                          height: 150.0,
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
                                  subtraining.subTrainingName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.white),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  ' وصف التدريب الفرعي : ${subtraining.subTrainingDescription ?? 'لا توجد تفاصيل متاحة'}  ',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                  textAlign: TextAlign.left,
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
                                                UpdateSubTrainingsScreen(
                                                  subTrainingModel: subtraining,
                                                )),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 10.0),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          context, subtraining);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.person_add,
                                        color: const Color.fromARGB(
                                            255, 8, 233, 83)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddTrainerToSubTraining(
                                                  subTrainingId: subtraining.id,
                                                )),
                                      );
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
      BuildContext context, SubTrainingModel subtraining) {
    Service_Delete_SubTrainings service_delete_subTrainings =
        Service_Delete_SubTrainings();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text(
              'هل أنت متأكد أنك تريد حذف التدريب الفرعي: ${subtraining.subTrainingName}?'),
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
                  await service_delete_subTrainings
                      .deleteTrainers(subtraining.id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم حذف التدريب الفرعي بنجاح')),
                  );
                  _loadTrainings();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('خطأ في حذف التدريب الفرعي: ${e.toString()}')),
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
