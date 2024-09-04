import 'package:flutter_application_16/Helper/api.dart';

import 'package:flutter_application_16/Model/TriningType_Model.dart';

class ServicegGetTrainingTypes {
  final Api _api = Api();

  Future<List<TrainingTypeModel>> fetchTrainingType() async {
    try {
      List<dynamic> data = await _api.get(
        url: 'https://mmdeeb0-001-site1.dtempurl.com/api/TrainingTypes',
      );
      return data.map((json) => TrainingTypeModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching trainings: ${e.toString()}');
      throw Exception('Failed to load trainings');
    }
  }
}
