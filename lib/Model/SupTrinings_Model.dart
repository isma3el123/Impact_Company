class SubTrainingModel {
  final int id;
  final String subTrainingName;
  final String? imgLink;
  final String subTrainingDescription;
  final int trainingTypeId;

  SubTrainingModel({
    required this.id,
    required this.subTrainingName,
    this.imgLink,
    required this.subTrainingDescription,
    required this.trainingTypeId,
  });

  factory SubTrainingModel.fromJson(Map<String, dynamic> json) {
    return SubTrainingModel(
      id: json['id'],
      subTrainingName: json['subTrainingName'],
      imgLink: json['imgLink'],
      subTrainingDescription: json['subTrainingDescription'],
      trainingTypeId: json['trainingTypeId'],
    );
  }
}
