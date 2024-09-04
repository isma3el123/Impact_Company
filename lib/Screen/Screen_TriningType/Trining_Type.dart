import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/TriningType_Model.dart';
import 'package:flutter_application_16/Service/Service_TriningType/Get_Service.dart';

class TrainingTypePages extends StatefulWidget {
  @override
  _TrainingTypePageState createState() => _TrainingTypePageState();
}

class _TrainingTypePageState extends State<TrainingTypePages> {
  late Future<List<TrainingTypeModel>> _trainingtypefuture;

  @override
  void initState() {
    super.initState();
    _loadTrainings();
  }

  void _loadTrainings() {
    setState(() {
      _trainingtypefuture = ServicegGetTrainingTypes().fetchTrainingType();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Training Types',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.lightBlue, // بداية التدرج الأزرق الفاتح
                Colors.blue, // منتصف التدرج الأزرق المتوسط
                Colors.blueAccent, // نهاية التدرج الأزرق الداكن
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightBlue.withOpacity(0.3), // تدرج أزرق فاتح شفاف
              Colors.blue.withOpacity(0.3), // تدرج أزرق متوسط شفاف
              Colors.blueAccent.withOpacity(0.3), // تدرج أزرق داكن شفاف
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<TrainingTypeModel>>(
                future: _trainingtypefuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No trainings available'));
                  } else {
                    return ListView.builder(
                      padding:
                          EdgeInsets.only(top: 100), // لضبط المسافة من الأعلى
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final trainingtype = snapshot.data![index];
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
                          child: Card(
                            color: Colors.white,
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.lightBlue.withOpacity(0.5),
                                            Colors.blue.withOpacity(0.5),
                                            Colors.blueAccent.withOpacity(0.5),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: 10,
                                      child: Container(
                                        height: 120,
                                        width: 120,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            trainingtype.imgLink,
                                            height: 120.0,
                                            width: 120.0,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            (loadingProgress
                                                                    .expectedTotalBytes ??
                                                                1)
                                                        : null,
                                                  ),
                                                );
                                              }
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Icon(Icons.error);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 70,
                                      left: 10,
                                      child: Text(
                                        trainingtype.trainingTypeName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          color: Colors.black87,
                                        ),
                                      ),
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
      ),
    );
  }
}
