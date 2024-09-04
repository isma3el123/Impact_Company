class TrainersModel {
  final int id;
  final String trainerName;
  final String? imgLink;
  final String listSkills;
  final String trainerSpecialization;
  final String summary;
  final String cv;

  TrainersModel({
    required this.id,
    required this.trainerName,
    this.imgLink,
    required this.listSkills,
    required this.trainerSpecialization,
    required this.summary,
    required this.cv,
  });

  factory TrainersModel.fromJson(Map<String, dynamic> json) {
    return TrainersModel(
      id: json['id'],
      trainerName: json['trainerName'],
      imgLink: json['imgLink'],
      listSkills: json['listSkills'],
      trainerSpecialization: json['trainerSpecialization'],
      summary: json['summary'],
      cv: json['cv'],
    );
  }
}
