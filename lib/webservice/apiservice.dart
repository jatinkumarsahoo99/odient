import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dtcameo/chatmodel/model/alloredersmodel.dart';
import 'package:dtcameo/chatmodel/model/artistmodel.dart';
import 'package:dtcameo/chatmodel/model/artistvideorequestmodel.dart';
import 'package:dtcameo/chatmodel/model/professionmodel.dart';
import 'package:dtcameo/chatmodel/model/commentmodel.dart';
import 'package:dtcameo/chatmodel/model/detailsmodel.dart';
import 'package:dtcameo/chatmodel/model/followerlistmodel.dart';
import 'package:dtcameo/chatmodel/model/generalmodel.dart';
import 'package:dtcameo/chatmodel/model/latestvideomodel.dart';
import 'package:dtcameo/chatmodel/model/notificationmodel.dart';
import 'package:dtcameo/chatmodel/model/packagemodel.dart';
import 'package:dtcameo/chatmodel/model/pagemodel.dart';
import 'package:dtcameo/chatmodel/model/paymentoptionmodel.dart';
import 'package:dtcameo/chatmodel/model/questionmoel.dart';
import 'package:dtcameo/chatmodel/model/questionrequestmodel.dart';
import 'package:dtcameo/chatmodel/model/reletedartistmodel.dart';
import 'package:dtcameo/chatmodel/model/reviewmodel.dart';
import 'package:dtcameo/chatmodel/model/secationdetailsmodel.dart';
import 'package:dtcameo/chatmodel/model/sectionmodel.dart';
import 'package:dtcameo/chatmodel/model/subscriptionmodel.dart';
import 'package:dtcameo/chatmodel/model/successmodel.dart';
import 'package:dtcameo/chatmodel/model/uploadvideomodel.dart';
import 'package:dtcameo/chatmodel/model/usermodel.dart';
import 'package:dtcameo/chatmodel/model/usertranscationmodel.dart';
import 'package:dtcameo/chatmodel/model/videomodel.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:path/path.dart' as path;

class ApiService {
  String baseurl = Constant.baseUrl;
  late Dio dio;

  ApiService() {
    dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));
  }

  Future<GeneralModel> genralResponse() async {
    GeneralModel generalModel;
    String genralAPi = "general_setting";
    Response response = await dio.post('$baseurl$genralAPi');

    generalModel = GeneralModel.fromJson(response.data);
    return generalModel;
  }

  Future<UserModel> registerResponse(
    String type,
    String firebaseId,
    String fullname,
    String mobilenumber,
    String email,
    String password,
    String dob,
    String countryCode,
    String countryName,
    String devicetype,
    String devicetoken,
  ) async {
    UserModel userModel;
    String registerAPi = "register";
    Response response = await dio.post("$baseurl$registerAPi",
        data: FormData.fromMap({
          "type": type,
          'firebase_id': firebaseId,
          "full_name": fullname,
          "mobile_number": mobilenumber,
          "email": email,
          "password": password,
          'date_of_birth': dob,
          "country_code": countryCode,
          "country_name": countryName,
          "device_type": devicetype,
          "device_token": devicetoken,
        }));

    userModel = UserModel.fromJson(response.data);
    return userModel;
  }

  Future<UserModel> loginResponse(
    String type,
    String firebaseId,
    String email,
    String password,
    String devicetype,
    String devicetoken,
  ) async {
    UserModel userModel;
    String loginApi = "login";
    Response response = await dio.post("$baseurl$loginApi",
        data: FormData.fromMap({
          "type": type,
          'firebase_id': firebaseId,
          "email": email,
          "password": password,
          "device_type": devicetype,
          "device_token": devicetoken,
        }));

    userModel = UserModel.fromJson(response.data);
    return userModel;
  }

  Future<UserModel> socialLoginResponse(
    String type,
    String firebaseId,
    String email,
    String devicetype,
    String devicetoken,
  ) async {
    UserModel socialModel;
    String loginApi = "login";
    Response response = await dio.post("$baseurl$loginApi",
        data: FormData.fromMap({
          "type": type,
          'firebase_id': firebaseId,
          "email": email,
          "device_type": devicetype,
          "device_token": devicetoken,
        }));

    socialModel = UserModel.fromJson(response.data);
    return socialModel;
  }

  Future<UserModel> otpLoginResponse(
    String type,
    String firebaseId,
    String mobileNumber,
    String countryCode,
    String countryName,
    String devicetype,
    String devicetoken,
  ) async {
    UserModel otpModel;
    String loginApi = "login";
    Response response = await dio.post("$baseurl$loginApi",
        data: FormData.fromMap({
          "type": type,
          'firebase_id': firebaseId,
          "mobile_number": mobileNumber,
          'country_code': countryCode,
          'country_name': countryName,
          "device_type": devicetype,
          "device_token": devicetoken,
        }));

    otpModel = UserModel.fromJson(response.data);
    return otpModel;
  }
