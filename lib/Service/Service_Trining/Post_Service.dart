import 'dart:convert';

import 'package:flutter_application_16/Helper/api.dart';
import 'package:flutter_application_16/Model/Trining_Model.dart';

class PostTraining {
  final Api api = Api();

  Future<TrainingModel> addTraining({
    required String trainingName,
    required int numberOfStudents,
    required String trainingDetails,
    required int clientId,
    required int trainingInvoiceId,
  }) async {
    final body = {
      'trainingName': trainingName,
      'numberOfStudents': numberOfStudents,
      'trainingDetails': trainingDetails,
      'clientId': clientId,
      'trainingInvoiceId': trainingInvoiceId,
    };

    print('Request body: ${jsonEncode(body)}');

    Map<String, dynamic> data = await api.post(
      url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Trainings',
      body: body,
    );

    return TrainingModel.fromJson(data);
  }
}
