import 'package:dtcameo/chatmodel/model/artistvideorequestmodel.dart'
    as request;
import 'package:dtcameo/chatmodel/model/questionrequestmodel.dart';
import 'package:dtcameo/chatmodel/model/successmodel.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class RequestProvider extends ChangeNotifier {
  request.ArtistVideoRequestModel artistVideoRequestModel =
      request.ArtistVideoRequestModel();
  QuestionRequestModel questionRequestModel = QuestionRequestModel();
  SuccessModel uploadVideoModel = SuccessModel();

  bool loaded = false;
  List<request.Result>? requestLsit = [];

  /* Pagenation */
  bool loadMore = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;
/* type wise data show */
  String layoutType = Constant.draftType;

  setLoding(bool isLoding) {
    loaded = isLoding;
    notifyListeners();
  }

  Future<void> getAristVideoReuest(
      String userId, String status, int pageNo) async {
    loaded = true;
    artistVideoRequestModel =
        await ApiService().artistVideoRequestResponse(userId, status, pageNo);
    if (artistVideoRequestModel.status == 200) {
      setPagination(
          artistVideoRequestModel.totalRows,
          artistVideoRequestModel.totalPage,
          artistVideoRequestModel.currentPage,
          artistVideoRequestModel.morePage);
      if (artistVideoRequestModel.result != null &&
          (artistVideoRequestModel.result?.length ?? 0) > 0) {
        printLog(
            "artistVideoRequestModel length :=1=> ${(artistVideoRequestModel.result?.length ?? 0)}");
        for (var i = 0;
            i < (artistVideoRequestModel.result?.length ?? 0);
            i++) {
          requestLsit
              ?.add(artistVideoRequestModel.result?[i] ?? request.Result());
        }
        final Map<int, request.Result> postMap = {};
        requestLsit?.forEach((item) {
          postMap[item.id ?? 0] = item;
        });
        requestLsit = postMap.values.toList();
        setLoadMore(false);
        printLog(
            "getRentContentList length :=2=> ${(artistVideoRequestModel.result?.length ?? 0)}");
      }
    }
    loaded = false;
    notifyListeners();
  }

/* layout wise data show */
  setLayoutType(type) {
    layoutType = type;
    printLog("Your screen lauout type : $layoutType");
    notifyListeners();
  }

  Future<void> getQuestionData(String requestId) async {
    loaded = true;
    questionRequestModel =
        await ApiService().getVideoRequestResponse(requestId);
    loaded = false;
    notifyListeners();
  }

/* video status pass  */
  Future<void> uploadVideoStatus(
    String requestId,
    String status,
  ) async {
    loaded = true;
    uploadVideoModel =
        await ApiService().uploadVideoStatusResponse(requestId, status);
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

  clearContent() {
    printLog("================ Clear Content ==============");
    artistVideoRequestModel = request.ArtistVideoRequestModel();
    requestLsit = [];
    requestLsit?.clear();
    /* Pagination */
    loadMore = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
  }

  clearProvider() {
    printLog("============== Clear Provider ================");
    artistVideoRequestModel = request.ArtistVideoRequestModel();
    questionRequestModel = QuestionRequestModel();
    uploadVideoModel = SuccessModel();
    loaded = false;
    requestLsit = [];
    requestLsit?.clear();
    /* Pagination */
    loadMore = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
    layoutType = Constant.draftType;
  }
}
