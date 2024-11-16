
import 'package:dtcameo/chatmodel/model/alloredersmodel.dart' as order;
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  order.AllOredersModel allOredersModel = order.AllOredersModel();
  List<order.Result>? orderList = [];
  bool orederLoding = false;

  /* Pagenation  */
  bool loadMore = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;

  setLoding(bool isLoding) {
    orederLoding = isLoding;

    notifyListeners();
  }

  Future<void> getUserVideoList(int pageNo) async {
    orederLoding = true;
    allOredersModel = await ApiService().userVideoRequestListResponse(pageNo);

    if (allOredersModel.status == 200) {
      setPageNation(allOredersModel.totalRows, allOredersModel.totalPage,
          allOredersModel.currentPage, allOredersModel.morePage);

      if (allOredersModel.result != null &&
          (allOredersModel.result?.length ?? 0) > 0) {
        for (var i = 0; i < (allOredersModel.result?.length ?? 0); i++) {
          orderList?.add(allOredersModel.result?[i] ?? order.Result());
        }
        final Map<int, order.Result> postMap = {};
        orderList?.forEach((item) {
          postMap[item.id ?? 0] = item;
        });
        orderList = postMap.values.toList();
        setLodMore(false);
      }
    }

    orederLoding = false;
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

  clearProvider() {
    printLog("==================== Clear Proivider ===============");
    allOredersModel = order.AllOredersModel();
    orderList = [];
    orderList?.clear();
    orederLoding = false;

    /* Pagination */
    loadMore = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
  }
}
