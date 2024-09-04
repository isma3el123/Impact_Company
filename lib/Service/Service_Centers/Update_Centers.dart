import 'package:flutter_application_16/Helper/api.dart';
import 'package:flutter_application_16/Model/Centers_Model.dart';

class UpdateCenters {
  Future<CentersModel> updateCenters({
    required String centerName,
    required String media,
    required String centerLocation,
    required String phoneNumber,
    required int id,
  }) async {
    print("The id=$id");

    final body = {
      'centerName': centerName,
      'media': media,
      'centerLocation': centerLocation,
      'phoneNumber': phoneNumber,
      'id': id,
    };

    Map<String, dynamic> data = await Api().put(
      url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Centers/$id',
      body: body,
    );

    return CentersModel.fromJson(data);
  }
}
