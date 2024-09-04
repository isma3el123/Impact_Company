import 'package:flutter_application_16/Helper/Api.dart';
import 'package:flutter_application_16/Model/Trining_Model.dart'; // تأكد من أن هذا المسار صحيح

class ServiceGetTrainingById {
  final Api _api = Api();

  Future<TrainingModel> fetchTrainingById(int trainingId) async {
    try {
      Map<String, dynamic> data = await _api.get(
          url:
              'https://mmdeeb0-001-site1.dtempurl.com/api/Trainings/$trainingId');

      return TrainingModel.fromJson(data);
    } catch (e) {
      print('Error fetching training: ${e.toString()}');
      throw Exception('Failed to load training');
    }
  }
}
