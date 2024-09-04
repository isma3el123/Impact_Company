import 'dart:convert';

import 'package:flutter_application_16/Helper/api.dart';
import 'package:flutter_application_16/Model/SupTrinings_Model.dart';
import 'package:flutter_application_16/Model/TriningType_Model.dart';

class PostTriningType {
  final Api api = Api();

  Future<TrainingTypeModel> addTriningType({
    required String trainingTypeName,
    required String imgLink,
  }) async {
    final body = {
      'trainingTypeName': trainingTypeName,
      'imgLink': imgLink,
    };

    print('Request body: ${jsonEncode(body)}');

    Map<String, dynamic> data = await api.post(
      url: 'https://mmdeeb0-001-site1.dtempurl.com/api/TrainingTypes',
      body: body,
    );

    return TrainingTypeModel.fromJson(data);
  }
}
