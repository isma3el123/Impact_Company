import 'dart:convert';

import 'package:flutter_application_16/Helper/api.dart';
import 'package:flutter_application_16/Model/SupTrinings_Model.dart';

class PostSubTraining {
  final Api api = Api();

  Future<SubTrainingModel> addSubTraining({
    required String subTrainingName,
    required String imgLink,
    required String subTrainingDescription,
    required int trainingTypeId,
  }) async {
    final body = {
      'subTrainingName': subTrainingName,
      'imgLink': imgLink,
      'subTrainingDescription': subTrainingDescription,
      'trainingTypeId': trainingTypeId,
    };

    print('Request body: ${jsonEncode(body)}');

    Map<String, dynamic> data = await api.post(
      url: 'https://mmdeeb0-001-site1.dtempurl.com/api/SubTrainings',
      body: body,
    );

    return SubTrainingModel.fromJson(data);
  }
}
