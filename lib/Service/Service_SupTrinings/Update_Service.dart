import 'package:flutter_application_16/Helper/Api.dart';
import 'package:flutter_application_16/Model/SupTrinings_Model.dart';

class UpdateSubTraining {
  Future<SubTrainingModel> updateSubTraining({
    required String subTrainingName,
    required String imgLink,
    required String subTrainingDescription,
    required int trainingTypeId,
    required int id,
  }) async {
    print("The id=$id");
    final body = {
      'subTrainingName': subTrainingName,
      'imgLink': imgLink,
      'subTrainingDescription': subTrainingDescription,
      'trainingTypeId': trainingTypeId,
      'id': id,
    };

    Map<String, dynamic> data = await Api().put(
      url: 'https://mmdeeb0-001-site1.dtempurl.com/api/SubTrainings/$id',
      body: body,
    );

    return SubTrainingModel.fromJson(data);
  }
}
