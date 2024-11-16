// To parse this JSON data, do
//
//     final followerListmodel = followerListmodelFromJson(jsonString);

import 'dart:convert';

FollowerListmodel followerListmodelFromJson(String str) =>
    FollowerListmodel.fromJson(json.decode(str));

String followerListmodelToJson(FollowerListmodel data) =>
    json.encode(data.toJson());

class FollowerListmodel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  int? currentPage;
  bool? morePage;

  FollowerListmodel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory FollowerListmodel.fromJson(Map<String, dynamic> json) =>
      FollowerListmodel(
        status: json["status"],
        message: json["message"],
        result: json["result"] == null
            ? []
            : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
        totalRows: json["total_rows"],
        totalPage: json["total_page"],
        currentPage: json["current_page"],
        morePage: json["more_page"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
        "total_rows": totalRows,
        "total_page": totalPage,
        "current_page": currentPage,
        "more_page": morePage,
      };
}

class Result {
  int? id;
  int? professionId;
  int? isArtist;
  String? username;
  String? fullName;
  String? email;
  String? mobileNumber;
  String? image;
  String? tagLine;
  String? bio;
  String? availability;
  String? dateOfBirth;
  int? fees;
  int? type;
  int? deviceType;
  String? deviceToken;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? followers;
  String? profession;

  Result({
    this.id,
    this.professionId,
    this.isArtist,
    this.username,
    this.fullName,
    this.email,
    this.mobileNumber,
    this.image,
    this.tagLine,
    this.bio,
    this.availability,
    this.dateOfBirth,
    this.fees,
    this.type,
    this.deviceType,
    this.deviceToken,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.followers,
    this.profession,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        professionId: json["profession_id"],
        isArtist: json["is_artist"],
        username: json["username"],
        fullName: json["full_name"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        image: json["image"],
        tagLine: json["tag_line"],
        bio: json["bio"],
        availability: json["availability"],
        dateOfBirth: json["date_of_birth"],
        fees: json["fees"],
        type: json["type"],
        deviceType: json["device_type"],
        deviceToken: json["device_token"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        followers: json["followers"],
        profession: json["profession"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profession_id": professionId,
        "is_artist": isArtist,
        "username": username,
        "full_name": fullName,
        "email": email,
        "mobile_number": mobileNumber,
        "image": image,
        "tag_line": tagLine,
        "bio": bio,
        "availability": availability,
        "date_of_birth": dateOfBirth,
        "fees": fees,
        "type": type,
        "device_type": deviceType,
        "device_token": deviceToken,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "followers": followers,
        "profession": profession,
      };
}
