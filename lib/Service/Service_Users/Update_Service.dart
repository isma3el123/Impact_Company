import 'package:flutter_application_16/Helper/Api.dart';
import 'package:flutter_application_16/Model/Users.dart'; // تأكد من أن نموذج المستخدم موجود

class UpdateServiceUser {
  Future<UserModel> updateUser({
    required String email,
    required String phoneNumber,
    required String name,
  }) async {
    Map<String, dynamic> data = await Api().put(
      url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Users/$email',
      body: {
        'phoneNumber': phoneNumber,
        'name': name,
      },
    );
    return UserModel.fromJson(data);
  }
}
