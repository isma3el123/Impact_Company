import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Trainees_Model.dart';
import 'package:flutter_application_16/Screen/Screen_Trainees/Post_Trainees_Screen.dart';
import 'package:flutter_application_16/Screen/Screen_Trainees/Update_Trainees_Screen.dart';
import 'package:flutter_application_16/Service/Service_Trainees/Delete_Service.dart';
import 'package:flutter_application_16/Service/Service_Trainees/Get_Service.dart';
import 'package:flutter_application_16/widget/custombutton.dart';

class TraineesPage extends StatefulWidget {
  @override
  _TrainingsPageState createState() => _TrainingsPageState();
}

class _TrainingsPageState extends State<TraineesPage> {
  late Future<List<TraineesModel>> traineesFuture;

  @override
  void initState() {
    super.initState();
    _loadTrainees();
  }

  void _loadTrainees() {
    setState(() {
      traineesFuture = ServicegGetTrainees().fetchTrainees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title: Text('المتدربين', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: Column(
        children: [
          CustomButton(
            text: 'إضافة متدربين',
            ontap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostTraineesScreen(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TraineesModel>>(
              future: traineesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('لا توجد بيانات للمدربين'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final trainees = snapshot.data![index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
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
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('الاسم: ${trainees.traineeName}',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontWeight: FontWeight.w900)),
                              Text(
                                  'قائمة الحضور: ${trainees.listAttendanceStatus}',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontWeight: FontWeight.w900)),
                              Row(
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
                                              UpdateTraineesScreen(
                                            traineesModel: trainees,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          context, trainees);
                                    },
                                  ),
                                ],
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
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, TraineesModel trainees) {
    Service_Delete_Trainees _traineesService = Service_Delete_Trainees();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text(
              'هل أنت متأكد أنك تريد حذف المدرب: ${trainees.traineeName}?'),
          actions: <Widget>[
            TextButton(
              child: Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('حذف'),
              onPressed: () async {
                try {
                  await _traineesService.deleteTrainees(trainees.id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم حذف المدرب بنجاح')),
                  );
                  _loadTrainees();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('خطأ في حذف المدرب: ${e.toString()}')),
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
