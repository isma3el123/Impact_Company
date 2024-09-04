import 'package:flutter_application_16/Helper/Api.dart';

class Service_Delete_TrainingTypes {
  Api api = Api();
  Future<void> deleteTrainingTypes(int trainingstypeId) async {
    try {
      final url =
          'https://mmdeeb0-001-site1.dtempurl.com/api/TrainingTypes/$trainingstypeId';
      await api.delete(url: url);
      print('Training with ID $trainingstypeId deleted successfully.');
    } catch (e) {
      print('Error deleting training: ${e.toString()}');
      throw Exception('Failed to delete training');
    }
  }
}
