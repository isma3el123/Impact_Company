import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/SupTrinings_Model.dart';
import 'package:flutter_application_16/Screen/Screen_Trainers/Get_Trainers_ById.dart';
import 'package:flutter_application_16/Service/Service_SupTrinings/Get_ById_Service.dart';

class SubTrainingByIPage extends StatefulWidget {
  final int TriningId;

  SubTrainingByIPage({required this.TriningId});

  @override
  _SubTrainingByIPageState createState() => _SubTrainingByIPageState();
}

class _SubTrainingByIPageState extends State<SubTrainingByIPage> {
  late Future<List<SubTrainingModel>> subtriningFuture;

  @override
  void initState() {
    super.initState();
    _loadSubTrainings();
  }

  void _loadSubTrainings() {
    setState(() {
      subtriningFuture =
          ServiceGeSubTrainingById().fetchSubTrainingById(widget.TriningId);
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
          'التدريبات الفرعية',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: FutureBuilder<List<SubTrainingModel>>(
        future: subtriningFuture,
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
                final subtrining = snapshot.data![index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Color(0xff0c2d86),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (subtrining.imgLink != null &&
                          subtrining.imgLink!.isNotEmpty &&
                          Uri.tryParse(subtrining.imgLink!)?.isAbsolute == true)
                        Container(
                          height: 200.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8.0)),
                            image: DecorationImage(
                              image: NetworkImage(subtrining.imgLink!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 200.0,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Center(
                              child: Text('الصورة غير متوفرة',
                                  style: TextStyle(color: Colors.grey[700]))),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              ' ${subtrining.subTrainingName} : اسم التدريب ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '${subtrining.subTrainingDescription ?? 'لا توجد تفاصيل متاحة'} : تفاصيل التدريب ',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GetTrainersByid(trainersId: subtrining.id),
                              ),
                            );
                          },
                          child: Text(
                            'عرض المدربون',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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
