import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // استيراد مكتبة CurvedNavigationBar
import 'package:flutter_application_16/Screen/Home_Page.dart';
import 'package:flutter_application_16/Screen/Screen_Attendances/Get_Attendance_ByID.dart';
import 'package:flutter_application_16/Screen/Screen_Attendances/Get_Attendances.dart';
import 'package:flutter_application_16/Screen/Screen_Attendances/attendance_home.dart';
import 'package:flutter_application_16/Screen/Screen_TriningType/Get_Trining_ById_Screen.dart';
import 'package:flutter_application_16/Screen/Screen_Trinings/Post_Trinings_Screen.dart';
import 'package:flutter_application_16/Screen/Screen_Trinings/Update_Trinings_Screen.dart';
import 'package:flutter_application_16/Screen/aboutcompny_Screen/aboutcompany.dart';
import 'package:flutter_application_16/Screen/aboutcompny_Screen/aboutcompny.dart';
import 'package:flutter_application_16/Service/Service_Trining/Delete_Service.dart';
import 'package:flutter_application_16/Service/Service_Trining/Get_Service.dart';
import 'package:flutter_application_16/Model/Trining_Model.dart';
import 'package:flutter_application_16/cubit/role_cubit.dart';
import 'package:flutter_application_16/widget/custombutton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Trainingshome extends StatefulWidget {
  @override
  _TrainingsPageState createState() => _TrainingsPageState();
}

class _TrainingsPageState extends State<Trainingshome> {
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
                                textAlign: TextAlign.end,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                      'عدد الطلاب: ${training.numberOfStudents}',
                                      style: TextStyle(color: Colors.white)),
                                  Text(
                                    'التفاصيل: ${training.trainingDetails}',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.end,
                                  ),
                                  SizedBox(height: 8.0),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(),
        child: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: _page,
          items: <Widget>[
            _buildNavBarIcon(Icons.home, 'الرئيسية', 0),
            _buildNavBarIcon(Icons.list, 'حول الشركة', 1),
            _buildNavBarIcon(Icons.compare_arrows, 'الحضور', 2),
            _buildNavBarIcon(Icons.call_split, 'التدريبات', 3),
          ],
          color: Color(0xFF0c2d86),
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _page = index;
            });

            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CombinedPage(),
                  ),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Aboutcompny(),
                  ),
                );
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Attendanceshome(),
                  ),
                );
                break;
              case 3:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Trainingshome(),
                  ),
                );
                break;
            }
          },
          letIndexChange: (index) => true,
        ),
      ),
    );
  }

  Widget _buildNavBarIcon(IconData icon, String label, int index) {
    bool isActive = _page == index;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isActive ? Color(0xFF9d7b23) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 30.0,
            color: isActive ? Colors.black : Colors.white,
          ),
        ),
        SizedBox(height: 4.0),
        if (!isActive)
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
      ],
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
