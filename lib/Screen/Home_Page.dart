import 'dart:async';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_16/Model/Centers_Model.dart';
import 'package:flutter_application_16/Screen/Centers_Screen/Centers.dart';
import 'package:flutter_application_16/Screen/Halls_Screen/Details.dart';
import 'package:flutter_application_16/Screen/Login_Screen/login.dart';
import 'package:flutter_application_16/Screen/Screen_Attendances/attendance_home.dart';
import 'package:flutter_application_16/Screen/Screen_Trinings/trining_home.dart';
import 'package:flutter_application_16/Screen/aboutcompny_Screen/aboutcompny.dart';
import 'package:flutter_application_16/Service/Service_Centers/Get_Service.dart';
import 'package:flutter_application_16/Model/TriningType_Model.dart';
import 'package:flutter_application_16/Service/Service_TriningType/Get_Service.dart';
import 'package:flutter_application_16/widget/userdrawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_16/cubit/role_cubit.dart';
import 'package:flutter_application_16/widget/listtile.dart';
import 'package:flutter_application_16/Screen/Centers_Screen/Get_Centers.dart';
import 'package:flutter_application_16/Screen/Screen_Attendances/Get_Attendances.dart';
import 'package:flutter_application_16/Screen/Screen_SupTrainings/Get_Screen_SubTrainings.dart';
import 'package:flutter_application_16/Screen/Screen_Trainees/Get_Screen_Trainees.dart';
import 'package:flutter_application_16/Screen/Screen_Trainers/Get_Screen_Trainess.dart';
import 'package:flutter_application_16/Screen/Screen_TriningType/Get_Trinings_Screen.dart';
import 'package:flutter_application_16/Screen/Screen_Trinings/Get_Trinings_Screen.dart';

class CombinedPage extends StatefulWidget {
  @override
  _CombinedPageState createState() => _CombinedPageState();
}

