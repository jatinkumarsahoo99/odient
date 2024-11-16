import 'package:dtcameo/chatmodel/model/pagemodel.dart';
import 'package:dtcameo/chatmodel/model/usermodel.dart';
import 'package:dtcameo/chatmodel/model/videomodel.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class Profileprovider extends ChangeNotifier {
  UserModel profileModel = UserModel();
  VideoModel videoModel = VideoModel();
  VideoModel privateVideoModel = VideoModel();
  PageModel pageModel = PageModel();
  bool pageLoding = false;
  bool profileLoding = false;
  bool videoPrivate = false;
  bool videoLoding = false;

  setLoding(bool isLoding) {
    profileLoding = isLoding;
    videoLoding = isLoding;
    videoPrivate = isLoding;
    pageLoding = isLoding;

    notifyListeners();
  }

  Future<void> getProfile(BuildContext context, String id) async {
    profileLoding = true;
    profileModel = await ApiService().getProfileResponse(id);
    printLog("get_profile status :==> ${profileModel.status}");
    printLog("get_profile message :==> ${profileModel.message}");
    if (profileModel.status == 200 && profileModel.result != null) {
      if ((profileModel.result?.length ?? 0) > 0) {
        Utils.updatePremium(profileModel.result?[0].isBuy.toString() ?? "0");
        if (context.mounted) {
          printLog("========= get_profile loadAds =========");
          Utils.loadAds(context);
        }
      }
    }
    profileLoding = false;
    notifyListeners();
  }

  Future<void> getVideo(String userid) async {
    videoLoding = true;
    videoModel = await ApiService().getVideoArtist(userid);
    videoLoding = false;

    notifyListeners();
  }

  Future<void> getPage() async {
    pageLoding = true;
    pageModel = await ApiService().getPageResponse();
    pageLoding = false;

    notifyListeners();
  }

  Future<void> getPrivateVideo(String userid) async {
    videoPrivate = true;
    privateVideoModel = await ApiService().getVideoPrivateArtist(userid);

    videoPrivate = false;
    notifyListeners();
  }

  clearProvider() {
    printLog("================ Clear Provider ===============");
    profileModel = UserModel();
    videoModel = VideoModel();
    privateVideoModel = VideoModel();
    pageModel = PageModel();
    pageLoding = false;
    profileLoding = false;
    videoLoding = false;
    videoPrivate = false;
  }
}
