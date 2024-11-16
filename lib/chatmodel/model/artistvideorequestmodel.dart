// To parse this JSON data, do
//
//     final artistVideoRequestModel = artistVideoRequestModelFromJson(jsonString);

import 'dart:convert';

ArtistVideoRequestModel artistVideoRequestModelFromJson(String str) =>
    ArtistVideoRequestModel.fromJson(json.decode(str));

String artistVideoRequestModelToJson(ArtistVideoRequestModel data) =>
    json.encode(data.toJson());

class ArtistVideoRequestModel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  int? currentPage;
  bool? morePage;

  ArtistVideoRequestModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory ArtistVideoRequestModel.fromJson(Map<String, dynamic> json) =>
      ArtistVideoRequestModel(
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
  int? userId;
  int? toUserId;
  int? videoFor;
  String? fullName;
  int? categoryId;
  int? fees;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? userName;
  String? userFirebaseId;
  String? userCountryCode;
  String? userMobileNumber;
  String? userCountryName;
  String? userImage;
  String? userBio;
  String? categoryName;
  DateTime? date;

  Result({
    this.id,
    this.userId,
    this.toUserId,
    this.videoFor,
    this.fullName,
    this.categoryId,
    this.fees,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.userFirebaseId,
    this.userCountryCode,
    this.userMobileNumber,
    this.userCountryName,
    this.userImage,
    this.userBio,
    this.categoryName,
    this.date,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userId: json["user_id"],
        toUserId: json["to_user_id"],
        videoFor: json["video_for"],
        fullName: json["full_name"],
        categoryId: json["category_id"],
        fees: json["fees"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        userName: json["user_name"],
        userFirebaseId: json["user_firebase_id"],
        userCountryCode: json["user_country_code"],
        userMobileNumber: json["user_mobile_number"],
        userCountryName: json["user_country_name"],
        userImage: json["user_image"],
        userBio: json["user_bio"],
        categoryName: json["category_name"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "to_user_id": toUserId,
        "video_for": videoFor,
        "full_name": fullName,
        "category_id": categoryId,
        "fees": fees,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user_name": userName,
        "user_firebase_id": userFirebaseId,
        "user_country_code": userCountryCode,
        "user_mobile_number": userMobileNumber,
        "user_country_name": userCountryName,
        "user_image": userImage,
        "user_bio": userBio,
        "category_name": categoryName,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}
