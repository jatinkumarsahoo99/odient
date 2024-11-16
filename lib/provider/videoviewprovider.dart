import 'package:dtcameo/chatmodel/model/successmodel.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoViewProvider extends ChangeNotifier {
  SuccessModel successModel = SuccessModel();

  VisibilityInfo? visibleInfo;
  bool loading = false;

  Future<void> addShortView(videoId) async {
    printLog("addPostView postId :==> $videoId");
    printLog("addPostView userid :==> ${Constant.userId}");

    loading = true;
    successModel = await ApiService().addViewResponse(videoId);
    printLog("addPostView status :==> ${successModel.status}");
    printLog("addPostView message :==> ${successModel.message}");
    loading = false;
  }

  setVisibilityInfo(VisibilityInfo? visibleInfo) {
    this.visibleInfo = visibleInfo;
    notifyListeners();
  }

  clearProvider() {
    successModel = SuccessModel();
    visibleInfo = null;
    loading = false;
  }
}
