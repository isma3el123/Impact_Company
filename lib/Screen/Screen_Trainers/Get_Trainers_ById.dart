import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Trainers_Model.dart';
import 'package:flutter_application_16/Service/Service_Trainers/Get_Trainers_ById.dart';

class GetTrainersByid extends StatefulWidget {
  final int trainersId;

  GetTrainersByid({required this.trainersId});

  @override
  _GetTrainersByidPageState createState() => _GetTrainersByidPageState();
}

class _GetTrainersByidPageState extends State<GetTrainersByid> {
  late Future<List<TrainersModel>> trainersFuture;

  @override
  void initState() {
    super.initState();
    _loadTrainers();
  }

  void _loadTrainers() {
    setState(() {
      trainersFuture =
          ServiceGetTrainersById().fetchTrainersById(widget.trainersId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title: Text(
          'مدربون',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: FutureBuilder<List<TrainersModel>>(
        future: trainersFuture,
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
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Color(0xff0c2d86),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (trainers.imgLink != null &&
                          trainers.imgLink!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            trainers.imgLink!,
                            height: 150.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          height: 150.0,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Center(
                            child: Text(
                              'لا توجد صورة',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          ' اسم المدرب : ${trainers.trainerName} ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          ' مهارات المدرب : ${trainers.listSkills} ',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'تخصص المدرب  :${trainers.trainerSpecialization} ',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          ' ملخص المدرب  :${trainers.summary} ',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
