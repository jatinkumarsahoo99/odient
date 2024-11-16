// To parse this JSON data, do
//
//     final userTranscationModel = userTranscationModelFromJson(jsonString);

import 'dart:convert';

UserTranscationModel userTranscationModelFromJson(String str) =>
    UserTranscationModel.fromJson(json.decode(str));

String userTranscationModelToJson(UserTranscationModel data) =>
    json.encode(data.toJson());

class UserTranscationModel {
  int? status;
  String? message;
  List<Result>? result;

  UserTranscationModel({
    this.status,
    this.message,
    this.result,
  });

  factory UserTranscationModel.fromJson(Map<String, dynamic> json) =>
      UserTranscationModel(
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
  int? toUserId;
  int? requestId;
  String? transactionId;
  String? fees;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? artistName;
  String? userName;
  DateTime? date;

  Result({
    this.id,
    this.userId,
    this.toUserId,
    this.requestId,
    this.transactionId,
    this.fees,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.artistName,
    this.userName,
    this.date,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userId: json["user_id"],
        toUserId: json["to_user_id"],
        requestId: json["request_id"],
        transactionId: json["transaction_id"],
        fees: json["fees"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        artistName: json["artist_name"],
        userName: json["user_name"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "to_user_id": toUserId,
        "request_id": requestId,
        "transaction_id": transactionId,
        "fees": fees,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "artist_name": artistName,
        "user_name": userName,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}
