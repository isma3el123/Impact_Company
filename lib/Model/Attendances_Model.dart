class AttendanceModel {
  final int id;
  final DateTime attendanceDate;
  final int trainingId;
  final String trainingName;

  AttendanceModel({
    required this.id,
    required this.attendanceDate,
    required this.trainingId,
    required this.trainingName,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      attendanceDate: DateTime.parse(json['attendanceDate']),
      trainingId: json['trainingId'],
      trainingName: json['trainingName'],
    );
  }
}
