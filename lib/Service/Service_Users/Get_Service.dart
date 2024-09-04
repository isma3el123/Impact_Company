import 'package:flutter_application_16/Helper/Api.dart';
import 'package:flutter_application_16/Model/Users.dart'; // تأكد من أن هذا المسار صحيح

class ServiceGetUserByEmail {
  final Api _api = Api();

  Future<UserModel> fetchUserByEmail(String email) async {
    try {
      Map<String, dynamic> data = await _api.get(
          url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Users/$email');

      return UserModel.fromJson(data);
    } catch (e) {
      print('Error fetching user: ${e.toString()}');
      throw Exception('Failed to load user');
    }
  }
}
