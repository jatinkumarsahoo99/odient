// To parse this JSON data, do
//
//     final questionRequestModel = questionRequestModelFromJson(jsonString);

import 'dart:convert';

QuestionRequestModel questionRequestModelFromJson(String str) =>
    QuestionRequestModel.fromJson(json.decode(str));

String questionRequestModelToJson(QuestionRequestModel data) =>
    json.encode(data.toJson());

class QuestionRequestModel {
  int? status;
  String? message;
  List<Result>? result;

  QuestionRequestModel({
    this.status,
    this.message,
    this.result,
  });

  factory QuestionRequestModel.fromJson(Map<String, dynamic> json) =>
      QuestionRequestModel(
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
  int? videoFor;
  String? fullName;
  int? categoryId;
  int? fees;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? userName;
  String? categoryName;
  DateTime? date;
  List<Questiondatum>? questiondata;

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
    this.categoryName,
    this.date,
    this.questiondata,
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
        categoryName: json["category_name"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        questiondata: json["questiondata"] == null
            ? []
            : List<Questiondatum>.from(
                json["questiondata"]!.map((x) => Questiondatum.fromJson(x))),
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
        "category_name": categoryName,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "questiondata": questiondata == null
            ? []
            : List<dynamic>.from(questiondata!.map((x) => x.toJson())),
      };
}

class Questiondatum {
  int? id;
  int? requestId;
  String? question;
  String? answer;
  String? createdAt;
  String? updatedAt;

  Questiondatum({
    this.id,
    this.requestId,
    this.question,
    this.answer,
    this.createdAt,
    this.updatedAt,
  });

  factory Questiondatum.fromJson(Map<String, dynamic> json) => Questiondatum(
        id: json["id"],
        requestId: json["request_id"],
        question: json["question"],
        answer: json["answer"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "request_id": requestId,
        "question": question,
        "answer": answer,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
