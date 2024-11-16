import 'package:dtcameo/chatmodel/model/commentmodel.dart';
import 'package:dtcameo/chatmodel/model/latestvideomodel.dart' as latestvideo;
import 'package:dtcameo/chatmodel/model/successmodel.dart';
import 'package:dtcameo/chatmodel/model/usermodel.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LatestVideoProvider extends ChangeNotifier {
  latestvideo.LatestVideoModel latestVideoModel =
      latestvideo.LatestVideoModel();
  UserModel profileModel = UserModel();
  SuccessModel likeDislikeModel = SuccessModel();
  SuccessModel addCommentModel = SuccessModel();
  CommentModel commentModel = CommentModel();

  List<latestvideo.Result>? latestVideoList = [];
  bool latestVideoLoding = false;
  bool commentLoding = false;
  bool profileLoding = false;
  VisibilityInfo? visibleInfo;
  setLoding(bool isLoding) {
    latestVideoLoding = isLoding;
    commentLoding = isLoding;
    profileLoding = isLoding;
    notifyListeners();
  }

/* Pagenation  */
  bool loadMore = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;

  Future<void> getProfile(BuildContext context, String id) async {
    profileLoding = true;
    profileModel = await ApiService().getProfileResponse(id);
    printLog("get_profile status :==> ${profileModel.status}");
    printLog("get_profile message :==> ${profileModel.message}");
    profileLoding = false;
    notifyListeners();
  }

  Future<void> getLatestVideo(int pageNo) async {
    latestVideoLoding = true;
    latestVideoModel = await ApiService().latestVideoResponse(pageNo);

    if (latestVideoModel.status == 200) {
      setPageNation(latestVideoModel.totalRows, latestVideoModel.totalPage,
          latestVideoModel.currentPage, latestVideoModel.morePage);

      if (latestVideoModel.result != null &&
          (latestVideoModel.result?.length ?? 0) > 0) {
        int lastPosition = 0;
        if ((latestVideoList?.length ?? 0) == 0) {
          lastPosition = 0;
        } else {
          lastPosition = (latestVideoList?.length ?? 0);
        }
        printLog("lastPosition :============> $lastPosition");
        for (var i = 0; i < (latestVideoModel.result?.length ?? 0); i++) {
          latestVideoList
              ?.add(latestVideoModel.result?[i] ?? latestvideo.Result());
        }
        final Map<int, latestvideo.Result> postMap = {};
        latestVideoList?.forEach((item) {
          postMap[item.id ?? 0] = item;
        });
        latestVideoList = postMap.values.toList();
        setLodMore(false);
      }
    }

    latestVideoLoding = false;
    notifyListeners();
  }

  Future<void> setLikeDislike(int position, String videoId) async {
    if ((latestVideoList?[position].isUserLike ?? 0) == 1) {
      latestVideoList?[position].isUserLike = 0;
      latestVideoList?[position].totalLike =
          (latestVideoList?[position].totalLike ?? 0) - 1;
    } else {
      latestVideoList?[position].isUserLike = 1;
      latestVideoList?[position].totalLike =
          (latestVideoList?[position].totalLike ?? 0) + 1;
    }
    notifyListeners();
    getLikeDislike(videoId);
  }

  getLikeDislike(String videoId) async {
    likeDislikeModel = await ApiService().videoLikeDislike(videoId);
    printLog("Success Status : ${likeDislikeModel.status}");
    printLog("Success Message : ${likeDislikeModel.message}");
    printLog("==========================");
  }

  Future<void> setComment(int position, String videoId, String comment) async {
    latestVideoList?[position].totalComment =
        (latestVideoList?[position].totalComment ?? 0) + 1;

    notifyListeners();
    addComment(videoId, comment);
  }

  addComment(String videoId, String comment) async {
    addCommentModel = await ApiService().addCommentResponse(videoId, comment);
    await getComment(videoId);
    printLog("Success Status : ${commentModel.status}");
    printLog("Success Message : ${commentModel.message}");
    printLog("==========================");
  }

  Future<void> getComment(String videoId) async {
    commentLoding = true;
    commentModel = await ApiService().getCommentResponse(videoId);
    commentLoding = false;
    notifyListeners();
  }

  setLodMore(loadMore) {
    printLog("setLoadMore loadMore :=> $loadMore");
    this.loadMore = loadMore;
    notifyListeners();
  }

  setPageNation(
      int? totalRows, int? totalPage, int? currentPage, bool? morePage) {
    printLog("setPagination currentPage :==> $currentPage");
    printLog("setPagination totalRows :====> $totalRows");
    printLog("setPagination totalPage :====> $totalPage");
    printLog("setPagination morePage :=====> $morePage");
    this.currentPage = currentPage;
    this.totalRows = totalRows;
    this.totalPage = totalPage;
    isMorePage = morePage;

    notifyListeners();
  }

  setVisibilityInfo(VisibilityInfo? visibleInfo) {
    this.visibleInfo = visibleInfo;
    notifyListeners();
  }

  clearProvider() {
    printLog('=================== Clear Provider ========================');
    latestVideoModel = latestvideo.LatestVideoModel();
    likeDislikeModel = SuccessModel();
    addCommentModel = SuccessModel();
    commentModel = CommentModel();
    latestVideoList = [];
    latestVideoList?.clear();
    latestVideoLoding = false;
    commentLoding = false;
    profileLoding = false;
    visibleInfo = null;
    /* Pagination */
    loadMore = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
  }
}
