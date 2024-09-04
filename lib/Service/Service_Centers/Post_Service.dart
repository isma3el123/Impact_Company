import 'dart:convert';

import 'package:flutter_application_16/Helper/api.dart';
import 'package:flutter_application_16/Model/Centers_Model.dart';

class PostCenter {
  final Api api = Api();

  Future<CentersModel> addCenter({
    required String centerName,
    required String centerLocation,
    required String phoneNumber,
    required String media,
  }) async {
    final body = {
      'centerName': centerName,
      'centerLocation': centerLocation,
      'phoneNumber': phoneNumber,
      'media': media,
    };

    print('Request body: ${jsonEncode(body)}');

    Map<String, dynamic> data = await api.post(
      url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Centers',
      body: body,
    );

    return CentersModel.fromJson(data);
  }
}
