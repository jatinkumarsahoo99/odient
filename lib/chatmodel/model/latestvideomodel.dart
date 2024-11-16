// To parse this JSON data, do
//
//     final latestVideoModel = latestVideoModelFromJson(jsonString);

import 'dart:convert';

LatestVideoModel latestVideoModelFromJson(String str) =>
    LatestVideoModel.fromJson(json.decode(str));

String latestVideoModelToJson(LatestVideoModel data) =>
    json.encode(data.toJson());

class LatestVideoModel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  int? currentPage;
  bool? morePage;

  LatestVideoModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory LatestVideoModel.fromJson(Map<String, dynamic> json) =>
      LatestVideoModel(
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
  int? requestId;
  String? title;
  String? videoUrl;
  String? image;
  String? tags;
  dynamic totalView;
  int? totalLike;
  int? isPublic;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? totalComment;
  int? isUserLike;
  String? userImage;
  String? name;

  Result({
    this.id,
    this.userId,
    this.requestId,
    this.title,
    this.videoUrl,
    this.image,
    this.tags,
    this.totalView,
    this.totalLike,
    this.isPublic,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.totalComment,
    this.isUserLike,
    this.userImage,
    this.name,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userId: json["user_id"],
        requestId: json["request_id"],
        title: json["title"],
        videoUrl: json["video_url"],
        image: json["image"],
        tags: json["tags"],
        totalView: json["total_view"],
        totalLike: json["total_like"],
        isPublic: json["is_public"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        totalComment: json["total_comment"],
        isUserLike: json["is_user_like"],
        userImage: json["user_image"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "request_id": requestId,
        "title": title,
        "video_url": videoUrl,
        "image": image,
        "tags": tags,
        "total_view": totalView,
        "total_like": totalLike,
        "is_public": isPublic,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "total_comment": totalComment,
        "is_user_like": isUserLike,
        "user_image": userImage,
        "name": name,
      };
}
