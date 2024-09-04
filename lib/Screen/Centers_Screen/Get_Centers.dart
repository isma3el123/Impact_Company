import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Centers_Model.dart';
import 'package:flutter_application_16/Screen/Centers_Screen/Post_Centers.dart';
import 'package:flutter_application_16/Screen/Centers_Screen/Update_Ceters.dart';
import 'package:flutter_application_16/Screen/Halls_Screen/Get_Halls.dart';
import 'package:flutter_application_16/Service/Service_Centers/Delete_Service.dart';
import 'package:flutter_application_16/Service/Service_Centers/Get_Service.dart';
import 'package:flutter_application_16/widget/custombutton.dart';

class CentersPage extends StatefulWidget {
  @override
  _CenterPageState createState() => _CenterPageState();
}

class _CenterPageState extends State<CentersPage> {
  late Future<List<CentersModel>> _centerFuture;

  @override
  void initState() {
    super.initState();
    _loadCenters();
  }

  void _loadCenters() {
    setState(() {
      _centerFuture = ServicegGetCenters().fetchCenters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // تعيين لون السهم
        ),
        title: Text('المراكز', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff0c2d86),
      ),
      body: Column(
        children: [
          CustomButton(
            text: 'إضافة مركز',
            ontap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostCenterScreen(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<CentersModel>>(
              future: _centerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('لا توجد مراكز متاحة'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final center = snapshot.data![index];
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
                                  child: Image.network(
                                    center.media,
                                    height: 150.0,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  center.centerName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.white),
                                  textAlign: TextAlign.right, // النص من اليمين
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'الموقع: ${center.centerLocation}',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                  textAlign: TextAlign.right, // النص من اليمين
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'رقم الهاتف: ${center.phoneNumber}',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                  textAlign: TextAlign.right, // النص من اليمين
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .end, // ترتيب الأيقونات على اليمين
                                children: [
                                  Row(
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
                                                  UpdateCenterScreen(
                                                      centerModel: center),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(
                                              context, center);
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10.0),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HallsPage(centerId: center.id),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'عرض القاعات',
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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

  void _showDeleteConfirmationDialog(
      BuildContext context, CentersModel center) {
    Service_Delete_Centers service_delete_centers = Service_Delete_Centers();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content:
              Text('هل أنت متأكد أنك تريد حذف المركز: ${center.centerName}?'),
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
                  await service_delete_centers.deleteCenters(center.id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم حذف المركز بنجاح')),
                  );
                  _loadCenters();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('خطأ في حذف المركز: ${e.toString()}')),
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
