import 'package:meta/meta.dart';
import 'dart:convert';

class UserModel {
    final bool error;
    final String message;
    final User user;

    UserModel({
        required this.error,
        required this.message,
        required this.user,
    });

    factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        error: json["error"],
        message: json["message"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "user": user.toJson(),
    };
}

class User {
    final int id;
    final String name;
    final String email;
    final String phone;
    final String userName;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
        required this.userName,
    });

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        userName: json["user_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "user_name": userName,
    };
}
