import 'package:flutter_application_16/Helper/Api.dart';

class Service_Delete_Halls {
  Api api = Api();
  Future<void> deleteHalls(int hallsId) async {
    try {
      final url = 'https://mmdeeb0-001-site1.dtempurl.com/api/Halls/$hallsId';
      await api.delete(url: url);
      print('Training with ID $hallsId deleted successfully.');
    } catch (e) {
      print('Error deleting training: ${e.toString()}');
      throw Exception('Failed to delete training');
    }
  }
}
