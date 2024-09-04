import 'package:flutter_application_16/Helper/Api.dart';

class Service_Delete_SubTrainings {
  Api api = Api();
  Future<void> deleteTrainers(int subtrainingsId) async {
    try {
      final url =
          'https://mmdeeb0-001-site1.dtempurl.com/api/SubTrainings/$subtrainingsId';
      await api.delete(url: url);
      print('Training with ID $subtrainingsId deleted successfully.');
    } catch (e) {
      print('Error deleting training: ${e.toString()}');
      throw Exception('Failed to delete training');
    }
  }
}
