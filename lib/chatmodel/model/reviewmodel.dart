// To parse this JSON data, do
//
//     final reviewModel = reviewModelFromJson(jsonString);

import 'dart:convert';

ReviewModel reviewModelFromJson(String str) =>
    ReviewModel.fromJson(json.decode(str));

String reviewModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  int? currentPage;
  bool? morePage;

  ReviewModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
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
  dynamic rating;
  String? description;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? userImage;
  String? name;

  Result({
    this.id,
    this.userId,
    this.toUserId,
    this.rating,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userImage,
    this.name,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userId: json["user_id"],
        toUserId: json["to_user_id"],
        rating: json["rating"],
        description: json["description"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        userImage: json["user_image"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "to_user_id": toUserId,
        "rating": rating,
        "description": description,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user_image": userImage,
        "name": name,
      };
}
