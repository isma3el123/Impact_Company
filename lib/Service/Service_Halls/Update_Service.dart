import 'package:flutter_application_16/Helper/Api.dart';
import 'package:flutter_application_16/Model/Halls_Model.dart';
import 'package:flutter_application_16/Model/Trainees_Model.dart';

class UpdateServiceHalls {
  Future<HallsModel> updateHalls({
    required int id,
    required String hallName,
    required String imgLink,
    required int centerId,
    required String listDetials,
  }) async {
    print("the id=$id");
    Map<String, dynamic> data = await Api().put(
      url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Halls/$id',
      body: {
        'hallName': hallName,
        'imgLink': imgLink,
        'centerId': centerId,
        'listDetials': listDetials,
        'id': id,
      },
    );
    return HallsModel.fromJson(data);
  }
}
