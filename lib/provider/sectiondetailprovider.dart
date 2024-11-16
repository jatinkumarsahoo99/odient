import 'package:dtcameo/chatmodel/model/professionmodel.dart' as category;
import 'package:dtcameo/chatmodel/model/videomodel.dart' as video;
import 'package:dtcameo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:dtcameo/chatmodel/model/secationdetailsmodel.dart'
    as sectiondetails;

class SectionDetailsProvider extends ChangeNotifier {
  sectiondetails.SectionDetailsModel sectionDetailModel =
      sectiondetails.SectionDetailsModel();
  category.ProfessionModel categoryModel = category.ProfessionModel();
  video.VideoModel videoModel = video.VideoModel();
  bool loaded = false;
  List<sectiondetails.Result>? secationDetailList = [];
  List<category.Result>? categoryList = [];
  List<video.Result>? videoList = [];

/* Post Pagination */
  bool loadMore = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;

  setLoading(isLoading) {
    loaded = isLoading;
    notifyListeners();
  }

  Future<void> getSectionDetails(
      String type, String sectionid, int pageno) async {
    loaded = true;
    sectionDetailModel =
        await ApiService().sectionDetailsResponse(type, sectionid, pageno);
    if (sectionDetailModel.status == 200) {
      setPagination(sectionDetailModel.totalRows, sectionDetailModel.totalPage,
          sectionDetailModel.currentPage, sectionDetailModel.morePage);
      if (sectionDetailModel.result != null &&
          (sectionDetailModel.result?.length ?? 0) > 0) {
        for (var i = 0; i < (sectionDetailModel.result?.length ?? 0); i++) {
          secationDetailList
              ?.add(sectionDetailModel.result?[i] ?? sectiondetails.Result());
        }
        final Map<int, sectiondetails.Result> postMap = {};
        secationDetailList?.forEach((item) {
          postMap[item.id ?? 0] = item;
        });
        secationDetailList = postMap.values.toList();
        setLoadMore(false);
        printLog(
            "sectionDetailModel length :=2=> ${(sectionDetailModel.result?.length ?? 0)}");
      }
      printLog("getSectionDetails status :===> ${sectionDetailModel.status}");
      printLog("getSectionDetails message :==> ${sectionDetailModel.message}");
    }
    loaded = false;
    notifyListeners();
  }

  Future<void> getSectionVideo(
      String type, String sectionid, int pageno) async {
    loaded = true;
    videoModel =
        await ApiService().sectionDetailsResponse(type, sectionid, pageno);
    if (videoModel.status == 200) {
      setPagination(videoModel.totalRows, videoModel.totalPage,
          videoModel.currentPage, videoModel.morePage);
      if (videoModel.result != null && (videoModel.result?.length ?? 0) > 0) {
        for (var i = 0; i < (videoModel.result?.length ?? 0); i++) {
          videoList?.add(videoModel.result?[i] ?? video.Result());
        }
        final Map<int, video.Result> postMap = {};
        videoList?.forEach((item) {
          postMap[item.id ?? 0] = item;
        });
        videoList = postMap.values.toList();
        setLoadMore(false);
        printLog("videoModel length :=2=> ${(videoModel.result?.length ?? 0)}");
      }
      printLog("getSectionDetails status :===> ${videoModel.status}");
      printLog("getSectionDetails message :==> ${videoModel.message}");
    }
    loaded = false;
    notifyListeners();
  }

  Future<void> getSectionDetailsCategory(
      String type, String sectionid, int pageno) async {
    loaded = true;
    categoryModel =
        await ApiService().sectionDetailsResponse(type, sectionid, pageno);
    if (categoryModel.status == 200) {
      setPagination(categoryModel.totalRows, categoryModel.totalPage,
          categoryModel.currentPage, categoryModel.morePage);
      if (categoryModel.result != null &&
          (categoryModel.result?.length ?? 0) > 0) {
        for (var i = 0; i < (categoryModel.result?.length ?? 0); i++) {
          categoryList?.add(categoryModel.result?[i] ?? category.Result());
        }
        final Map<int, category.Result> postMap = {};
        categoryList?.forEach((item) {
          postMap[item.id ?? 0] = item;
        });
        categoryList = postMap.values.toList();
        setLoadMore(false);
        printLog(
            "categoryModel length :=2=> ${(categoryModel.result?.length ?? 0)}");
      }
      printLog("getSectionDetails status :===> ${categoryModel.status}");
      printLog("getSectionDetails message :==> ${categoryModel.message}");
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
    printLog("================= Clear Provider ================");
    sectionDetailModel = sectiondetails.SectionDetailsModel();
    categoryModel = category.ProfessionModel();
    videoModel = video.VideoModel();
    loaded = false;
    secationDetailList = [];
    secationDetailList?.clear();
    categoryList = [];
    categoryList?.clear();
    videoList = [];
    videoList?.clear();
    /* Pagination */
    loadMore = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
  }
}
