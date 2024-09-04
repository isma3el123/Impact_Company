import 'package:flutter_application_16/Helper/Api.dart';

class Service_Delete_Centers {
  Api api = Api();
  Future<void> deleteCenters(int centersId) async {
    try {
      final url =
          'https://mmdeeb0-001-site1.dtempurl.com/api/Centers/$centersId';
      await api.delete(url: url);
      print('Training with ID $centersId deleted successfully.');
    } catch (e) {
      print('Error deleting training: ${e.toString()}');
      throw Exception('Failed to delete training');
    }
  }
}
