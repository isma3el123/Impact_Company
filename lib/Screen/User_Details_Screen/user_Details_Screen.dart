import 'package:flutter/material.dart';
import 'package:flutter_application_16/Service/Service_Users/Get_Service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_16/Model/Users.dart';
import 'package:flutter_application_16/Helper/Api.dart';

import '../../cubit/uesremail_cubit.dart';

class UserDetailsPage extends StatefulWidget {
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late Future<UserModel> _futureUser;

  @override
  void initState() {
    super.initState();
    final email = context.read<EmailCubit>().state;
    if (email != null) {
      _futureUser = ServiceGetUserByEmail().fetchUserByEmail(email);
    } else {
      // التعامل مع حالة عدم وجود بريد إلكتروني في الـ EmailCubit
      _futureUser = Future.error('Email not found in cubit');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: FutureBuilder<UserModel>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${user.name}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Phone: ${user.phoneNumber}',
                      style: TextStyle(fontSize: 18)),
                  // أضف المزيد من الحقول حسب حاجة التطبيق
                ],
              ),
            );
          } else {
            return Center(child: Text('No user data available'));
          }
        },
      ),
    );
  }
}
