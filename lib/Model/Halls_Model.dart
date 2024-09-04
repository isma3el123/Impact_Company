class HallsModel {
  final int id;
  final String hallName;
  final String? imgLink;
  final int centerId;
  final String? listDetails;

  HallsModel({
    required this.id,
    required this.hallName,
    this.imgLink,
    required this.centerId,
    required this.listDetails,
  });

  factory HallsModel.fromJson(Map<String, dynamic> json) {
    return HallsModel(
      id: json['id'],
      hallName: json['hallName'],
      imgLink: json['imgLink'] as String ?? 'لايوجد صورة ',
      centerId: json['centerId'],
      listDetails:
          json['listDetials'] ?? '', // تعيين قيمة افتراضية إذا كانت null
    );
  }
}
