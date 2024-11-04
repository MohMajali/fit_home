import 'dart:convert';

class UserModel {
  final bool error;
  final User user;

  UserModel({
    required this.error,
    required this.user,
  });

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        error: json["error"],
        user: User.fromJson(json["user"]),
      );
}

class User {
  final int id;
  final String userType;
  final String name;
  final String nationalId;
  final String password;
  final String phone;
  final String universityId;
  final int active;
  final DateTime createdAt;

  User({
    required this.id,
    required this.userType,
    required this.name,
    required this.nationalId,
    required this.password,
    required this.phone,
    required this.universityId,
    required this.active,
    required this.createdAt,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userType: json["user_type"],
        name: json["name"],
        nationalId: json["national_id"],
        password: json["password"],
        phone: json["phone"],
        universityId: json["university_id"],
        active: json["active"],
        createdAt: DateTime.parse(json["created_at"]),
      );
}
