import 'package:flutter_application_16/Helper/api.dart';

class AttendanceService {
  final Api _api = Api();

  Future<void> addAttendance({
    required DateTime attendanceDate,
    required int trainingId,
    required String trainingName,
  }) async {
    try {
      await _api.post(
        url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Attendances',
        body: {
          'attendanceDate': attendanceDate.toIso8601String(),
          'trainingId': trainingId,
          'trainingName': trainingName,
        },
      );
    } catch (e) {
      print('Error adding attendance: ${e.toString()}');
      throw Exception('Failed to add attendance');
    }
  }
}
