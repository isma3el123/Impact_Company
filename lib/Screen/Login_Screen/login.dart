import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_application_16/Screen/Home_Page.dart';
import 'package:flutter_application_16/cubit/role_cubit.dart';
import 'package:flutter_application_16/cubit/uesremail_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://mmdeeb0-001-site1.dtempurl.com/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String accessToken = data['accessToken'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);

      context.read<EmailCubit>().setEmail(_emailController.text);

      await _fetchUserRole(_emailController.text, accessToken);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CombinedPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchUserRole(String email, String accessToken) async {
    final url = Uri.parse(
        'https://mmdeeb0-001-site1.dtempurl.com/api/UserRoles/get-roles/$email');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = response.body;
      final data1 = jsonDecode(data);
      String role = data1[0];
      context.read<RoleCubit>().setRole(role);
      String? userRole = context.read<RoleCubit>().state;

      print('User Role: $role');
      print(
          'User Role: $userRole 0000000000000000000000000000000000000000000000000000000000');
    } else {
      print('Failed to fetch user role');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/5.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                bottom: 220,
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeInUp(
                        duration: Duration(milliseconds: 1800),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color.fromARGB(255, 184, 138, 2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, .2),
                                blurRadius: 20.0,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 184, 138, 2)),
                                  ),
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email ",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[700]),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[700]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      FadeInUp(
                        duration: Duration(milliseconds: 1900),
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : InkWell(
                                onTap: () {
                                  _login();
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(
                                          255, 19, 22, 194)),
                                  child: Center(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 70),
                      FadeInUp(
                        duration: Duration(milliseconds: 2000),
                        child: Text(
                          "",
                          style: TextStyle(
                              color: Color.fromRGBO(143, 148, 251, 1)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
