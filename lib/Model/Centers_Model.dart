class CentersModel {
  int id;
  String centerName;
  String centerLocation;
  String phoneNumber;
  String media;

  CentersModel({
    required this.id,
    required this.centerName,
    required this.centerLocation,
    required this.phoneNumber,
    required this.media,
  });

  factory CentersModel.fromJson(Map<String, dynamic> json) {
    return CentersModel(
      id: json['id'],
      centerName: json['centerName'],
      centerLocation: json['centerLocation'],
      phoneNumber: json['phoneNumber'],
      media: json['media'],
    );
  }
}
