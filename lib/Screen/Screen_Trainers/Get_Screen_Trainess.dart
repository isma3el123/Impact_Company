import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Trainees_Model.dart';
import 'package:flutter_application_16/Model/Trainers_Model.dart';
import 'package:flutter_application_16/Screen/Screen_Trainers/Post_Trainers_Screen.dart';
import 'package:flutter_application_16/Screen/Screen_Trainers/Update_Trainers_Screen.dart';

import 'package:flutter_application_16/Service/Service_Trainees/Delete_Service.dart';
import 'package:flutter_application_16/Service/Service_Trainers/Delete_Service.dart';
import 'package:flutter_application_16/Service/Service_Trainers/Get_Service.dart';

import 'package:flutter_application_16/widget/custombutton.dart';

class TrainersPage extends StatefulWidget {
  @override
  _TrainingsPageState createState() => _TrainingsPageState();
}

class _TrainingsPageState extends State<TrainersPage> {
  late Future<List<TrainersModel>> trainersfuture;

  @override
  void initState() {
    super.initState();
    _loadTrainings();
  }

  void _loadTrainings() {
    setState(() {
      trainersfuture = ServicegGetTrainers().fetchTrainers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title: Text('مدربون', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: Column(
        children: [
          CustomButton(
            text: 'إضافة مدرب',
            ontap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostTrainersScreen(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TrainersModel>>(
              future: trainersfuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('لا يوجد مدربون متاحون'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final trainers = snapshot.data![index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Color(0xff0c2d86),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Card(
                          margin: EdgeInsets.all(0.0),
                          elevation: 4.0,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12.0)),
                                child: trainers.imgLink != null &&
                                        trainers.imgLink!.isNotEmpty
                                    ? Image.network(
                                        trainers.imgLink!,
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  trainers.trainerName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'المهارات: ${trainers.listSkills}\nالاختصاص: ${trainers.trainerSpecialization}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              SizedBox(height: 10.0),
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
                                              UpdateTrainersScreen(
                                            trainerModel: trainers,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          context, trainers);
                                    },
                                  ),
                                ],
                              ),
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
      BuildContext context, TrainersModel trainers) {
    Service_Delete_Trainers _trainersService = Service_Delete_Trainers();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text(
              'هل أنت متأكد أنك تريد حذف المدرب: ${trainers.trainerName}?'),
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
                  await _trainersService.deleteTrainers(trainers.id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم حذف المدرب بنجاح')),
                  );
                  _loadTrainings();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('خطأ في حذف المدرب: ${e.toString()}')),
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
