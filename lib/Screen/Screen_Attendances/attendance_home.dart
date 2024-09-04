import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Attendances_Model.dart';
import 'package:flutter_application_16/Screen/Home_Page.dart';
import 'package:flutter_application_16/Screen/Screen_Attendances/Post_Attendances.dart';
import 'package:flutter_application_16/Screen/Screen_Attendances/Select_Trainee.dart';
import 'package:flutter_application_16/Screen/Screen_Trinings/Get_Trinings_Screen.dart';
import 'package:flutter_application_16/Screen/Screen_Trinings/trining_home.dart';
import 'package:flutter_application_16/Screen/aboutcompny_Screen/aboutcompany.dart';
import 'package:flutter_application_16/Screen/aboutcompny_Screen/aboutcompny.dart';
import 'package:flutter_application_16/Service/Service_Attendance/Delete_Service.dart';
import 'package:flutter_application_16/Service/Service_Attendance/Get_Service.dart';
import 'package:flutter_application_16/widget/custombutton.dart';
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // استيراد مكتبة CurvedNavigationBar

class Attendanceshome extends StatefulWidget {
  @override
  _AttendancesPageState createState() => _AttendancesPageState();
}

class _AttendancesPageState extends State<Attendanceshome> {
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
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
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
                          decoration: BoxDecoration(
                              color: Color(0xff0c2d86),
                              borderRadius: BorderRadius.circular(10)),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: _page,
          items: <Widget>[
            _buildNavBarIcon(Icons.home, 'الرئيسية', 0),
            _buildNavBarIcon(Icons.list, 'حول الشركة', 1),
            _buildNavBarIcon(Icons.compare_arrows, 'الحضور', 2),
            _buildNavBarIcon(Icons.call_split, 'التدريبات', 3),
          ],
          color: Color(0xff0c2d86),
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
