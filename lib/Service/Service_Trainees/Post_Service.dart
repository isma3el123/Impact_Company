import 'dart:convert';

import 'package:flutter_application_16/Helper/api.dart';
import 'package:flutter_application_16/Model/Trainees_Model.dart';

class PostTrainees {
  final Api api = Api();

  Future<TraineesModel> addTrainees({
    required String traineeName,
    required String listAttendanceStatus,
    required int trainingId,
  }) async {
    final body = {
      'traineeName': traineeName,
      'listAttendanceStatus': listAttendanceStatus,
      'trainingId': trainingId,
    };

    print('Request body: ${jsonEncode(body)}');

    Map<String, dynamic> data = await api.post(
      url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Trainees',
      body: body,
    );

    return TraineesModel.fromJson(data);
  }
}
