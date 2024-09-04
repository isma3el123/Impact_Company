// lib/services/training_service.dart

import 'package:flutter_application_16/Helper/api.dart';
import 'package:flutter_application_16/Model/Trainees_Model.dart';

class ServicegGetTrainees {
  final Api _api = Api();

  Future<List<TraineesModel>> fetchTrainees() async {
    try {
      List<dynamic> data = await _api.get(
        url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Trainees',
      );
      return data.map((json) => TraineesModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching trainings: ${e.toString()}');
      throw Exception('Failed to load trainings');
    }
  }
}
