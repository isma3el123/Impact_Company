class TraineesModel {
  final int id;
  final String traineeName;
  final String listAttendanceStatus;
  final int trainingId;

  TraineesModel({
    required this.id,
    required this.traineeName,
    required this.listAttendanceStatus,
    required this.trainingId,
  });

  factory TraineesModel.fromJson(Map<String, dynamic> json) {
    return TraineesModel(
      id: json['id'],
      traineeName: json['traineeName'],
      listAttendanceStatus: json['listAttendanceStatus'],
      trainingId: json['trainingId'],
    );
  }
}
