import 'package:dtcameo/chatmodel/model/artistmodel.dart' as profession;
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class ProfessionProvider extends ChangeNotifier {
  profession.ArtistModel artistModel = profession.ArtistModel();
  bool loaded = false;

  List<profession.Result>? professionList = [];

/* Post Pagination */
  bool loadMore = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;
  setLoding(bool isLoding) {
    loaded = isLoding;

    notifyListeners();
  }

  Future<void> getProfession(String professionId) async {
    loaded = true;
    artistModel = await ApiService().getArtisProfessionResponse(professionId);
    if (artistModel.status == 200) {
      setPagination(artistModel.totalRows, artistModel.totalPage,
          artistModel.currentPage, artistModel.morePage);
      if (artistModel.result != null && (artistModel.result?.length ?? 0) > 0) {
        for (var i = 0; i < (artistModel.result?.length ?? 0); i++) {
          professionList?.add(artistModel.result?[i] ?? profession.Result());
        }
        final Map<int, profession.Result> postMap = {};
        professionList?.forEach((item) {
          postMap[item.id ?? 0] = item;
        });
        professionList = postMap.values.toList();
        setLoadMore(false);
        printLog(
            "artistModel length :=2=> ${(artistModel.result?.length ?? 0)}");
      }
      printLog("getSectionDetails status :===> ${artistModel.status}");
      printLog("getSectionDetails message :==> ${artistModel.message}");
    }

    printLog(artistModel.status.toString());
    printLog(artistModel.message.toString());
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
  }

  clearProvider() {
    printLog("==================== ClearProvider =======================");
    artistModel = profession.ArtistModel();
    professionList = [];
    professionList?.clear();
    loaded = false;
    /* Pagination */
    loadMore = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
  }
}
