class TrainingModel {
  final int id;
  final String trainingName;
  final int numberOfStudents;
  final String trainingDetails;
  final int clientId;
  final int trainingInvoiceId;

  TrainingModel({
    required this.id,
    required this.trainingName,
    required this.numberOfStudents,
    required this.trainingDetails,
    required this.clientId,
    required this.trainingInvoiceId,
  });

  factory TrainingModel.fromJson(Map<String, dynamic> json) {
    return TrainingModel(
      id: json['id'],
      trainingName: json['trainingName'],
      numberOfStudents: json['numberOfStudents'],
      trainingDetails: json['trainingDetails'],
      clientId: json['clientId'],
      trainingInvoiceId: json['trainingInvoiceId'],
    );
  }
}
