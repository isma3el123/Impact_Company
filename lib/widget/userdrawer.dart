import 'package:flutter/material.dart';
import 'package:flutter_application_16/Screen/User_Details_Screen/update_User.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_16/Service/Service_Users/Get_Service.dart';
import 'package:flutter_application_16/Model/Users.dart';
import 'package:flutter_application_16/cubit/uesremail_cubit.dart';

class UserDrawerHeader extends StatefulWidget {
  @override
  _UserDrawerHeaderState createState() => _UserDrawerHeaderState();
}

class _UserDrawerHeaderState extends State<UserDrawerHeader> {
  late Future<UserModel> _futureUser;

  @override
  void initState() {
    super.initState();
    final email = context.read<EmailCubit>().state;
    if (email != null) {
      _futureUser = ServiceGetUserByEmail().fetchUserByEmail(email);
    } else {
      _futureUser = Future.error('Email not found in cubit');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190, // يمكنك ضبط الارتفاع حسب الحاجة
      child: FutureBuilder<UserModel>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff0c2d86), // خلفية زرقاء
              ),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return DrawerHeader(
              decoration:
                  BoxDecoration(color: Color(0xff0c2d86)), // خلفية زرقاء
              child: Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.black)),
              ),
            );
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return DrawerHeader(
              decoration:
                  BoxDecoration(color: Color(0xff0c2d86)), // خلفية زرقاء
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: Color(0xff9d7b23), // لون الأيقونة الأزرق
                          size: 30,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: () {
                              // عند الضغط على الزر، انتقل إلى صفحة التعديل
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateUserPage(),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.edit,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    user.name?.isNotEmpty == true ? user.name! : 'No Name',
                    style: TextStyle(
                      color: const Color.fromARGB(
                          255, 255, 255, 255), // لون النص الأسود
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email ?? 'No Email',
                    style: TextStyle(
                      color: const Color.fromARGB(
                          255, 255, 255, 255), // لون النص الأسود
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue), // خلفية زرقاء
              child: Center(
                child: Text('No user data available',
                    style: TextStyle(color: Colors.black)),
              ),
            );
          }
        },
      ),
    );
  }
}
