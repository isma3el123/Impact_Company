import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Attendances_Model.dart';
import 'package:flutter_application_16/Screen/Screen_Attendances/Post_Attendances.dart';
import 'package:flutter_application_16/Screen/Screen_Attendances/Select_Trainee.dart';
import 'package:flutter_application_16/Service/Service_Attendance/Get_Attendance_ById.dart';
import 'package:flutter_application_16/widget/custombutton.dart';

import 'package:flutter/material.dart';

class AttendanceByIdScreen extends StatelessWidget {
  final int trainingId;

  AttendanceByIdScreen({required this.trainingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title: Text(
          'سجلات الحضور',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: Column(
        children: [
          CustomButton(
            text: 'اضافة حضور للتدريب',
            ontap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddAttendanceScreen(trainingId: trainingId),
              ),
            ),
          ),
          CustomButton(
            text: 'إضافة متدربين إلى الحضور',
            ontap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddTraineeToAttendance(attendanceId: trainingId),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<AttendanceModel>>(
              future: ServiceGetAttendancesByTrainingId()
                  .fetchAttendancesByTrainingId(trainingId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('لا توجد سجلات حضور متاحة'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final attendance = snapshot.data![index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          elevation: 5.0,
                          margin: EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Color(0xff0c2d86)),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16.0),
                              title: Text(
                                '${attendance.trainingName}: التدريب',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.right,
                              ),
                              subtitle: Text(
                                'الحالة: ${attendance.attendanceDate}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              isThreeLine: true,
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
}
