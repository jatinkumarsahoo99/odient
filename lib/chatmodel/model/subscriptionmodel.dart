// To parse this JSON data, do
//
//     final subscriptionModel = subscriptionModelFromJson(jsonString);

import 'dart:convert';

SubscriptionModel subscriptionModelFromJson(String str) =>
    SubscriptionModel.fromJson(json.decode(str));

String subscriptionModelToJson(SubscriptionModel data) =>
    json.encode(data.toJson());

class SubscriptionModel {
  int? status;
  String? message;
  List<Result>? result;

  SubscriptionModel({
    this.status,
    this.message,
    this.result,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
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
  int? packageId;
  String? transactionId;
  String? description;
  String? price;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? packageName;
  dynamic packagePrice;
  String? userName;
  DateTime? date;

  Result({
    this.id,
    this.userId,
    this.packageId,
    this.transactionId,
    this.description,
    this.price,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.packageName,
    this.packagePrice,
    this.userName,
    this.date,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userId: json["user_id"],
        packageId: json["package_id"],
        transactionId: json["transaction_id"],
        description: json["description"],
        price: json["price"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        packageName: json["package_name"],
        packagePrice: json["package_price"],
        userName: json["user_name"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "package_id": packageId,
        "transaction_id": transactionId,
        "description": description,
        "price": price,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "package_name": packageName,
        "package_price": packagePrice,
        "user_name": userName,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}
