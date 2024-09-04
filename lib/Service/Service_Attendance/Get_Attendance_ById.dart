import 'package:flutter_application_16/Helper/Api.dart';
import 'package:flutter_application_16/Model/Attendances_Model.dart';

class ServiceGetAttendancesByTrainingId {
  final Api _api = Api();

  Future<List<AttendanceModel>> fetchAttendancesByTrainingId(
      dynamic trainingId) async {
    try {
      List<dynamic> data = await _api.get(
          url:
              'https://mmdeeb0-001-site1.dtempurl.com/api/Attendances/ByTraining/$trainingId');
      return data.map((json) => AttendanceModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching attendances: ${e.toString()}');
      throw Exception('Failed to load attendances');
    }
  }
}
