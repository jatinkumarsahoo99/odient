import 'package:dtcameo/chatmodel/model/reviewmodel.dart' as review;
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class ReviewProvider extends ChangeNotifier {
  review.ReviewModel reviewModel = review.ReviewModel();

  List<review.Result>? reviewList = [];

  bool loaded = false;
  /* Pagenation */
  bool loadMore = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;

  setLoding(isLoding) {
    loaded = isLoding;
    notifyListeners();
  }

  Future<void> getReview(String touserid, int pageno) async {
    loaded = true;
    reviewModel = await ApiService().getReviewResponse(touserid, pageno);
    if (reviewModel.status == 200) {
      setPagination(reviewModel.totalRows, reviewModel.totalPage,
          reviewModel.currentPage, reviewModel.morePage);
      if (reviewModel.result != null && (reviewModel.result?.length ?? 0) > 0) {
        printLog(
            "reviewModel length :=1=> ${(reviewModel.result?.length ?? 0)}");
        for (var i = 0; i < (reviewModel.result?.length ?? 0); i++) {
          reviewList?.add(reviewModel.result?[i] ?? review.Result());
        }
        final Map<int, review.Result> postMap = {};
        reviewList?.forEach((item) {
          postMap[item.id ?? 0] = item;
        });
        reviewList = postMap.values.toList();
        setLoadMore(false);
        printLog(
            "getRentContentList length :=2=> ${(reviewModel.result?.length ?? 0)}");
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
    reviewModel = review.ReviewModel();
    reviewList = [];
    loaded = false;
    /* Pagination */
    loadMore = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
  }
}
