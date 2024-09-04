import 'package:flutter_application_16/Helper/Api.dart';

import 'package:flutter_application_16/Model/TriningType_Model.dart';

class UpdateTriningType {
  Future<TrainingTypeModel> updateTriningType({
    required String trainingTypeName,
    required String imgLink,
    required int id,
  }) async {
    print("The id=$id");
    final body = {
      'trainingTypeName': trainingTypeName,
      'imgLink': imgLink,
      'id': id,
    };

    Map<String, dynamic> data = await Api().put(
      url: 'https://mmdeeb0-001-site1.dtempurl.com/api/TrainingTypes/$id',
      body: body,
    );

    return TrainingTypeModel.fromJson(data);
  }
}
