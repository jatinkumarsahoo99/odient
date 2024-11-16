import 'package:dtcameo/chatmodel/model/packagemodel.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class SubscriptionProvider extends ChangeNotifier {
  PackageModel packageModel = PackageModel();
  bool loaded = false;

  setLoding(bool isLoding) {
    loaded = isLoding;

    notifyListeners();
  }

  Future<void> getPackages() async {
    loaded = true;
    packageModel = await ApiService().packgeResponse();
    printLog("get_package status :==> ${packageModel.status}");
    printLog("get_package message :==> ${packageModel.message}");
    loaded = false;
    notifyListeners();
  }

  clearProvider() {
    printLog("================ Clear Provider ===============");
    packageModel = PackageModel();
    loaded = false;
  }
}
