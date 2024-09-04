class TrainingTypeModel {
  final int id;
  final String trainingTypeName;
  final String imgLink;

  TrainingTypeModel({
    required this.id,
    required this.trainingTypeName,
    required this.imgLink,
  });

  factory TrainingTypeModel.fromJson(Map<String, dynamic> json) {
    return TrainingTypeModel(
      id: json['id'] as int,
      trainingTypeName: json['trainingTypeName'] as String,
      imgLink: json['imgLink'] as String,
    );
  }
}