/* Artist Register APi Start */

  Future<UserModel> artistRegisterResponse(
    String type,
    String firebaseId,
    String fullname,
    String professionId,
    String mobilenumber,
    String countryCode,
    String countryName,
    String email,
    String password,
    String dob,
    String fees,
    String devicetype,
    String devicetoken,
  ) async {
    UserModel userModel;
    String artistRegisterApi = "artist_register";
    Response response = await dio.post("$baseurl$artistRegisterApi",
        data: FormData.fromMap({
          "type": type,
          'firebase_id': firebaseId,
          "full_name": fullname,
          'profession_id': professionId,
          "mobile_number": mobilenumber,
          "country_code": countryCode,
          "country_name": countryName,
          "email": email,
          "password": password,
          'date_of_birth': dob,
          'fees': fees,
          "device_type": devicetype,
          "device_token": devicetoken,
        }));

    userModel = UserModel.fromJson(response.data);
    return userModel;
  }

  Future<UserModel> artistLoginResponse(
    String type,
    String firebaseId,
    String email,
    String password,
    String devicetype,
    String devicetoken,
  ) async {
    UserModel userModel;
    String loginApi = "artist_login";
    Response response = await dio.post("$baseurl$loginApi",
        data: FormData.fromMap({
          "type": type,
          'firebase_id': firebaseId,
          "email": email,
          "password": password,
          "device_type": devicetype,
          "device_token": devicetoken,
        }));

    userModel = UserModel.fromJson(response.data);
    return userModel;
  }

  Future<UserModel> artistSocialLoginResponse(
    String type,
    String firebaseId,
    String email,
    String devicetype,
    String devicetoken,
  ) async {
    UserModel socialModel;
    String loginApi = "artist_login";
    Response response = await dio.post("$baseurl$loginApi",
        data: FormData.fromMap({
          "type": type,
          'firebase_id': firebaseId,
          "email": email,
          "device_type": devicetype,
          "device_token": devicetoken,
        }));

    socialModel = UserModel.fromJson(response.data);
    return socialModel;
  }

  Future<UserModel> artistOtpLoginResponse(
    String type,
    String firebaseId,
    String mobileNumber,
    String countryCode,
    String countryName,
    String devicetype,
    String devicetoken,
  ) async {
    UserModel otpModel;
    String loginApi = "artist_login";
    Response response = await dio.post("$baseurl$loginApi",
        data: FormData.fromMap({
          "type": type,
          'firebase_id': firebaseId,
          "mobile_number": mobileNumber,
          'country_code': countryCode,
          'country_name': countryName,
          "device_type": devicetype,
          "device_token": devicetoken,
        }));

    otpModel = UserModel.fromJson(response.data);
    return otpModel;
  }

