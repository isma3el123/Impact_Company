import 'package:flutter_application_16/Helper/api.dart';
import 'package:flutter_application_16/Model/Centers_Model.dart';
import 'package:flutter_application_16/Model/Trainees_Model.dart';

class ServicegGetCenters {
  final Api _api = Api();

  Future<List<CentersModel>> fetchCenters() async {
    try {
      List<dynamic> data = await _api.get(
        url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Centers',
      );
      return data.map((json) => CentersModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching trainings: ${e.toString()}');
      throw Exception('Failed to load trainings');
    }
  }
}
