import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}
