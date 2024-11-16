import 'package:dtcameo/chatmodel/model/artistmodel.dart' as artist;
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class Searchprovider extends ChangeNotifier {
  artist.ArtistModel trandingArtistModel = artist.ArtistModel();
  List<artist.Result>? artistList = [];
  bool loaded = false, loadMore = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;

  Future<void> getArtist(String fullname, int pageno) async {
    loaded = true;
    trandingArtistModel =
        await ApiService().getSearchArtistResponse(fullname, pageno);

    if (trandingArtistModel.status == 200) {
      setPagination(
          trandingArtistModel.totalRows,
          trandingArtistModel.totalPage,
          trandingArtistModel.currentPage,
          trandingArtistModel.morePage);
      if (trandingArtistModel.result != null &&
          (trandingArtistModel.result?.length ?? 0) > 0) {
        printLog(
            "trandingArtistModel length :=1=> ${(trandingArtistModel.result?.length ?? 0)}");
        for (var i = 0; i < (trandingArtistModel.result?.length ?? 0); i++) {
          artistList?.add(trandingArtistModel.result?[i] ?? artist.Result());
        }
        final Map<int, artist.Result> postMap = {};
        artistList?.forEach((item) {
          postMap[item.id ?? 0] = item;
        });
        artistList = postMap.values.toList();
        setLoadMore(false);
        printLog(
            "getRentContentList length :=2=> ${(trandingArtistModel.result?.length ?? 0)}");
      }
    }

    loaded = false;
    notifyListeners();
  }

  Future<void> getTranding(int pageNo) async {
    loaded = true;
    trandingArtistModel =
        await ApiService().getSearchTrendingArtistResponse(pageNo);
    if (trandingArtistModel.status == 200) {
      setPagination(
          trandingArtistModel.totalRows,
          trandingArtistModel.totalPage,
          trandingArtistModel.currentPage,
          trandingArtistModel.morePage);
      if (trandingArtistModel.result != null &&
          (trandingArtistModel.result?.length ?? 0) > 0) {
        printLog(
            "trandingArtistModel length :=1=> ${(trandingArtistModel.result?.length ?? 0)}");
        for (var i = 0; i < (trandingArtistModel.result?.length ?? 0); i++) {
          artistList?.add(trandingArtistModel.result?[i] ?? artist.Result());
        }
        final Map<int, artist.Result> postMap = {};
        artistList?.forEach((item) {
          postMap[item.id ?? 0] = item;
        });
        artistList = postMap.values.toList();
        setLoadMore(false);
        printLog(
            "getRentContentList length :=2=> ${(trandingArtistModel.result?.length ?? 0)}");
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
    trandingArtistModel = artist.ArtistModel();
    artistList = [];
    artistList?.clear();
    loaded = false;
    loadMore = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
  }
}
