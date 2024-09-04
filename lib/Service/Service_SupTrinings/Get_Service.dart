import 'package:flutter_application_16/Helper/api.dart';
import 'package:flutter_application_16/Model/SupTrinings_Model.dart';
import 'package:flutter_application_16/Model/Trainers_Model.dart';

class ServicegGetSubTraining {
  final Api _api = Api();

  Future<List<SubTrainingModel>> fetchSubTraining() async {
    try {
      List<dynamic> data = await _api.get(
        url: 'https://mmdeeb0-001-site1.dtempurl.com/api/SubTrainings',
      );
      return data.map((json) => SubTrainingModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching trainings: ${e.toString()}');
      throw Exception('Failed to load trainings');
    }
  }
}
