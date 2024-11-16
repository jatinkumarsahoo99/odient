// To parse this JSON data, do
//
//     final uploadVideoModel = uploadVideoModelFromJson(jsonString);

import 'dart:convert';

UploadVideoModel uploadVideoModelFromJson(String str) =>
    UploadVideoModel.fromJson(json.decode(str));

String uploadVideoModelToJson(UploadVideoModel data) =>
    json.encode(data.toJson());

class UploadVideoModel {
  int? status;
  String? success;

  UploadVideoModel({
    this.status,
    this.success,
  });

  factory UploadVideoModel.fromJson(Map<String, dynamic> json) =>
      UploadVideoModel(
        status: json["status"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
      };
}
