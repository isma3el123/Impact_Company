import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Halls_Model.dart';
import 'package:flutter_application_16/Screen/Halls_Screen/Post_Halls.dart';
import 'package:flutter_application_16/Screen/Halls_Screen/Update_Halls.dart';
import 'package:flutter_application_16/Service/Service_Halls/Delete_Service.dart';
import 'package:flutter_application_16/Service/Service_Halls/Get_Halls_ByIdCenters.dart';
import 'package:flutter_application_16/widget/custombutton.dart';

class HallsPage extends StatefulWidget {
  final int centerId;

  HallsPage({required this.centerId});

  @override
  _HallsPageState createState() => _HallsPageState();
}

class _HallsPageState extends State<HallsPage> {
  late Future<List<HallsModel>> _hallsFuture;

  @override
  void initState() {
    super.initState();
    _loadHalls();
  }

  void _loadHalls() {
    setState(() {
      _hallsFuture = ServiceGetHalls().fetchHalls(widget.centerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title: Text('القاعات', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: Column(
        children: [
          CustomButton(
            text: 'إضافة قاعة',
            ontap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PostHallScreens(centerId: widget.centerId),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<HallsModel>>(
              future: _hallsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('لا توجد قاعات متاحة'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final hall = snapshot.data![index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Color(0xff0c2d86),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Card(
                          color: Color(0xff0c2d86),
                          margin: EdgeInsets.all(0.0),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12.0)),
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child: (hall.imgLink != null &&
                                          hall.imgLink!.isNotEmpty)
                                      ? Image.network(
                                          hall.imgLink!,
                                          height: 150.0,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Container(
                                              height: 150.0,
                                              width: double.infinity,
                                              color: Colors.grey,
                                              child: Center(
                                                child: Text(
                                                  'الصورة غير متوفرة',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          height: 150.0,
                                          width: double.infinity,
                                          color: Colors.grey,
                                          child: Center(
                                            child: Text(
                                              'الصورة غير متوفرة',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'اسم القاعة : ${hall.hallName}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.white),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'التفاصيل: ${hall.listDetails ?? 'لا توجد تفاصيل متاحة'}',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          context, hall);
                                    },
                                  ),
                                  SizedBox(width: 10.0),
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UpdatehallsScreen(
                                                  hallsModel: hall),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0),
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

  void _showDeleteConfirmationDialog(BuildContext context, HallsModel hall) {
    Service_Delete_Halls service_delete_halls = Service_Delete_Halls();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text('هل أنت متأكد أنك تريد حذف القاعة: ${hall.hallName}?'),
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
                  await service_delete_halls.deleteHalls(hall.id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم حذف القاعة بنجاح')),
                  );
                  _loadHalls();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('خطأ في حذف القاعة: ${e.toString()}')),
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
