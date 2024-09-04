import 'package:flutter_application_16/Helper/api.dart';
import 'package:flutter_application_16/Model/Halls_Model.dart';

class ServiceGetHalls {
  final Api _api = Api();

  Future<List<HallsModel>> fetchHalls(dynamic centerId) async {
    try {
      List<dynamic> data = await _api.get(
          url:
              'https://mmdeeb0-001-site1.dtempurl.com/api/Halls/ByCenter/$centerId');
      return data.map((json) => HallsModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching rooms: ${e.toString()}');
      throw Exception('Failed to load rooms');
    }
  }
}
