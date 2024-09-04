// lib/services/training_service.dart

import 'package:flutter_application_16/Helper/api.dart';
import 'package:flutter_application_16/Model/Trining_Model.dart'; // تأكد من المسار الصحيح للملف

class ServicegGetTrainingService {
  final Api _api = Api();

  Future<List<TrainingModel>> fetchTrainings() async {
    try {
      List<dynamic> data = await _api.get(
        url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Trainings',
      );
      return data.map((json) => TrainingModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching trainings: ${e.toString()}');
      throw Exception('Failed to load trainings');
    }
  }
}
