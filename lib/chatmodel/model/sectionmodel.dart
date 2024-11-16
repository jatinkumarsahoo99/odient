// To parse this JSON data, do
//
//     final sectionModel = sectionModelFromJson(jsonString);

import 'dart:convert';

SectionModel sectionModelFromJson(String str) =>
    SectionModel.fromJson(json.decode(str));

String sectionModelToJson(SectionModel data) => json.encode(data.toJson());

class SectionModel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  int? currentPage;
  bool? morePage;

  SectionModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) => SectionModel(
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
  String? title;
  String? subTitle;
  int? type;
  int? artistId;
  int? professionId;
  String? screenLayout;
  int? interest;
  int? minFees;
  int? maxFees;
  int? orderByUpload;
  int? orderByView;
  int? orderByLike;
  int? isFollow;
  int? noOfContent;
  int? viewAll;
  int? sorttable;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<Datum>? data;

  Result({
    this.id,
    this.title,
    this.subTitle,
    this.type,
    this.artistId,
    this.professionId,
    this.screenLayout,
    this.interest,
    this.minFees,
    this.maxFees,
    this.orderByUpload,
    this.orderByView,
    this.orderByLike,
    this.isFollow,
    this.noOfContent,
    this.viewAll,
    this.sorttable,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.data,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        title: json["title"],
        subTitle: json["sub_title"],
        type: json["type"],
        artistId: json["artist_id"],
        professionId: json["profession_id"],
        screenLayout: json["screen_layout"],
        interest: json["interest"],
        minFees: json["min_fees"],
        maxFees: json["max_fees"],
        orderByUpload: json["order_by_upload"],
        orderByView: json["order_by_view"],
        orderByLike: json["order_by_like"],
        isFollow: json["is_follow"],
        noOfContent: json["no_of_content"],
        viewAll: json["view_all"],
        sorttable: json["sorttable"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "sub_title": subTitle,
        "type": type,
        "artist_id": artistId,
        "profession_id": professionId,
        "screen_layout": screenLayout,
        "interest": interest,
        "min_fees": minFees,
        "max_fees": maxFees,
        "order_by_upload": orderByUpload,
        "order_by_view": orderByView,
        "order_by_like": orderByLike,
        "is_follow": isFollow,
        "no_of_content": noOfContent,
        "view_all": viewAll,
        "sorttable": sorttable,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  String? name;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? firebaseId;
  int? professionId;
  int? isArtist;
  String? username;
  String? fullName;
  String? email;
  String? countryCode;
  String? mobileNumber;
  String? countryName;
  String? tagLine;
  String? bio;
  String? availability;
  String? dateOfBirth;
  int? fees;
  int? type;
  int? deviceType;
  String? deviceToken;
  String? profession;
  int? followers;
  dynamic averageRating;
  int? totalReview;
  int? isFollow;
  int? userId;
  int? requestId;
  String? title;
  String? videoUrl;
  String? tags;
  int? totalView;
  int? totalLike;
  int? isPublic;
  String? userImage;
  int? isUserLike;
  int? totalComment;

  Datum({
    this.id,
    this.name,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.firebaseId,
    this.professionId,
    this.isArtist,
    this.username,
    this.fullName,
    this.email,
    this.countryCode,
    this.mobileNumber,
    this.countryName,
    this.tagLine,
    this.bio,
    this.availability,
    this.dateOfBirth,
    this.fees,
    this.type,
    this.deviceType,
    this.deviceToken,
    this.profession,
    this.followers,
    this.averageRating,
    this.totalReview,
    this.isFollow,
    this.userId,
    this.requestId,
    this.title,
    this.videoUrl,
    this.tags,
    this.totalView,
    this.totalLike,
    this.isPublic,
    this.userImage,
    this.isUserLike,
    this.totalComment,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        firebaseId: json["firebase_id"],
        professionId: json["profession_id"],
        isArtist: json["is_artist"],
        username: json["username"],
        fullName: json["full_name"],
        email: json["email"],
        countryCode: json["country_code"],
        mobileNumber: json["mobile_number"],
        countryName: json["country_name"],
        tagLine: json["tag_line"],
        bio: json["bio"],
        availability: json["availability"],
        dateOfBirth: json["date_of_birth"],
        fees: json["fees"],
        type: json["type"],
        deviceType: json["device_type"],
        deviceToken: json["device_token"],
        profession: json["profession"],
        followers: json["followers"],
        averageRating: json["average_rating"],
        totalReview: json["total_review"],
        isFollow: json["is_follow"],
        userId: json["user_id"],
        requestId: json["request_id"],
        title: json["title"],
        videoUrl: json["video_url"],
        tags: json["tags"],
        totalView: json["total_view"],
        totalLike: json["total_like"],
        isPublic: json["is_public"],
        userImage: json["user_image"],
        isUserLike: json["is_user_like"],
        totalComment: json["total_comment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "firebase_id": firebaseId,
        "profession_id": professionId,
        "is_artist": isArtist,
        "username": username,
        "full_name": fullName,
        "email": email,
        "country_code": countryCode,
        "mobile_number": mobileNumber,
        "country_name": countryName,
        "tag_line": tagLine,
        "bio": bio,
        "availability": availability,
        "date_of_birth": dateOfBirth,
        "fees": fees,
        "type": type,
        "device_type": deviceType,
        "device_token": deviceToken,
        "profession": profession,
        "followers": followers,
        "average_rating": averageRating,
        "total_review": totalReview,
        "is_follow": isFollow,
        "user_id": userId,
        "request_id": requestId,
        "title": title,
        "video_url": videoUrl,
        "tags": tags,
        "total_view": totalView,
        "total_like": totalLike,
        "is_public": isPublic,
        "user_image": userImage,
        "is_user_like": isUserLike,
        "total_comment": totalComment,
      };
}
