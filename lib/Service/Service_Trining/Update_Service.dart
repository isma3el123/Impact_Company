import 'package:flutter_application_16/Helper/Api.dart';
import 'package:flutter_application_16/Model/Trining_Model.dart';

class UpdateService {
  Future<TrainingModel> updateTraining({
    required String trainingName,
    required int numberOfStudents,
    required String trainingDetails,
    required int clientId,
    required int trainingInvoiceId,
    required int id,
  }) async {
    print("the id=$id");
    Map<String, dynamic> data = await Api().put(
      url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Trainings/$id',
      body: {
        'trainingName': trainingName,
        'numberOfStudents': numberOfStudents,
        'trainingDetails': trainingDetails,
        'clientId': clientId,
        'trainingInvoiceId': trainingInvoiceId,
        'id': id,
      },
    );
    return TrainingModel.fromJson(data);
  }
}
