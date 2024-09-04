import 'package:flutter/material.dart';
import 'package:flutter_application_16/Screen/Screen_Attendances/Get_Attendance_ByID.dart';
import 'package:flutter_application_16/Screen/Screen_TriningType/Get_Trining_ById_Screen.dart';
import 'package:flutter_application_16/Screen/Screen_Trinings/Update_Trinings_Screen.dart';
import 'package:flutter_application_16/Service/Service_Trining/Delete_Service.dart';
import 'package:flutter_application_16/Service/Service_Trining/Get_Service.dart';
import 'package:flutter_application_16/Model/Trining_Model.dart';

class Trainings extends StatefulWidget {
  @override
  _TrainingsPageState createState() => _TrainingsPageState();
}

class _TrainingsPageState extends State<Trainings> {
  late Future<List<TrainingModel>> _trainingsFuture;

  @override
  void initState() {
    super.initState();
    _loadTrainings();
  }

  void _loadTrainings() {
    setState(() {
      _trainingsFuture = ServicegGetTrainingService().fetchTrainings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: FutureBuilder<List<TrainingModel>>(
          future: _trainingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No trainings available'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final training = snapshot.data![index];
                  return Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 4.0,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        training.trainingName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Students: ${training.numberOfStudents}'),
                          Text('Client ID: ${training.clientId}'),
                          Text('Invoice ID: ${training.trainingInvoiceId}'),
                          Text('Details: ${training.trainingDetails}'),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AttendanceByIdScreen(
                                      trainingId: training.id,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'عرض سجلات الحضور ',
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GetTrainingByidScreen(
                                      trainingId: training.id,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'عرض المزيد',
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      isThreeLine: true,
                      tileColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateTrainingScreen(
                                    trainingModel: training,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {},
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
    );
  }
}
