import 'package:flutter_application_16/Helper/Api.dart';

class AddTrainersToSubTrainings {
  final Api api = Api();

  Future<void> addTrainersToSubTrainings({
    required int subTrainingId,
    required List<int> trainerIds,
  }) async {
    final body = trainerIds;

    print('Request body: $body');

    final response = await api.post(
      url:
          'https://mmdeeb0-001-site1.dtempurl.com/api/SubTrainings/$subTrainingId/AddTrainers',
      body: body,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to add trainee to attendance');
    }
  }
}
