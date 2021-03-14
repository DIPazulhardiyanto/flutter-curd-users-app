// To parse this JSON data, do
//
//     final userResult = userResultFromJson(jsonString);

import 'dart:convert';

UserResult userResultFromJson(String str) =>
    UserResult.fromJson(json.decode(str));

String userResultToJson(UserResult data) => json.encode(data.toJson());

class UserResult {
  UserResult({
    this.message,
    this.error,
    this.code,
    this.data,
  });

  String message;
  bool error;
  int code;
  Data data;

  factory UserResult.fromJson(Map<String, dynamic> json) => UserResult(
        message: json["message"],
        error: json["error"],
        code: json["code"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "error": error,
        "code": code,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.totalItems,
    this.rows,
    this.totalPages,
    this.currentPage,
  });

  int totalItems;
  List<UserList> rows;
  int totalPages;
  int currentPage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalItems: json["totalItems"],
        rows:
            List<UserList>.from(json["rows"].map((x) => UserList.fromJson(x))),
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
        "totalPages": totalPages,
        "currentPage": currentPage,
      };
}

class UserList {
  UserList({
    this.id,
    this.name,
    this.username,
    this.email,
    this.password,
    this.token,
    this.refreshToken,
    this.role,
    this.address,
    this.phoneNumber,
    this.addressImage,
    this.status,
    this.dateOfBirth,
    this.placeOfBirth,
    this.idCard,
    this.gender,
    this.religions,
    this.ages,
    this.postalCode,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int id;
  String name;
  String username;
  String email;
  String password;
  String token;
  String refreshToken;
  int role;
  String address;
  String phoneNumber;
  String addressImage;
  bool status;
  String dateOfBirth;
  String placeOfBirth;
  String idCard;
  String gender;
  String religions;
  int ages;
  int postalCode;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        token: json["token"],
        refreshToken: json["refreshToken"],
        role: json["role"],
        address: json["address"],
        phoneNumber: json["phoneNumber"],
        addressImage: json["addressImage"],
        status: json["status"],
        dateOfBirth: json["dateOfBirth"],
        placeOfBirth: json["placeOfBirth"],
        idCard: json["idCard"],
        gender: json["gender"],
        religions: json["religions"],
        ages: json["ages"],
        postalCode: json["postalCode"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "password": password,
        "token": token,
        "refreshToken": refreshToken,
        "role": role,
        "address": address,
        "phoneNumber": phoneNumber,
        "addressImage": addressImage,
        "status": status,
        "dateOfBirth": dateOfBirth,
        "placeOfBirth": placeOfBirth,
        "idCard": idCard,
        "gender": gender,
        "religions": religions,
        "ages": ages,
        "postalCode": postalCode,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "deletedAt": deletedAt,
      };
}

String UsersToJson(UserList data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}