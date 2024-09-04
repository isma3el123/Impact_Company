import 'package:flutter_application_16/Helper/Api.dart';

class Service_Delete_Trainers {
  Api api = Api();
  Future<void> deleteTrainers(int trainersId) async {
    try {
      final url =
          'https://mmdeeb0-001-site1.dtempurl.com/api/Trainers/$trainersId';
      await api.delete(url: url);
      print('Training with ID $trainersId deleted successfully.');
    } catch (e) {
      print('Error deleting training: ${e.toString()}');
      throw Exception('Failed to delete training');
    }
  }
}
