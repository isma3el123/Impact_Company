import 'package:flutter_application_16/Helper/Api.dart';
import 'package:flutter_application_16/Model/Trainees_Model.dart';

class UpdateServiceTrainees {
  Future<TraineesModel> updateTrainees({
    required int id,
    required String traineeName,
    required String listAttendanceStatus,
    required int trainingId,
  }) async {
    print("the id=$id");
    Map<String, dynamic> data = await Api().put(
      url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Trainees/$id',
      body: {
        'traineeName': traineeName,
        'listAttendanceStatus': listAttendanceStatus,
        'trainingId': trainingId,
        'id': id,
      },
    );
    return TraineesModel.fromJson(data);
  }
}
