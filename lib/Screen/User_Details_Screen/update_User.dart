import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_16/Service/Service_Users/Get_Service.dart';
import 'package:flutter_application_16/Service/Service_Users/Update_Service.dart';
import 'package:flutter_application_16/cubit/uesremail_cubit.dart';
import 'package:flutter_application_16/Model/Users.dart'; // تأكد من أن نموذج المستخدم موجود
import 'package:flutter_application_16/Helper/Api.dart';

class UpdateUserPage extends StatefulWidget {
  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final email = context.read<EmailCubit>().state;
    if (email != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        // الحصول على بيانات المستخدم من الـ API
        final user = await ServiceGetUserByEmail().fetchUserByEmail(email);

        setState(() {
          _nameController.text = user.name ?? '';
          _phoneNumberController.text = user.phoneNumber ?? '';
          _isLoading = false;
        });
      } catch (error) {
        setState(() {
          _error = 'Failed to load user data';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateUser() async {
    final email = context.read<EmailCubit>().state;
    if (email != null) {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      try {
        // تحديث بيانات المستخدم
        await UpdateServiceUser().updateUser(
          email: email,
          phoneNumber: _phoneNumberController.text,
          name: _nameController.text,
        );

        // عرض AlertDialog عند نجاح التحديث
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('User updated successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // إغلاق الـ AlertDialog
                    Navigator.of(context).pop(); // العودة إلى الشاشة السابقة
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (error) {
        // عرض AlertDialog عند فشل التحديث
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to update user: $error'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // إغلاق الـ AlertDialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        setState(() {
          _error = 'Failed to update user';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        _error,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _updateUser,
                    child: Text('Save Changes'),
                  ),
                ],
              ),
      ),
    );
  }
}

class UpdateServiceUser {
  Future<void> updateUser({
    required String email,
    required String phoneNumber,
    required String name,
  }) async {
    final response = await Api().put(
      url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Users/$email',
      body: {
        'phoneNumber': phoneNumber,
        'name': name,
      },
    );
  }
}