class _CombinedPageState extends State<CombinedPage> {
  late Future<List<CentersModel>> _centerFuture;
  late Future<List<TrainingTypeModel>> _trainingTypeFuture;
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _centerFuture = ServicegGetCenters().fetchCenters();
    _trainingTypeFuture = ServicegGetTrainingTypes().fetchTrainingType();
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<RoleCubit>().state;
    return Scaffold(
        appBar: AppBar(
          /////////////////////////appbar////////////////////
          iconTheme: IconThemeData(
            color: Colors.white, // تعيين لون السهم
          ),
          title: Text(
            'Impact Company',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFF0c2d86),
            ),
          ),
          actions: [
            Builder(
              builder: (context) {
                return Visibility(
                  visible: role == 'Admin' ||
                      role == 'CenterDirector' ||
                      role == 'Facilitator' ||
                      role == 'Client',
                  child: IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                );
              },
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserDrawerHeader(), // استخدام Widget المخصص هنا
              Visibility(
                visible: role == 'Admin',
                child: CustomListTile(
                  color: Color(0xff9d7b23),
                  text: 'اعدادات المراكز',
                  icon: Icons.on_device_training_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CentersPage()),
                    );
                  },
                ),
              ),
              Visibility(
                visible: role == 'Admin' ||
                    role == 'CenterDirector' ||
                    role == 'Facilitator',
                child: CustomListTile(
                  color: Color(0xff9d7b23),
                  text: 'اعدادات التدريبات',
                  icon: Icons.on_device_training_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TrainingsPage()),
                    );
                  },
                ),
              ),
              Visibility(
                visible: role == 'Admin' ||
                    role == 'CenterDirector' ||
                    role == 'Facilitator',
                child: CustomListTile(
                  color: Color(0xff9d7b23),
                  text: 'اعدادات الحضور',
                  icon: Icons.on_device_training_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AttendancesPage()),
                    );
                  },
                ),
              ),
              Visibility(
                visible: role == 'Admin',
                child: CustomListTile(
                  color: Color(0xff9d7b23),
                  text: 'اعدادات المتدربين',
                  icon: Icons.on_device_training_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TraineesPage()),
                    );
                  },
                ),
              ),
              Visibility(
                visible: role == 'Admin',
                child: CustomListTile(
                  color: Color(0xff9d7b23),
                  text: 'اعدادات المدربين',
                  icon: Icons.on_device_training_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TrainersPage()),
                    );
                  },
                ),
              ),
              Visibility(
                visible: role == 'Admin',
                child: CustomListTile(
                  color: Color(0xff9d7b23),
                  text: 'اعدادات التدريبات الفرعية',
                  icon: Icons.on_device_training_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SupTrainingsPage()),
                    );
                  },
                ),
              ),
              Visibility(
                visible: role == 'Admin',
                child: CustomListTile(
                  color: Color(0xff9d7b23),
                  text: 'اعدادات انواع التدريبات',
                  icon: Icons.on_device_training_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TrainingTypePage()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  child: Container(
                    child: Center(
                      child: Text(
                        "تسجيل خروج",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    height: 50,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 12, 0, 119),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        /////////////////////////SlidingImageWidget//////////////////////////////
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder<List<CentersModel>>(
                future: _centerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      height: 100,
                      color: Colors.red,
                      child: Center(child: Text('Error: ${snapshot.error}')),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Container(
                      height: 100,
                      color: Colors.grey[200],
                      child: Center(child: Text('No images available')),
                    );
                  } else {
                    final centers = snapshot.data!;
                    final imageUrls =
                        centers.map((center) => center.media).toList();
                    return Center(
                        child: SlidingImageWidget(imageUrls: imageUrls));
                  }
                },
              ),
            ),
            Container(
              width: double.infinity,
              child: Text(
                "المراكز",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 13, 128),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            /////////////////////////بيانات المركز ////////////////////////////
            Expanded(
              flex: 2,
              child: FutureBuilder<List<CentersModel>>(
                future: _centerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No centers available'));
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final center = snapshot.data![index];
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 35.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.2),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                              ),
                            ],
                          ),
                          width: 220.0,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 170.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(center.media),
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.5),
                                          BlendMode.srcOver,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 90,
                                right: 20,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          ' ${center.centerName}',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.location_city,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${center.centerLocation}",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailsPage(
                                            centerId: center.id,
                                            phoneNumber: center
                                                .phoneNumber), // تمرير رقم الهاتف هنا
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF0c2d86),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'عرض القاعات',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Text(
                  "التدريبات التي نوفرها",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 13, 128),
                  ),
                  textAlign: TextAlign.center, // محاذاة النص إلى اليمين
                ),
              ),
            ),
            ////////////////////////////التدريبات ///////////////////////////
            Expanded(
              flex: 1,
              child: FutureBuilder<List<TrainingTypeModel>>(
                future: _trainingTypeFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No training types available'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final trainingType = snapshot.data![index];
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1), // لون الظل مع التعتيم
                                spreadRadius: 2, // مدى انتشار الظل
                                blurRadius: 8, // مدى ضبابية الظل
                                offset: Offset(
                                    0, 4), // إزاحة الظل (أفقياً وعمودياً)
                              ),
                            ],
                          ),
                          height: 100.0,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: Container(
                                    width: 90.0,
                                    height: 90.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(trainingType.imgLink),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(120, 0, 0, 0),
                                  child: Text(
                                    trainingType.trainingTypeName,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
          decoration: BoxDecoration(),
          child: CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: _page,
            items: <Widget>[
              _buildNavBarIcon(Icons.home, 'الرئيسية', 0),
              _buildNavBarIcon(Icons.list, 'حول الشركة', 1),
              _buildNavBarIcon(Icons.compare_arrows, 'الحضور', 2),
              _buildNavBarIcon(Icons.call_split, 'التدريبات', 3),
            ],
            color: Color(0xFF0c2d86),
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
        ));
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
}