/* End */
  Future<ArtistModel> getArtisResponse(int pageno) async {
    printLog("Api Data Response page number ====$pageno");
    ArtistModel artistModel;
    String artisApi = "get_artist";
    Response response = await dio.post('$baseurl$artisApi',
        data: FormData.fromMap({
          'user_id': (Constant.userId == null) ? 0 : Constant.userId,
          'page_no': pageno
        }));

    artistModel = ArtistModel.fromJson(response.data);
    return artistModel;
  }

  Future<SectionModel> sectionDataShowResponse() async {
    printLog("Api Data Response page number ====");
    SectionModel sectionModel;
    String sectionListApi = "get_section_list";
    Response response = await dio.post('$baseurl$sectionListApi',
        data: FormData.fromMap({
          'user_id': (Constant.userId == null) ? 0 : Constant.userId,
        }));

    sectionModel = SectionModel.fromJson(response.data);
    return sectionModel;
  }

  Future sectionDetailsResponse(
      String type, String sectionid, int pageno) async {
    printLog("Api Data Response page number ==== $pageno");
    printLog("Api Data Response Type  $type");

    SectionDetailsModel sectionDetailsModel;
    VideoModel videoModel;
    ProfessionModel categoryModel;
    String sectionDetailsApi = "get_section_detail";
    if (type == "1") {
      Response response = await dio.post('$baseurl$sectionDetailsApi',
          data: FormData.fromMap({
            'type': type,
            'section_id': sectionid,
            'user_id': (Constant.userId == null) ? 0 : Constant.userId,
            'page_no': pageno
          }));

      videoModel = VideoModel.fromJson(response.data);
      return videoModel;
    } else if (type == "2") {
      Response response = await dio.post('$baseurl$sectionDetailsApi',
          data: FormData.fromMap({
            'type': type,
            'section_id': sectionid,
            'user_id': (Constant.userId == null) ? 0 : Constant.userId,
            'page_no': pageno
          }));

      sectionDetailsModel = SectionDetailsModel.fromJson(response.data);
      return sectionDetailsModel;
    } else if (type == "3") {
      Response response = await dio.post('$baseurl$sectionDetailsApi',
          data: FormData.fromMap({
            'type': type,
            'section_id': sectionid,
            'user_id': (Constant.userId == null) ? 0 : Constant.userId,
            'page_no': pageno
          }));

      categoryModel = ProfessionModel.fromJson(response.data);
      return categoryModel;
    }
  }

  Future<ArtistModel> getArtisProfessionResponse(String professionId) async {
    ArtistModel artistModel;
    String artistByProfessionAPi = "get_artist_by_profession";
    Response response = await dio.post('$baseurl$artistByProfessionAPi',
        data: FormData.fromMap({
          'profession_id': professionId,
          'user_id': (Constant.userId == null) ? 0 : Constant.userId
        }));

    artistModel = ArtistModel.fromJson(response.data);
    return artistModel;
  }

  Future<ProfessionModel> getProfessionResponse() async {
    ProfessionModel professionModel;
    String professionApi = "get_profession";
    Response response = await dio.post('$baseurl$professionApi');

    professionModel = ProfessionModel.fromJson(response.data);
    return professionModel;
  }

  Future<ReletedArtistModel> reletedArtistResponse(
      String artistId, int pageNo) async {
    ReletedArtistModel reletedArtistModel;
    String reletedArtistAPI = "get_related_artist";
    Response response = await dio.post('$baseurl$reletedArtistAPI',
        data: FormData.fromMap({
          'artist_id': artistId,
          'user_id': (Constant.userId == null) ? 0 : Constant.userId,
          'page_no': pageNo
        }));

    reletedArtistModel = ReletedArtistModel.fromJson(response.data);
    return reletedArtistModel;
  }

  Future<UserModel> getProfileResponse(String id) async {
    UserModel profileModel;
    String profileAPi = "get_profile";
    Response response = await dio.post('$baseurl$profileAPi',
        data: FormData.fromMap({'id': id}));

    profileModel = UserModel.fromJson(response.data);
    return profileModel;
  }

  Future<VideoModel> getVideoArtist(String userid) async {
    VideoModel videoModel;
    String videoArtistApi = "get_video_by_artist";
    Response response = await dio.post('$baseurl$videoArtistApi',
        data: FormData.fromMap({'user_id': userid}));

    videoModel = VideoModel.fromJson(response.data);
    return videoModel;
  }

  Future<VideoModel> getVideoPrivateArtist(String userid) async {
    VideoModel privateVideoModel;
    String privateVideoArtistApi = "get_privet_video";
    Response response = await dio.post('$baseurl$privateVideoArtistApi',
        data: FormData.fromMap({'user_id': userid}));

    privateVideoModel = VideoModel.fromJson(response.data);
    return privateVideoModel;
  }

  Future<ArtistModel> getSearchArtistResponse(
      String fullname, int pageno) async {
    ArtistModel trandingArtistModel;
    String searchAPi = "search_artist";
    Response response = await dio.post('$baseurl$searchAPi',
        data: FormData.fromMap({'full_name': fullname, 'page_no': pageno}));

    trandingArtistModel = ArtistModel.fromJson(response.data);
    return trandingArtistModel;
  }

  Future<ArtistModel> getSearchTrendingArtistResponse(int pageNo) async {
    ArtistModel trandingArtistModel;
    String searchTrandingAPi = "get_trending_artist";
    Response response = await dio.post('$baseurl$searchTrandingAPi',
        data: FormData.fromMap({'page_no': pageNo}));

    trandingArtistModel = ArtistModel.fromJson(response.data);
    return trandingArtistModel;
  }

  Future<DetailsModel> getDetailsResponse(
      String artistid, String userid) async {
    DetailsModel detailModel;
    String detailsApi = "get_artist_details";
    Response response = await dio.post('$baseurl$detailsApi',
        data: FormData.fromMap({
          'artist_id': artistid,
          'user_id': userid,
        }));

    detailModel = DetailsModel.fromJson(response.data);
    return detailModel;
  }

  Future<SuccessModel> getFollowUnfollowRe(String toUserId) async {
    SuccessModel successModel;
    String followAPi = "follow_unfollow_user";
    Response response = await dio.post('$baseurl$followAPi',
        data: FormData.fromMap({
          'user_id': (Constant.userId == null) ? 0 : Constant.userId,
          'to_user_id': toUserId,
        }));

    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  Future<FollowerListmodel> getFollowingListRes(
      String userid, int pageno) async {
    FollowerListmodel followerListmodel;
    String followListApi = "following_list";
    Response response = await dio.post('$baseurl$followListApi',
        data: FormData.fromMap({'user_id': userid, 'page_no': pageno}));

    followerListmodel = FollowerListmodel.fromJson(response.data);
    return followerListmodel;
  }

  Future<ReviewModel> getReviewResponse(String touserid, int pageno) async {
    ReviewModel reviewModel;
    String getReviewApi = "get_review";
    Response response = await dio.post('$baseurl$getReviewApi',
        data: FormData.fromMap({'to_user_id': touserid, 'page_no': pageno}));

    reviewModel = ReviewModel.fromJson(response.data);
    return reviewModel;
  }

  Future<SuccessModel> addReviewResponse(
      String touserid, double rating, String description) async {
    SuccessModel successModel;
    String addReviewApi = "add_review";
    Response response = await dio.post('$baseurl$addReviewApi',
        data: FormData.fromMap({
          'user_id': (Constant.userId == null) ? 0 : Constant.userId,
          'to_user_id': touserid,
          'rating': rating,
          'description': description
        }));

    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  Future<PageModel> getPageResponse() async {
    PageModel pageModel;
    String pageApi = "get_pages";
    Response response = await dio.post('$baseurl$pageApi');

    pageModel = PageModel.fromJson(response.data);
    return pageModel;
  }

  Future<NotificationModel> getNotificationResponse(String userid) async {
    NotificationModel notificationModel;
    String notificationApi = "get_notification_list";
    Response response = await dio.post('$baseurl$notificationApi',
        data: FormData.fromMap({
          'user_id': userid,
        }));

    notificationModel = NotificationModel.fromJson(response.data);
    return notificationModel;
  }

  Future<SuccessModel> readNotification(
      String userid, String notificationid) async {
    SuccessModel successModel;
    String readNotificationApi = "notification_read";
    Response response = await dio.post('$baseurl$readNotificationApi',
        data: FormData.fromMap({
          'user_id': userid,
          'notification_id': notificationid,
        }));

    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  Future<PackageModel> packgeResponse() async {
    PackageModel packageModel;
    String packageAPi = "get_package";
    Response response = await dio.post('$baseurl$packageAPi');

    packageModel = PackageModel.fromJson(response.data);
    return packageModel;
  }

  Future<PaymentOptionModel> paymentOptionResponse() async {
    PaymentOptionModel paymentOptionModel;
    String paymentOptionApi = "get_payment_option";
    Response response = await dio.post('$baseurl$paymentOptionApi');

    paymentOptionModel = PaymentOptionModel.fromJson(response.data);
    return paymentOptionModel;
  }

  Future<SuccessModel> addTransactionResponse(
    String userid,
    String packageid,
    String price,
    String transactionid,
    String description,
  ) async {
    SuccessModel successModel;
    String transactionApi = "add_transaction";
    Response response = await dio.post('$baseurl$transactionApi',
        data: FormData.fromMap({
          'user_id': userid,
          'package_id': packageid,
          'price': price,
          'transaction_id': transactionid,
          'description': description,
        }));

    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  Future<SubscriptionModel> subscriptionListResponse(String userid) async {
    SubscriptionModel subscriptionModel;
    String subscriptionListAPi = "get_subscription_list";
    Response response = await dio.post('$baseurl$subscriptionListAPi',
        data: FormData.fromMap({'user_id': userid}));

    subscriptionModel = SubscriptionModel.fromJson(response.data);
    return subscriptionModel;
  }

  Future<UserTranscationModel> userTransacationResponse(String userid) async {
    UserTranscationModel userTranscationModel;
    String userTransactionAPI = "user_transaction_list";
    Response response = await dio.post('$baseurl$userTransactionAPI',
        data: FormData.fromMap({'user_id': userid}));

    userTranscationModel = UserTranscationModel.fromJson(response.data);
    return userTranscationModel;
  }

  Future<ProfessionModel> categoryResponse() async {
    ProfessionModel categoryModel;
    String categoryApi = "get_category";
    Response response = await dio.post('$baseurl$categoryApi');

    categoryModel = ProfessionModel.fromJson(response.data);
    return categoryModel;
  }

  Future<SuccessModel> videoRequestResponse(String videoFor, String fullName,
      String toUserId, String categoryId, String fees, answers) async {
    printLog("=========================================");
    printLog("Your all request answers : $videoFor");
    printLog("Your all request answers : $fullName");
    printLog("Your all request answers : $toUserId");
    printLog("Your all request answers : $categoryId");
    printLog("Your all request answers : $fees");
    printLog("Your all request answers : $answers");
    printLog("=========================================");
    SuccessModel successModel;
    String videoRequestApi = "video_request";
    Response response = await dio.post('$baseurl$videoRequestApi',
        data: FormData.fromMap({
          'user_id': (Constant.userId == null) ? 0 : Constant.userId,
          'video_for': videoFor,
          'full_name': fullName,
          'to_user_id': toUserId,
          'category_id': categoryId,
          'fees': fees,
          'answer_arr': answers
        }));

    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  Future<QuestionModel> questionResponse(String categoryId) async {
    QuestionModel questionModel;
    String questionApi = "get_question";
    Response response = await dio.post('$baseurl$questionApi',
        data: FormData.fromMap({'category_id': categoryId}));

    questionModel = QuestionModel.fromJson(response.data);
    return questionModel;
  }

  Future<SuccessModel> addUserTransactionResponse(
      String toUserId,
      String requestId,
      String fees,
      String transactionid,
      String description,
      String status) async {
    printLog("your to user id is  : $toUserId");
    printLog("your reuest id is  : $requestId");
    printLog("your fees id is  : $fees");
    printLog("your transaction id is  : $transactionid");
    printLog("your Status is : $status");

    SuccessModel successModel;
    String addUserTransactionApi = "add_user_transaction";
    Response response = await dio.post('$baseurl$addUserTransactionApi',
        data: FormData.fromMap({
          'user_id': (Constant.userId == null) ? 0 : Constant.userId,
          'to_user_id': toUserId,
          'request_id': requestId,
          'fees': fees,
          'transaction_id': transactionid,
          'description': description,
          'status': status
        }));

    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  Future<AllOredersModel> userVideoRequestListResponse(int pageNo) async {
    AllOredersModel allOredersModel;
    String userVideoRequestListApi = "user_videorequest_list";
    Response response = await dio.post('$baseurl$userVideoRequestListApi',
        data: FormData.fromMap({
          'user_id': (Constant.userId == null) ? 0 : Constant.userId,
          'page_no': pageNo
        }));

    allOredersModel = AllOredersModel.fromJson(response.data);
    return allOredersModel;
  }

  Future<UserModel> profileUpdateResponse(
    String professionId,
    String fullname,
    String email,
    String mobilenumber,
    String dob,
    String bio,
    String countryCode,
    String countryName,
    File image,
  ) async {
    printLog("=================================================");
    printLog("Your Profession Id is : ${Constant.userId}");
    printLog("Your Profession Id is : $professionId");
    printLog("Your Fullname is : $fullname");
    printLog("Your Email is : $email");
    printLog("Your Mobile Number is  : $mobilenumber");
    printLog("Your dob  is : $dob");
    printLog("Your bio  is : $bio");
    printLog("Your Country Code  is : $countryCode");
    printLog("Your Country Name  is : $countryName");
    printLog("Your image  is : $image");
    printLog("=================================================");

    UserModel updateModel;
    String updateApi = "update_profile";
    Response response = await dio.post("$baseurl$updateApi",
        data: FormData.fromMap({
          'id': (Constant.userId == null) ? 0 : Constant.userId,
          "profession_id": professionId,
          "full_name": fullname,
          "email": email,
          "mobile_number": mobilenumber,
          "date_of_birth": dob,
          "bio": bio,
          'country_code': countryCode,
          'country_name': countryName,
          if (image.path != "")
            'image': await MultipartFile.fromFile(image.path,
                filename: path.basename(image.path)),
        }));

    updateModel = UserModel.fromJson(response.data);
    return updateModel;
  }

  Future<LatestVideoModel> latestVideoResponse(int pageNo) async {
    LatestVideoModel latestVideoModel;
    String latestVideoAPI = "get_latest_video";
    Response response = await dio.post('$baseurl$latestVideoAPI',
        data: FormData.fromMap({
          'user_id': (Constant.userId == null) ? 0 : Constant.userId,
          'page_no': pageNo
        }));

    latestVideoModel = LatestVideoModel.fromJson(response.data);
    return latestVideoModel;
  }

  Future<SuccessModel> addViewResponse(String videoId) async {
    SuccessModel successModel;
    String addViewAPi = "add_view";
    Response response = await dio.post('$baseurl$addViewAPi',
        data: FormData.fromMap({
          'user_id': (Constant.userId == null) ? 0 : Constant.userId,
          'video_id': videoId
        }));

    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  Future<SuccessModel> videoLikeDislike(String videoId) async {
    printLog("=====================================");
    printLog("like viedeo id is : $videoId");
    printLog("=====================================");
    SuccessModel likeDislikeModel;
    String videoLikeDislikeAPi = "like_unlike_video";
    Response response = await dio.post('$baseurl$videoLikeDislikeAPi',
        data: FormData.fromMap({
          'user_id': (Constant.userId == null) ? 0 : Constant.userId,
          'video_id': videoId
        }));

    likeDislikeModel = SuccessModel.fromJson(response.data);
    return likeDislikeModel;
  }

  Future<SuccessModel> addCommentResponse(
      String videoId, String comment) async {
    printLog("=====================================");
    printLog("Comment viedeo id is : $videoId");
    printLog("Comment add is : $comment");
    printLog("=====================================");
    SuccessModel addCommentModel;
    String videoCommentAPi = "comment_on_video";
    Response response = await dio.post('$baseurl$videoCommentAPi',
        data: FormData.fromMap({
          'user_id': (Constant.userId == null) ? 0 : Constant.userId,
          'video_id': videoId,
          'comment': comment
        }));

    addCommentModel = SuccessModel.fromJson(response.data);
    return addCommentModel;
  }

  Future<CommentModel> getCommentResponse(String videoId) async {
    printLog("=====================================");
    printLog("Comment viedeo id is : $videoId");
    printLog("=====================================");
    CommentModel commentModel;
    String commentShowApi = "get_comment";
    Response response = await dio.post('$baseurl$commentShowApi',
        data: FormData.fromMap({
          'user_id': (Constant.userId == null) ? 0 : Constant.userId,
          'video_id': videoId,
        }));

    commentModel = CommentModel.fromJson(response.data);
    return commentModel;
  }

  Future<SuccessModel> forgetPasswordResponse(String email) async {
    printLog("=====================================");
    printLog("Forget Passowrd is : $email");
    printLog("=====================================");
    SuccessModel forgetPasswordModel;
    String forgetPasswordAPI = "forgot_password";
    Response response = await dio.post('$baseurl$forgetPasswordAPI',
        data: FormData.fromMap({
          'email': email,
        }));

    forgetPasswordModel = SuccessModel.fromJson(response.data);
    return forgetPasswordModel;
  }

  Future<ArtistVideoRequestModel> artistVideoRequestResponse(
      String userId, String status, int pageNo) async {
    printLog("=====================================");
    printLog("User ID is : $userId");
    printLog("Page No is : $pageNo");

    printLog("=====================================");
    ArtistVideoRequestModel artistVideoRequestModel;
    String artistVideoRequestAPi = "artist_video_request_list";
    Response response = await dio.post('$baseurl$artistVideoRequestAPi',
        data: FormData.fromMap(
            {'user_id': userId, 'status': status, 'page_no': pageNo}));

    artistVideoRequestModel = ArtistVideoRequestModel.fromJson(response.data);
    return artistVideoRequestModel;
  }

  Future<QuestionRequestModel> getVideoRequestResponse(String requestId) async {
    printLog("=====================================");
    printLog("Request ID is : $requestId");
    printLog("=====================================");
    QuestionRequestModel questionRequestModel;
    String questionVideoRequestApi = "get_video_request_data";
    Response response = await dio.post('$baseurl$questionVideoRequestApi',
        data: FormData.fromMap({
          'request_id': requestId,
        }));

    questionRequestModel = QuestionRequestModel.fromJson(response.data);
    return questionRequestModel;
  }

  Future<UploadVideoModel> uploadVideoResponse(String userId, String requestId,
      File videoUrl, String titile, File image, String tages) async {
    printLog("=====================================");
    printLog("User ID is : $userId");
    printLog("Request ID is : $requestId");
    printLog("Viedeo  is : $videoUrl");
    printLog("Title  is : $titile");
    printLog("image  is : $image");
    printLog("tages is : $tages");
    printLog("=====================================");
    UploadVideoModel uploadVideoModel;
    String uploadVideoApi = "upload_video_for_request";
    Response response = await dio.post('$baseurl$uploadVideoApi',
        data: FormData.fromMap({
          'user_id': userId,
          'request_id': requestId,
          'video_url': await MultipartFile.fromFile(videoUrl.path,
              filename: path.basename(videoUrl.path)),
          'title': titile,
          'image': await MultipartFile.fromFile(image.path,
              filename: path.basename(image.path)),
          'tages': tages
        }));

    uploadVideoModel = UploadVideoModel.fromJson(response.data);
    return uploadVideoModel;
  }

  Future<SuccessModel> uploadVideoStatusResponse(
    String requestId,
    String status,
  ) async {
    printLog("=====================================");
    printLog("Request ID is : $requestId");
    printLog("Request ID is : $status");

    printLog("=====================================");
    SuccessModel uploadVideoStatusModel;
    String uploadVideoStatusApi = "update_video_request_status";
    Response response = await dio.post('$baseurl$uploadVideoStatusApi',
        data: FormData.fromMap({'request_id': requestId, 'status': status}));

    uploadVideoStatusModel = SuccessModel.fromJson(response.data);
    return uploadVideoStatusModel;
  }
}
