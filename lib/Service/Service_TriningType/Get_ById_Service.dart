import 'package:flutter_application_16/Helper/api.dart';
import 'package:flutter_application_16/Model/TriningType_Model.dart';

class ServiceGetTrainingTypeById {
  final Api _api = Api();

  Future<TrainingTypeModel> fetchTrainingTypeById(int trainingId) async {
    try {
      // جلب البيانات من الـ API
      Map<String, dynamic> data = await _api.get(
          url:
              'https://mmdeeb0-001-site1.dtempurl.com/api/TrainingTypes/$trainingId');

      // تحويل البيانات إلى نموذج TrainingTypeModel
      return TrainingTypeModel.fromJson(data);
    } catch (e) {
      print('Error fetching training types: ${e.toString()}');
      throw Exception('Failed to load training type');
    }
  }
}
