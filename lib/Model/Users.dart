class UserModel {
  final String id;
  final String? userName;
  final String? email;
  final String? phoneNumber;
  final String? name;

  UserModel({
    required this.id,
    this.userName,
    this.email,
    this.phoneNumber,
    this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      name: json['name'] as String?,
    );
  }
}
