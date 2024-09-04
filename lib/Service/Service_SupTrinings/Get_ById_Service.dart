import 'package:flutter_application_16/Helper/Api.dart';
import 'package:flutter_application_16/Model/SupTrinings_Model.dart';

class ServiceGeSubTrainingById {
  final Api _api = Api();

  Future<List<SubTrainingModel>> fetchSubTrainingById(dynamic TriningId) async {
    try {
      List<dynamic> data = await _api.get(
          url:
              'https://mmdeeb0-001-site1.dtempurl.com/api/SubTrainings/GetSubTrainingsByTrainer/$TriningId');
      return data.map((json) => SubTrainingModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching rooms: ${e.toString()}');
      throw Exception('Failed to load rooms');
    }
  }
}
