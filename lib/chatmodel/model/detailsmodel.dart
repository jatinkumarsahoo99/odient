// To parse this JSON data, do
//
//     final detailsModel = detailsModelFromJson(jsonString);

import 'dart:convert';

DetailsModel detailsModelFromJson(String str) =>
    DetailsModel.fromJson(json.decode(str));

String detailsModelToJson(DetailsModel data) => json.encode(data.toJson());

class DetailsModel {
  int? status;
  String? message;
  List<Result>? result;

  DetailsModel({
    this.status,
    this.message,
    this.result,
  });

  factory DetailsModel.fromJson(Map<String, dynamic> json) => DetailsModel(
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
  String? firebaseId;
  int? professionId;
  int? isArtist;
  String? username;
  String? fullName;
  String? email;
  String? countryCode;
  String? mobileNumber;
  String? countryName;
  String? image;
  String? tagLine;
  String? bio;
  String? availability;
  String? dateOfBirth;
  int? fees;
  int? type;
  String? instagrmUrl;
  String? snapUrl;
  String? facebookUrl;
  String? linkdinUrl;
  int? deviceType;
  String? deviceToken;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? profession;
  dynamic followers;
  dynamic averageRating;
  int? totalReview;
  int? isFollow;

  Result({
    this.id,
    this.firebaseId,
    this.professionId,
    this.isArtist,
    this.username,
    this.fullName,
    this.email,
    this.countryCode,
    this.mobileNumber,
    this.countryName,
    this.image,
    this.tagLine,
    this.bio,
    this.availability,
    this.dateOfBirth,
    this.fees,
    this.type,
    this.instagrmUrl,
    this.snapUrl,
    this.facebookUrl,
    this.linkdinUrl,
    this.deviceType,
    this.deviceToken,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.profession,
    this.followers,
    this.averageRating,
    this.totalReview,
    this.isFollow,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        firebaseId: json["firebase_id"],
        professionId: json["profession_id"],
        isArtist: json["is_artist"],
        username: json["username"],
        fullName: json["full_name"],
        email: json["email"],
        countryCode: json["country_code"],
        mobileNumber: json["mobile_number"],
        countryName: json["country_name"],
        image: json["image"],
        tagLine: json["tag_line"],
        bio: json["bio"],
        availability: json["availability"],
        dateOfBirth: json["date_of_birth"],
        fees: json["fees"],
        type: json["type"],
        instagrmUrl: json["instagrm_url"],
        snapUrl: json["snap_url"],
        facebookUrl: json["facebook_url"],
        linkdinUrl: json["linkdin_url"],
        deviceType: json["device_type"],
        deviceToken: json["device_token"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        profession: json["profession"],
        followers: json["followers"],
        averageRating: json["average_rating"],
        totalReview: json["total_review"],
        isFollow: json["is_follow"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firebase_id": firebaseId,
        "profession_id": professionId,
        "is_artist": isArtist,
        "username": username,
        "full_name": fullName,
        "email": email,
        "country_code": countryCode,
        "mobile_number": mobileNumber,
        "country_name": countryName,
        "image": image,
        "tag_line": tagLine,
        "bio": bio,
        "availability": availability,
        "date_of_birth": dateOfBirth,
        "fees": fees,
        "type": type,
        "instagrm_url": instagrmUrl,
        "snap_url": snapUrl,
        "facebook_url": facebookUrl,
        "linkdin_url": linkdinUrl,
        "device_type": deviceType,
        "device_token": deviceToken,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "profession": profession,
        "followers": followers,
        "average_rating": averageRating,
        "total_review": totalReview,
        "is_follow": isFollow,
      };
}
