import 'dart:convert';

import 'package:flutter_application_16/Helper/api.dart';
import 'package:flutter_application_16/Model/Trainers_Model.dart';

class PostTrainers {
  final Api api = Api();

  Future<TrainersModel> addTrainers({
    required String trainerName,
    required String imgLink,
    required String listSkills,
    required String trainerSpecialization,
    required String summary,
    required String cv,
  }) async {
    final body = {
      'trainerName': trainerName,
      'imgLink': imgLink,
      'listSkills': listSkills,
      'trainerSpecialization': trainerSpecialization,
      'summary': summary,
      'cv': cv,
    };

    print('Request body: ${jsonEncode(body)}');

    Map<String, dynamic> data = await api.post(
      url:
          'https://mmdeeb0-001-site1.dtempurl.com/api/Trainers', // تأكد من استخدام عنوان URL الصحيح
      body: body,
    );

    return TrainersModel.fromJson(data);
  }
}
