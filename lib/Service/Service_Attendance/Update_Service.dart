import 'package:flutter_application_16/Helper/Api.dart';
import 'package:flutter_application_16/Model/Attendances_Model.dart';

class UpdateServiceAttendance {
  Future<AttendanceModel> updateAttendance({
    required int id,
    required DateTime attendanceDate,
    required int trainingId,
    required String trainingName,
  }) async {
    print("the id=$id");
    Map<String, dynamic> data = await Api().put(
      url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Attendances/$id',
      body: {
        'attendanceDate': attendanceDate.toIso8601String(),
        'trainingId': trainingId,
        'trainingName': trainingName,
        'id': id,
      },
    );
    return AttendanceModel.fromJson(data);
  }
}
