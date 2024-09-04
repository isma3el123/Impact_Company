import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Trining_Model.dart';
import 'package:flutter_application_16/Service/Service_Attendance/Post_Service.dart';
import 'package:flutter_application_16/Service/Service_Trining/Get_Trining_ById.dart';

class AddAttendanceScreen extends StatefulWidget {
  final int trainingId;

  AddAttendanceScreen({required this.trainingId});

  @override
  _AddAttendanceScreenState createState() => _AddAttendanceScreenState();
}

class _AddAttendanceScreenState extends State<AddAttendanceScreen> {
  DateTime? selectedDate;
  late Future<TrainingModel> trainingFuture;

  @override
  void initState() {
    super.initState();
    trainingFuture = _fetchTrainingName();
  }

  Future<TrainingModel> _fetchTrainingName() async {
    try {
      return await ServiceGetTrainingById()
          .fetchTrainingById(widget.trainingId);
    } catch (e) {
      throw Exception('Failed to load training name: ${e.toString()}');
    }
  }

  void _submitAttendance() async {
    if (selectedDate != null) {
      try {
        AttendanceService attendanceService = AttendanceService();
        final training = await _fetchTrainingName();
        await attendanceService.addAttendance(
          attendanceDate: selectedDate!,
          trainingId: widget.trainingId,
          trainingName: training.trainingName,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add attendance: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title: Text(
          'اضافة حضور',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: FutureBuilder<TrainingModel>(
        future: trainingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Training name not found'));
          } else {
            final training = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        // Color of the text and icon
                        backgroundColor:
                            Color(0xff0c2d86), // Background color of the button
                        padding: EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'اختر التاريخ: ${selectedDate == null ? 'غير محدد' : selectedDate!.toLocal().toString().split(' ')[0]}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      ' ${training.trainingName} : التدريب ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: _submitAttendance,
                      child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Color(0xff0c2d86),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                              child: Text(
                            'اضافة الحضور',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ))),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
