// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

CommentModel commentModelFromJson(String str) =>
    CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  int? status;
  String? message;
  List<Result>? result;

  CommentModel({
    this.status,
    this.message,
    this.result,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        status: json["status"],
        message: json["message"],
        result: json["result"] == null
            ? []
            : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  int? id;
  int? userId;
  int? videoId;
  String? comment;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? userImage;
  String? name;

  Result({
    this.id,
    this.userId,
    this.videoId,
    this.comment,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userImage,
    this.name,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userId: json["user_id"],
        videoId: json["video_id"],
        comment: json["comment"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        userImage: json["user_image"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "video_id": videoId,
        "comment": comment,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user_image": userImage,
        "name": name,
      };
}
