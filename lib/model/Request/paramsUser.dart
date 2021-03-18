// To parse this JSON data, do
//
//     final userParams = userParamsFromJson(jsonString);

import 'dart:convert';

UserParams userParamsFromJson(String str) => UserParams.fromJson(json.decode(str));

String userParamsToJson(UserParams data) => json.encode(data.toJson());

class UserParams {
  UserParams({
    this.size,
    this.search,
  });

  int size;
  String search;

  factory UserParams.fromJson(Map<String, dynamic> json) => UserParams(
    size: json["size"],
    search: json["search"],
  );

  Map<String, dynamic> toJson() => {
    "size": size,
    "search": search,
  };
}
