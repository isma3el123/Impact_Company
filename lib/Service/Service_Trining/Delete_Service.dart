import 'package:flutter_application_16/Helper/Api.dart';

class Service_Delete_Trinings {
  Api api = Api();
  Future<void> deleteTraining(int trainingId) async {
    try {
      final url =
          'https://mmdeeb0-001-site1.dtempurl.com/api/Trainings/$trainingId';
      await api.delete(url: url);
      print('Training with ID $trainingId deleted successfully.');
    } catch (e) {
      print('Error deleting training: ${e.toString()}');
      throw Exception('Failed to delete training');
    }
  }
}
