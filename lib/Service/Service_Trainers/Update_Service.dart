import 'package:flutter_application_16/Helper/Api.dart';
import 'package:flutter_application_16/Model/Trainers_Model.dart';

class UpdateTrainers {
  Future<TrainersModel> updateTrainers({
    required String trainerName,
    required String imgLink,
    required String listSkills,
    required String trainerSpecialization,
    required String summary,
    required String cv,
    required int id,
  }) async {
    print("The id=$id");
    final body = {
      'trainerName': trainerName,
      'imgLink': imgLink,
      'listSkills': listSkills,
      'trainerSpecialization': trainerSpecialization,
      'summary': summary,
      'cv': cv,
      'id': id,
    };

    Map<String, dynamic> data = await Api().put(
      url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Trainers/$id',
      body: body,
    );

    return TrainersModel.fromJson(data);
  }
}
