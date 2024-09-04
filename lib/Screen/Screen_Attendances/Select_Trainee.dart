import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Trainees_Model.dart';
import 'package:flutter_application_16/Service/Service_Trainees/Get_ById_Service.dart';
import 'package:flutter_application_16/Service/Service_Trainees/Get_Service.dart';

class AddTraineeToAttendance extends StatefulWidget {
  final int attendanceId;

  AddTraineeToAttendance({required this.attendanceId});

  @override
  _AddTraineeToAttendanceScreenState createState() =>
      _AddTraineeToAttendanceScreenState();
}

class _AddTraineeToAttendanceScreenState extends State<AddTraineeToAttendance> {
  late Future<List<TraineesModel>> _traineesFuture;
  final List<int> _selectedTraineeIds = [];

  @override
  void initState() {
    super.initState();
    _loadTrainees();
  }

  void _loadTrainees() {
    setState(() {
      _traineesFuture = ServicegGetTrainees().fetchTrainees();
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('نجاح'),
        content: Text('تم إضافة المتدربين إلى الحضور بنجاح'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('حسنًا'),
          ),
        ],
      ),
    );
  }

  void _addTraineesToAttendance() async {
    try {
      if (_selectedTraineeIds.isNotEmpty) {
        await AddTraineeToAttendanceService().addTraineeToAttendance(
          attendanceId: widget.attendanceId,
          traineeIds: _selectedTraineeIds,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('يرجى تحديد متدربين لإضافتهم')),
        );
      }
    } catch (e) {
      _showSuccessDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title: Text('إضافة متدربين إلى الحضور',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: Column(
        children: [
          FutureBuilder<List<TraineesModel>>(
            future: _traineesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('حدث خطأ: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('لا يوجد متدربين متاحين'));
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final trainee = snapshot.data![index];
                      return Card(
                        color: Color(0xff0c2d86),
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          title: Text(
                            trainee.traineeName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.white),
                          ),
                          trailing: Checkbox(
                            checkColor:
                                Colors.white, // لون العلامة داخل مربع الاختيار
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Color(
                                    0xFF9D7B23); // لون مربع الاختيار عند التحديد
                              }
                              return const Color.fromARGB(255, 255, 251,
                                  251); // لون مربع الاختيار عند عدم التحديد
                            }),
                            value: _selectedTraineeIds.contains(trainee.id),
                            onChanged: (bool? checked) {
                              setState(() {
                                if (checked == true) {
                                  _selectedTraineeIds.add(trainee.id);
                                } else {
                                  _selectedTraineeIds.remove(trainee.id);
                                }
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: _addTraineesToAttendance,
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Color(0xff0c2d86),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    'إضافة المتدربين المحددين',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
