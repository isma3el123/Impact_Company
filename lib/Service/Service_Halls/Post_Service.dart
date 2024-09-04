import 'dart:convert';
import 'package:flutter_application_16/Helper/api.dart';
import 'package:flutter_application_16/Model/Halls_Model.dart';
import 'package:http/http.dart' as http;

class PostHall {
  final Api api = Api();

  Future<HallsModel> addHall({
    required String hallName,
    required String imgLink,
    required int centerId,
    required String listDetails,
  }) async {
    final body = {
      'hallName': hallName,
      'imgLink': imgLink,
      'centerId': centerId,
      'listDetails': listDetails,
    };
    print('Request body: ${jsonEncode(body)}');

    Map<String, dynamic> data = await api.post(
      url: 'https://mmdeeb0-001-site1.dtempurl.com/api/Halls',
      body: body,
    );

    return HallsModel.fromJson(data);
  }
}
