// To parse this JSON data, do
//
//     final sectionDetailsModel = sectionDetailsModelFromJson(jsonString);

import 'dart:convert';

SectionDetailsModel sectionDetailsModelFromJson(String str) =>
    SectionDetailsModel.fromJson(json.decode(str));

String sectionDetailsModelToJson(SectionDetailsModel data) =>
    json.encode(data.toJson());

class SectionDetailsModel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  int? currentPage;
  bool? morePage;

  SectionDetailsModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory SectionDetailsModel.fromJson(Map<String, dynamic> json) =>
      SectionDetailsModel(
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
  String? countryCode;
  String? mobileNumber;
  String? countryName;
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
  String? profession;
  int? followers;
  dynamic averageRating;
  int? totalReview;
  int? isFollow;

  Result({
    this.id,
    this.professionId,
    this.isArtist,
    this.username,
    this.fullName,
    this.email,
    this.countryCode,
    this.mobileNumber,
    this.countryName,
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
    this.profession,
    this.followers,
    this.averageRating,
    this.totalReview,
    this.isFollow,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        professionId: json["profession_id"],
        isArtist: json["is_artist"],
        username: json["username"],
        fullName: json["full_name"],
        email: json["email"],
        countryCode: json["country_code"],
        mobileNumber: json["mobile_number"],
        countryName: json["country_name"],
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
        profession: json["profession"],
        followers: json["followers"],
        averageRating: json["average_rating"],
        totalReview: json["total_review"],
        isFollow: json["is_follow"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profession_id": professionId,
        "is_artist": isArtist,
        "username": username,
        "full_name": fullName,
        "email": email,
        "country_code": countryCode,
        "mobile_number": mobileNumber,
        "country_name": countryName,
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
        "profession": profession,
        "followers": followers,
        "average_rating": averageRating,
        "total_review": totalReview,
        "is_follow": isFollow,
      };
}