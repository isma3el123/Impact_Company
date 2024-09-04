import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // استيراد مكتبة CurvedNavigationBar
import 'package:flutter_application_16/Screen/Home_Page.dart';
import 'package:flutter_application_16/Screen/Screen_Attendances/Get_Attendance_ByID.dart';
import 'package:flutter_application_16/Screen/Screen_Attendances/Get_Attendances.dart';
import 'package:flutter_application_16/Screen/Screen_TriningType/Get_Trining_ById_Screen.dart';
import 'package:flutter_application_16/Screen/Screen_Trinings/Post_Trinings_Screen.dart';
import 'package:flutter_application_16/Screen/Screen_Trinings/Update_Trinings_Screen.dart';
import 'package:flutter_application_16/Service/Service_Trining/Delete_Service.dart';
import 'package:flutter_application_16/Service/Service_Trining/Get_Service.dart';
import 'package:flutter_application_16/Model/Trining_Model.dart';
import 'package:flutter_application_16/cubit/role_cubit.dart';
import 'package:flutter_application_16/widget/custombutton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrainingsPage extends StatefulWidget {
  @override
  _TrainingsPageState createState() => _TrainingsPageState();
}

class _TrainingsPageState extends State<TrainingsPage> {
  late Future<List<TrainingModel>> _trainingsFuture;
  int _page = 3; // لتحديد الصفحة الحالية في الـ BottomNavigationBar
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

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
    final role = context.watch<RoleCubit>().state;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title: Text(
          'التدريبات',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff0c2d86),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Visibility(
            visible: role == 'Admin',
            child: CustomButton(
              text: 'إضافة تدريب',
              ontap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostTrainingScreen(),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TrainingModel>>(
              future: _trainingsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('لا توجد تدريبات متاحة'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final training = snapshot.data![index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xff0c2d86),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16.0),
                              title: Text(
                                training.trainingName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'عدد الطلاب: ${training.numberOfStudents}',
                                      style: TextStyle(color: Colors.white)),
                                  Text('التفاصيل: ${training.trainingDetails}',
                                      style: TextStyle(color: Colors.white)),
                                  SizedBox(height: 8.0),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AttendanceByIdScreen(
                                              trainingId: training.id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'عرض سجلات الحضور',
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                GetTrainingByidScreen(
                                              trainingId: training.id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'عرض انواع التدريبات',
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                              tileColor: Colors.transparent,
                              trailing: Visibility(
                                visible: role == 'Admin',
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
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
                                                UpdateTrainingScreen(
                                              trainingModel: training,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: const Color.fromARGB(
                                              255, 255, 3, 3)),
                                      onPressed: () {
                                        _showDeleteConfirmationDialog(
                                            context, training);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )),
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
      BuildContext context, TrainingModel training) {
    Service_Delete_Trinings service_delete_training = Service_Delete_Trinings();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'تأكيد الحذف',
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
              'هل أنت متأكد من أنك تريد حذف التدريب: ${training.trainingName}?'),
          actions: <Widget>[
            TextButton(
              child: Text('إلغاء', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('حذف', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                try {
                  await service_delete_training.deleteTraining(training.id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم حذف التدريب بنجاح')),
                  );
                  _loadTrainings();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('خطأ أثناء حذف التدريب: ${e.toString()}')),
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
