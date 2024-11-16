import 'package:dtcameo/chatmodel/model/artistmodel.dart';
import 'package:dtcameo/chatmodel/model/detailsmodel.dart';
import 'package:dtcameo/chatmodel/model/reletedartistmodel.dart';
import 'package:dtcameo/chatmodel/model/reviewmodel.dart';
import 'package:dtcameo/chatmodel/model/successmodel.dart';
import 'package:dtcameo/chatmodel/model/videomodel.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Detilsprovider extends ChangeNotifier {
  DetailsModel detailModel = DetailsModel();
  ReviewModel reviewModel = ReviewModel();
  VideoModel videoModel = VideoModel();
  ArtistModel artistModel = ArtistModel();
  ReletedArtistModel reletedArtistModel = ReletedArtistModel();
  SuccessModel successModel = SuccessModel();
  bool loaded = false;
  bool reviewLoding = false;
  bool professionLoding = false;
  bool videoLoding = false;
  bool bookratingloading = false;
  setLoding(bool isLoding) {
    loaded = isLoding;
    reviewLoding = isLoding;
    professionLoding = isLoding;
    videoLoding = isLoding;
    notifyListeners();
  }

  String? url;

  Future<void> urlOpenSocial(String socialUrl) async {
    String url = socialUrl;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> getDetails(String artistid, String userid) async {
    loaded = true;
    detailModel = await ApiService().getDetailsResponse(artistid, userid);
    loaded = false;

    notifyListeners();
  }

  Future<void> getProfession(String artistId, pageNo) async {
    professionLoding = true;
    reletedArtistModel =
        await ApiService().reletedArtistResponse(artistId, pageNo);
    professionLoding = false;

    notifyListeners();
  }

  Future<void> getReview(String touserid, int pageno) async {
    reviewLoding = true;
    reviewModel = await ApiService().getReviewResponse(touserid, pageno);
    reviewLoding = false;

    notifyListeners();
  }

  Future<void> setFollow(String touserid) async {
    if (detailModel.result?[0].isFollow == 1) {
      detailModel.result?[0].isFollow = 0;
      detailModel.result?[0].followers =
          (detailModel.result?[0].followers ?? 0) - 1;
    } else {
      detailModel.result?[0].isFollow = 1;
      detailModel.result?[0].followers =
          (detailModel.result?[0].followers ?? 0) + 1;
    }
    notifyListeners();
    await getFollowUnfollow(touserid); // Ensure the API call completes
  }

  Future<void> getFollowUnfollow(String touserid) async {
    try {
      successModel = await ApiService().getFollowUnfollowRe(touserid);
      printLog(successModel.status.toString());
      printLog(successModel.message.toString());
    } catch (e) {
      printLog('Error: $e');
    }
  }

  Future<void> addReview(
      String touserid, double rating, String description) async {
    bookratingloading = true;
    successModel =
        await ApiService().addReviewResponse(touserid, rating, description);
    printLog(successModel.status.toString());
    printLog(successModel.message.toString());
    bookratingloading = false;
    notifyListeners();
  }

  Future<void> getVideo(String userid) async {
    videoLoding = true;
    videoModel = await ApiService().getVideoArtist(userid);
    printLog(successModel.status.toString());
    printLog(successModel.message.toString());
    videoLoding = false;

    notifyListeners();
  }

  clearProvider() {
    printLog("================ Clear Provider ===============");
    detailModel = DetailsModel();
    reviewModel = ReviewModel();
    successModel = SuccessModel();
    videoModel = VideoModel();
    reletedArtistModel = ReletedArtistModel();
    url = "";
    bookratingloading = false;
    loaded = false;
    reviewLoding = false;
    professionLoding = false;
    videoLoding = false;
  }
}
