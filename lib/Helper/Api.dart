import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_16/auth/sh.dart';

import 'package:http/http.dart' as http;

class Api {
  final AuthService _authService = AuthService();

  Future<dynamic> get({required String url}) async {
    final token = await _authService.getToken();
    print("Token being sent: $token");

    if (token == null || token.isEmpty) {
      throw Exception('Token is missing or invalid.');
    }

    try {
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('There is a problem: ${e.toString()}');
      return null;
    }
  }

  Future<dynamic> post({
    required String url,
    required dynamic body,
  }) async {
    final token = await _authService.getToken();
    print("Token being sent: $token");

    if (token == null || token.isEmpty) {
      throw Exception('Token is missing or invalid.');
    }

    String jsonBody = jsonEncode(body);

    print('Sending request to: $url');
    print('Body: $jsonBody');

    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      http.Response response = await http.post(
        Uri.parse(url),
        body: jsonBody,
        headers: headers,
      );
      print('Response status: ${response.statusCode}');

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          "Error: ${response.statusCode}, Message: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  Future<Map<String, dynamic>> put({
    required String url,
    dynamic body,
    String? token,
  }) async {
    final token = await _authService.getToken();
    print("Token being sent: $token");

    if (token == null || token.isEmpty) {
      throw Exception('Token is missing or invalid.');
    }
    print('body = ${jsonEncode(body)}');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    http.Response response = await http.put(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: headers,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (response.body.isNotEmpty) {
        Map<String, dynamic> data = jsonDecode(response.body);
        print('data = $data');
        return data;
      } else {
        print('No content in response');
        return body;
      }
    } else {
      throw Exception(
          'There is a problem with status code ${response.statusCode} with body ${response.body}');
    }
  }

  Future<void> delete({required String url}) async {
    final token = await _authService.getToken();
    print("Token being sent: $token");

    if (token == null || token.isEmpty) {
      throw Exception('Token is missing or invalid.');
    }

    try {
      Map<String, String> headers = {'Authorization': 'Bearer $token'};

      http.Response response =
          await http.delete(Uri.parse(url), headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Successful deletion
        print('Successfully deleted resource.');
      } else {
        throw Exception(
          'Failed to delete resource. Status code: ${response.statusCode}, Message: ${response.body}',
        );
      }
    } catch (e) {
      print('There is a problem: ${e.toString()}');
      throw Exception('Failed to delete data: $e');
    }
  }
}
