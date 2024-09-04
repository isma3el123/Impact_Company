import 'package:flutter_application_16/Helper/Api.dart';
import 'package:flutter_application_16/Model/SupTrinings_Model.dart';
import 'package:flutter_application_16/Model/Trainers_Model.dart';

class ServiceGetTrainersById {
  final Api _api = Api();

  Future<List<TrainersModel>> fetchTrainersById(dynamic TrainersId) async {
    try {
      List<dynamic> data = await _api.get(
          url:
              'https://mmdeeb0-001-site1.dtempurl.com/api/Trainers/GetTrainersBySubTraining/$TrainersId');
      return data.map((json) => TrainersModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching rooms: ${e.toString()}');
      throw Exception('Failed to load rooms');
    }
  }
}
