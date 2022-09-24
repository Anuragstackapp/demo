// To parse this JSON data, do
//
//     final audioBooks = audioBooksFromJson(jsonString);

import 'dart:convert';

List<AudioBooks> audioBooksFromJson(String str) => List<AudioBooks>.from(json.decode(str).map((x) => AudioBooks.fromJson(x)));

String audioBooksToJson(List<AudioBooks> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AudioBooks {
  AudioBooks({
    this.id,
    this.type,
    this.photoUrl,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.count,
  });

  String? id;
  String? type;
  String? photoUrl;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? count;

  factory AudioBooks.fromJson(Map<String, dynamic> json) => AudioBooks(
    id: json["_id"],
    type: json["type"],
    photoUrl: json["photoUrl"],
    name: json["name"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "photoUrl": photoUrl,
    "name": name,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "count": count,
  };
}
