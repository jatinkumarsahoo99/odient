// To parse this JSON data, do
//
//     final allOredersModel = allOredersModelFromJson(jsonString);

import 'dart:convert';

AllOredersModel allOredersModelFromJson(String str) =>
    AllOredersModel.fromJson(json.decode(str));

String allOredersModelToJson(AllOredersModel data) =>
    json.encode(data.toJson());

class AllOredersModel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  int? currentPage;
  bool? morePage;

  AllOredersModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory AllOredersModel.fromJson(Map<String, dynamic> json) =>
      AllOredersModel(
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
  String? artistName;
  String? artistFirebaseId;
  String? artistCountryCode;
  String? artistMobileNumber;
  String? artistCountryName;
  String? artistImage;
  String? artistBio;
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
    this.artistName,
    this.artistFirebaseId,
    this.artistCountryCode,
    this.artistMobileNumber,
    this.artistCountryName,
    this.artistImage,
    this.artistBio,
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
        artistName: json["artist_name"],
        artistFirebaseId: json["artist_firebase_id"],
        artistCountryCode: json["artist_country_code"],
        artistMobileNumber: json["artist_mobile_number"],
        artistCountryName: json["artist_country_name"],
        artistImage: json["artist_image"],
        artistBio: json["artist_bio"],
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
        "artist_name": artistName,
        "artist_firebase_id": artistFirebaseId,
        "artist_country_code": artistCountryCode,
        "artist_mobile_number": artistMobileNumber,
        "artist_country_name": artistCountryName,
        "artist_image": artistImage,
        "artist_bio": artistBio,
        "category_name": categoryName,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}
