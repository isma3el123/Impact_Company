import 'package:flutter_application_16/Helper/Api.dart';

class Service_Delete_Trainees {
  Api api = Api();
  Future<void> deleteTrainees(int traineesId) async {
    try {
      final url =
          'https://mmdeeb0-001-site1.dtempurl.com/api/Trainees/$traineesId';
      await api.delete(url: url);
      print('Training with ID $traineesId deleted successfully.');
    } catch (e) {
      print('Error deleting training: ${e.toString()}');
      throw Exception('Failed to delete training');
    }
  }
}
