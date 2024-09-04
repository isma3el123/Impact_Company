import 'package:flutter_application_16/Helper/Api.dart';

class AddTraineeToAttendanceService {
  final Api api = Api();

  Future<void> addTraineeToAttendance({
    required int attendanceId,
    required List<int> traineeIds,
  }) async {
    final body = traineeIds;

    print(
        'Request URL: https://mmdeeb0-001-site1.dtempurl.com/api/Attendances/$attendanceId/AddTrainees');
    print('Request body: $body');

    final response = await api.post(
      url:
          'https://mmdeeb0-001-site1.dtempurl.com/api/Attendances/$attendanceId/AddTrainees',
      body: body,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to add trainee to attendance');
    }
  }
}
