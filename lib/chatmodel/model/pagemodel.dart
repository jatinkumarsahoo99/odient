// To parse this JSON data, do
//
//     final pageModel = pageModelFromJson(jsonString);

import 'dart:convert';

PageModel pageModelFromJson(String str) => PageModel.fromJson(json.decode(str));

String pageModelToJson(PageModel data) => json.encode(data.toJson());

class PageModel {
  int? status;
  String? message;
  List<Result>? result;

  PageModel({
    this.status,
    this.message,
    this.result,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) => PageModel(
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
  String? pageName;
  String? title;
  String? url;
  String? icon;

  Result({
    this.pageName,
    this.title,
    this.url,
    this.icon,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        pageName: json["page_name"],
        title: json["title"],
        url: json["url"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "page_name": pageName,
        "title": title,
        "url": url,
        "icon": icon,
      };
}
