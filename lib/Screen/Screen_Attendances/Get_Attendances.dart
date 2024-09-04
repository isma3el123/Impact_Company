import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Attendances_Model.dart';
import 'package:flutter_application_16/Screen/Home_Page.dart';
import 'package:flutter_application_16/Screen/Screen_Attendances/Post_Attendances.dart';
import 'package:flutter_application_16/Screen/Screen_Attendances/Select_Trainee.dart';
import 'package:flutter_application_16/Screen/Screen_Attendances/Update_Attendance.dart';
import 'package:flutter_application_16/Screen/Screen_Trinings/Get_Trinings_Screen.dart';
import 'package:flutter_application_16/Service/Service_Attendance/Delete_Service.dart';
import 'package:flutter_application_16/Service/Service_Attendance/Get_Service.dart';
import 'package:flutter_application_16/widget/custombutton.dart';
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // استيراد مكتبة CurvedNavigationBar

class AttendancesPage extends StatefulWidget {
  @override
  _AttendancesPageState createState() => _AttendancesPageState();
}

class _AttendancesPageState extends State<AttendancesPage> {
  late Future<List<AttendanceModel>> _attendancesFuture;
  int _page = 2; // لتحديد الصفحة الحالية في الـ BottomNavigationBar
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadAttendances();
  }

  void _loadAttendances() {
    setState(() {
      _attendancesFuture = ServicegGetAttendance().fetchAttendance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title: Text('الحضور', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff0c2d86),
        centerTitle: true,
        elevation: 4.0,
        actions: [],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<AttendanceModel>>(
              future: _attendancesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('لا يوجد أي حضور متاح'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final attendance = snapshot.data![index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        elevation: 6.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Container(
                          color: Color(0xff0c2d86),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.0),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  attendance.trainingName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'تاريخ الحضور: ${DateFormat('yyyy-MM-dd').format(attendance.attendanceDate)}',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 16.0),
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
                                                    UpdateAttendanceScreen(
                                                      attendanceModel:
                                                          attendance,
                                                    )));
                                      },
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _showDeleteConfirmationDialog(
                                            context, attendance);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.person_add,
                                          color: Colors.green),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddTraineeToAttendance(
                                                    attendanceId:
                                                        attendance.id),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
      BuildContext context, AttendanceModel attendance) {
    Service_Delete_Attendance service_delete_attendance =
        Service_Delete_Attendance();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'تأكيد الحذف',
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
              'هل أنت متأكد من أنك تريد حذف التدريب: ${attendance.trainingName}?'),
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
                  await service_delete_attendance
                      .deleteAttendance(attendance.id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم حذف التدريب بنجاح')),
                  );
                  _loadAttendances();
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
