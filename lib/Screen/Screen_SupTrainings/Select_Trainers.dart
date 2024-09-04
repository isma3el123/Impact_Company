import 'dart:convert'; // تأكد من استيراد مكتبة json
import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Trainers_Model.dart';
import 'package:flutter_application_16/Service/Service_SupTrinings/Post_ById_Trainers.dart';
import 'package:flutter_application_16/Service/Service_Trainers/Get_Service.dart';

class AddTrainerToSubTraining extends StatefulWidget {
  final int subTrainingId;

  AddTrainerToSubTraining({required this.subTrainingId});

  @override
  _AddTrainerToSubTrainingScreenState createState() =>
      _AddTrainerToSubTrainingScreenState();
}

class _AddTrainerToSubTrainingScreenState
    extends State<AddTrainerToSubTraining> {
  late Future<List<TrainersModel>> _trainersFuture;
  final List<int> _selectedTrainerIds = [];

  @override
  void initState() {
    super.initState();
    _loadTrainers();
  }

  void _loadTrainers() {
    setState(() {
      _trainersFuture = ServicegGetTrainers().fetchTrainers();
    });
  }

  Future<void> _showDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Dialog لا يمكن إغلاقه بالنقر خارج إطار الديالوج
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addTrainersToSubTraining() async {
    try {
      print('Sending request for Sub-Training ID: ${widget.subTrainingId}');
      print('Selected Trainer IDs: $_selectedTrainerIds');

      if (_selectedTrainerIds.isNotEmpty) {
        await AddTrainersToSubTrainings().addTrainersToSubTrainings(
          subTrainingId: widget.subTrainingId,
          trainerIds: _selectedTrainerIds,
        );

        await _showDialog('نجاح', 'تم إضافة المدربين إلى التدريب الفرعي بنجاح');
      } else {
        await _showDialog('تحذير', 'يرجى تحديد مدربين لإضافتهم');
      }
    } catch (e) {
      await _showDialog('خطأ', 'حدث خطأ أثناء إضافة المدربين: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title: Text('إضافة مدربين إلى تدريب فرعي',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: Column(
        children: [
          FutureBuilder<List<TrainersModel>>(
            future: _trainersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('حدث خطأ: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('لا يوجد مدربين متاحين'));
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final trainer = snapshot.data![index];
                      return Card(
                        color: Color(0xff0c2d86),
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        elevation: 4.0,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          title: Text(
                            trainer.trainerName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.white),
                          ),
                          trailing: Checkbox(
                            value: _selectedTrainerIds.contains(trainer.id),
                            onChanged: (bool? checked) {
                              setState(() {
                                if (checked == true) {
                                  _selectedTrainerIds.add(trainer.id);
                                } else {
                                  _selectedTrainerIds.remove(trainer.id);
                                }
                              });
                            },
                            activeColor: Color(
                                0xFF9D7B23), // لون مربع الاختيار عند التحديد
                            checkColor: Colors
                                .white, // لون العلامة داخل مربع الاختيار عند التحديد
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Color(
                                    0xFF9D7B23); // لون مربع الاختيار عند التحديد
                              }
                              return const Color.fromARGB(255, 255, 255,
                                  255); // لون مربع الاختيار عند عدم التحديد
                            }),
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
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: _addTrainersToSubTraining,
              child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff0c2d86),
                      borderRadius: BorderRadius.circular(8)),
                  height: 50,
                  width: 150,
                  child: Center(
                      child: Text('إضافة المدربين المحددين',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w900)))),
            ),
          ),
        ],
      ),
    );
  }
}
