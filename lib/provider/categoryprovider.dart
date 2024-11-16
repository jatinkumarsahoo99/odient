import 'package:dtcameo/chatmodel/model/reletedartistmodel.dart'
    as reletedartist;
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  reletedartist.ReletedArtistModel reletedArtistModel =
      reletedartist.ReletedArtistModel();
  List<reletedartist.Result>? reletedArtistList = [];
  bool loaded = false;
  /* Pagination */
  bool loadMore = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;
  setLoding(bool isLoding) {
    loaded = false;
    notifyListeners();
  }

  Future<void> getProfession(String artistId, int pageNo) async {
    loaded = true;
    reletedArtistModel =
        await ApiService().reletedArtistResponse(artistId, pageNo);

    if (reletedArtistModel.status == 200) {
      setPagination(reletedArtistModel.totalRows, reletedArtistModel.totalPage,
          reletedArtistModel.currentPage, reletedArtistModel.morePage);
      if (reletedArtistModel.result != null &&
          (reletedArtistModel.result?.length ?? 0) > 0) {
        printLog(
            "reletedArtistModel length :=1=> ${(reletedArtistModel.result?.length ?? 0)}");
        for (var i = 0; i < (reletedArtistModel.result?.length ?? 0); i++) {
          reletedArtistList
              ?.add(reletedArtistModel.result?[i] ?? reletedartist.Result());
        }
        final Map<int, reletedartist.Result> postMap = {};
        reletedArtistList?.forEach((item) {
          postMap[item.id ?? 0] = item;
        });
        reletedArtistList = postMap.values.toList();
        setLoadMore(false);
        printLog(
            "getRentContentList length :=2=> ${(reletedArtistModel.result?.length ?? 0)}");
      }
    }

    loaded = false;

    notifyListeners();
  }

  setLoadMore(loadMore) {
    printLog("setLoadMore loadMore :=> $loadMore");
    this.loadMore = loadMore;
    notifyListeners();
  }

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
    printLog("<================ clearProvider ================>");
    reletedArtistModel = reletedartist.ReletedArtistModel();
    reletedArtistList?.clear();
    reletedArtistList = [];
    loaded = true;

    /* Pagination */
    loadMore = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
  }
}
