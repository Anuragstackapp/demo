// To parse this JSON data, do
//
//     final banners = bannersFromJson(jsonString);

import 'dart:convert';

List<Banners> bannersFromJson(String str) => List<Banners>.from(json.decode(str).map((x) => Banners.fromJson(x)));

String bannersToJson(List<Banners> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Banners {
  Banners({
    this.id,
    this.bannerFor,
    this.forId,
    this.photoUrl,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isLock,
    this.redirectTo,
    this.type,
    this.redirect,
  });

  String? id;
  String? bannerFor;
  String? forId;
  String? photoUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  bool? isLock;
  String? redirectTo;
  String? type;
  String? redirect;

  factory Banners.fromJson(Map json) => Banners(
    id: json["_id"],
    bannerFor: json["bannerFor"],
    forId: json["forId"],
    photoUrl: json["photoUrl"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    isLock: json["isLock"],
    redirectTo: json["redirectTo"],
    type: json["type"],
    redirect: json["redirect"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "bannerFor": bannerFor,
    "forId": forId,
    "photoUrl": photoUrl,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "isLock": isLock,
    "redirectTo": redirectTo,
    "type": type,
    "redirect": redirect,
  };
}
