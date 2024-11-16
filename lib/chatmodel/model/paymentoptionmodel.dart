// To parse this JSON data, do
//
//     final paymentOptionModel = paymentOptionModelFromJson(jsonString);

import 'dart:convert';

PaymentOptionModel paymentOptionModelFromJson(String str) =>
    PaymentOptionModel.fromJson(json.decode(str));

String paymentOptionModelToJson(PaymentOptionModel data) =>
    json.encode(data.toJson());

class PaymentOptionModel {
  int? status;
  String? message;
  Result? result;

  PaymentOptionModel({
    this.status,
    this.message,
    this.result,
  });

  factory PaymentOptionModel.fromJson(Map<String, dynamic> json) =>
      PaymentOptionModel(
        status: json["status"],
        message: json["message"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result?.toJson(),
      };
}

class Result {
  Flutterwave? inapppurchageAndroid;
  Flutterwave? paypal;
  Flutterwave? razorpay;
  Flutterwave? flutterwave;
  Flutterwave? payumoney;
  Flutterwave? paytm;
  Flutterwave? stripe;
  Flutterwave? inapppurchageIos;

  Result({
    this.inapppurchageAndroid,
    this.paypal,
    this.razorpay,
    this.flutterwave,
    this.payumoney,
    this.paytm,
    this.stripe,
    this.inapppurchageIos,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        inapppurchageAndroid: json["inapppurchage_android"] == null
            ? null
            : Flutterwave.fromJson(json["inapppurchage_android"]),
        paypal: json["paypal"] == null
            ? null
            : Flutterwave.fromJson(json["paypal"]),
        razorpay: json["razorpay"] == null
            ? null
            : Flutterwave.fromJson(json["razorpay"]),
        flutterwave: json["flutterwave"] == null
            ? null
            : Flutterwave.fromJson(json["flutterwave"]),
        payumoney: json["payumoney"] == null
            ? null
            : Flutterwave.fromJson(json["payumoney"]),
        paytm:
            json["paytm"] == null ? null : Flutterwave.fromJson(json["paytm"]),
        stripe: json["stripe"] == null
            ? null
            : Flutterwave.fromJson(json["stripe"]),
        inapppurchageIos: json["inapppurchage_ios"] == null
            ? null
            : Flutterwave.fromJson(json["inapppurchage_ios"]),
      );

  Map<String, dynamic> toJson() => {
        "inapppurchage_android": inapppurchageAndroid?.toJson(),
        "paypal": paypal?.toJson(),
        "razorpay": razorpay?.toJson(),
        "flutterwave": flutterwave?.toJson(),
        "payumoney": payumoney?.toJson(),
        "paytm": paytm?.toJson(),
        "stripe": stripe?.toJson(),
        "inapppurchage_ios": inapppurchageIos?.toJson(),
      };
}

class Flutterwave {
  int? id;
  String? name;
  String? visibility;
  String? isLive;
  String? key1;
  String? key2;
  String? key3;
  String? key4;
  String? createdAt;
  String? updatedAt;

  Flutterwave({
    this.id,
    this.name,
    this.visibility,
    this.isLive,
    this.key1,
    this.key2,
    this.key3,
    this.key4,
    this.createdAt,
    this.updatedAt,
  });

  factory Flutterwave.fromJson(Map<String, dynamic> json) => Flutterwave(
        id: json["id"],
        name: json["name"],
        visibility: json["visibility"],
        isLive: json["is_live"],
        key1: json["key_1"],
        key2: json["key_2"],
        key3: json["key_3"],
        key4: json["key_4"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "visibility": visibility,
        "is_live": isLive,
        "key_1": key1,
        "key_2": key2,
        "key_3": key3,
        "key_4": key4,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
