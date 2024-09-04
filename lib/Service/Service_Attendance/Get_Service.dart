import 'package:flutter_application_16/Helper/api.dart';
import 'package:flutter_application_16/Model/Attendances_Model.dart';

class ServicegGetAttendance {
  final Api _api = Api();

  Future<List<AttendanceModel>> fetchAttendance() async {
    try {
      List<dynamic> data = await _api.get(
        url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Attendances',
      );
      return data.map((json) => AttendanceModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching trainings: ${e.toString()}');
      throw Exception('Failed to load trainings');
    }
  }
}
