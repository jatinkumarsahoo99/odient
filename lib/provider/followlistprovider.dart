import 'package:dtcameo/chatmodel/model/followerlistmodel.dart' as follow;
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class FollowListProvider extends ChangeNotifier {
  follow.FollowerListmodel followerListmodel = follow.FollowerListmodel();
  List<follow.Result>? followList = [];
  bool loaded = false;
/* Pagenation */
  bool loadMore = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;

  setLoding(bool isLoding) {
    loaded = isLoding;

    notifyListeners();
  }

  Future<void> getFollowList(String userid, int pageno) async {
    loaded = true;
    followerListmodel = follow.FollowerListmodel();
    followerListmodel = await ApiService().getFollowingListRes(userid, pageno);
    if (followerListmodel.status == 200) {
      setPagination(followerListmodel.totalRows, followerListmodel.totalPage,
          followerListmodel.currentPage, followerListmodel.morePage);
      if (followerListmodel.result != null &&
          (followerListmodel.result?.length ?? 0) > 0) {
        printLog(
            "followerListmodel length :=1=> ${(followerListmodel.result?.length ?? 0)}");
        for (var i = 0; i < (followerListmodel.result?.length ?? 0); i++) {
          followList?.add(followerListmodel.result?[i] ?? follow.Result());
        }
        final Map<int, follow.Result> postMap = {};
        followList?.forEach((item) {
          postMap[item.id ?? 0] = item;
        });
        followList = postMap.values.toList();
        setLoadMore(false);
        printLog(
            "getRentContentList length :=2=> ${(followerListmodel.result?.length ?? 0)}");
      }
    }
    loaded = false;
    notifyListeners();
  }

  /* Page Load */
  setLoadMore(loadMore) {
    printLog("setLoadMore loadMore :=> $loadMore");
    this.loadMore = loadMore;
    notifyListeners();
  }

/* Pagenation Start */
  setPagination(
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

  clearProvider() {
    printLog("================ Clear Provider ===============");
    followerListmodel = follow.FollowerListmodel();
    loaded = false;
    followList?.clear();
    followList = [];
    /* Pagination */
    loadMore = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
  }
}
