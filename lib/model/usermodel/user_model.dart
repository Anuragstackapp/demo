// To parse this JSON data, do
//
//     final userModal = userModalFromJson(jsonString);

import 'dart:convert';

List<UserModal> userModalFromJson(String str) => List<UserModal>.from(json.decode(str).map((x) => UserModal.fromJson(x)));

String userModalToJson(List<UserModal> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModal {
  UserModal({
    this.uId,
    this.name,
    this.phone,
    this.userImage,
    this.email,
    this.password,
    this.type,

  });

  String? uId;
  String? name;
  String? phone;
  String? userImage;
  String? email;
  String? password;
  String? type;

  factory UserModal.fromJson(Map  json) => UserModal(
    uId: json["uId"],
    name: json["name"],
    phone: json["phone"],
    userImage: json["userImage"],
    email: json["email"],
    password: json["password"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "uId": uId,
    "name": name,
    "phone": phone,
    "userImage": userImage,
    "email": email,
    "password":password,
    "type":type
  };
}
