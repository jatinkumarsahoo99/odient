// To parse this JSON data, do
//
//     final packageModel = packageModelFromJson(jsonString);

import 'dart:convert';

PackageModel packageModelFromJson(String str) =>
    PackageModel.fromJson(json.decode(str));

String packageModelToJson(PackageModel data) => json.encode(data.toJson());

class PackageModel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  int? currentPage;
  bool? morePage;

  PackageModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
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
  String? name;
  String? price;
  String? image;
  String? time;
  String? type;
  String? androidProductPackage;
  String? iosProductPackage;
  String? webProductPackage;
  int? status;
  String? createdAt;
  String? updatedAt;

  Result({
    this.id,
    this.name,
    this.price,
    this.image,
    this.time,
    this.type,
    this.androidProductPackage,
    this.iosProductPackage,
    this.webProductPackage,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        image: json["image"],
        time: json["time"],
        type: json["type"],
        androidProductPackage: json["android_product_package"],
        iosProductPackage: json["ios_product_package"],
        webProductPackage: json["web_product_package"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "image": image,
        "time": time,
        "type": type,
        "android_product_package": androidProductPackage,
        "ios_product_package": iosProductPackage,
        "web_product_package": webProductPackage,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
