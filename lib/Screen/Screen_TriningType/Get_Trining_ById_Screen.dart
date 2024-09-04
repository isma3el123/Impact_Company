import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/TriningType_Model.dart';
import 'package:flutter_application_16/Screen/Screen_SupTrainings/Get_SubTrining_ById.dart';
import 'package:flutter_application_16/Service/Service_TriningType/Get_ById_Service.dart';

class GetTrainingByidScreen extends StatefulWidget {
  final int trainingId;

  GetTrainingByidScreen({required this.trainingId});

  @override
  _GetTrainingByidScreenState createState() => _GetTrainingByidScreenState();
}

class _GetTrainingByidScreenState extends State<GetTrainingByidScreen> {
  late Future<TrainingTypeModel> trainingFuture;

  @override
  void initState() {
    super.initState();
    _loadTraining();
  }

  void _loadTraining() {
    setState(() {
      trainingFuture =
          ServiceGetTrainingTypeById().fetchTrainingTypeById(widget.trainingId);
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
          'تفاصيل التدريب',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: FutureBuilder<TrainingTypeModel>(
        future: trainingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('لا توجد تفاصيل تدريب متاحة'));
          } else {
            final trainingType = snapshot.data!;
            return Container(
              height: 300,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Color(0xff0c2d86)),
              child: Card(
                color: const Color.fromARGB(0, 253, 253, 253),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Color(0xff0c2d86)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12.0)),
                        child: Container(
                          decoration: BoxDecoration(),
                          child: trainingType.imgLink != null &&
                                  trainingType.imgLink!.isNotEmpty
                              ? Image.network(
                                  trainingType.imgLink!,
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
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          ' نوع التدريب : ${trainingType.trainingTypeName} ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubTrainingByIPage(
                                    TriningId: trainingType.id,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'عرض التدريبات الفرعية',
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                        ],
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
