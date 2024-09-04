import 'package:flutter_application_16/Helper/Api.dart';

class Service_Delete_Attendance {
  Api api = Api();
  Future<void> deleteAttendance(int Id) async {
    try {
      final url = 'https://mmdeeb0-001-site1.dtempurl.com/api/Attendances/$Id';
      await api.delete(url: url);
      print('Attendancewith ID $Id deleted successfully.');
    } catch (e) {
      print('Error deleting Attendance: ${e.toString()}');
      throw Exception('Failed to delete Attendance');
    }
  }
}
