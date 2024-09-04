import 'package:flutter/material.dart';
import 'package:flutter_application_16/Screen/Borading_Screen/Screen1.dart';
import 'package:flutter_application_16/Screen/Login_Screen/login.dart';
import 'package:flutter_application_16/cubit/role_cubit.dart';
import 'package:flutter_application_16/cubit/uesremail_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RoleCubit()),
        BlocProvider(create: (context) => EmailCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: OnboardingScreen(),
      ),
    );
  }
}
