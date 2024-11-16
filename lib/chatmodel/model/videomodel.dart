// To parse this JSON data, do
//
//     final videoModel = videoModelFromJson(jsonString);

import 'dart:convert';

VideoModel videoModelFromJson(String str) =>
    VideoModel.fromJson(json.decode(str));

String videoModelToJson(VideoModel data) => json.encode(data.toJson());

class VideoModel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  int? currentPage;
  bool? morePage;

  VideoModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
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
  int? totalView;
  int? totalLike;
  int? isPublic;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? userImage;
  String? name;
  int? isUserLike;

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
    this.userImage,
    this.name,
    this.isUserLike,
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
        userImage: json["user_image"],
        name: json["name"],
        isUserLike: json["is_user_like"],
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
        "user_image": userImage,
        "name": name,
        "is_user_like": isUserLike,
      };
}
