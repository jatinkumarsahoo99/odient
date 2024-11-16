import 'package:dtcameo/chatmodel/model/packagemodel.dart';
import 'package:dtcameo/chatmodel/model/sectionmodel.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class Homeprovider extends ChangeNotifier {
  PackageModel packageModel = PackageModel();
  SectionModel sectionModel = SectionModel();
  bool loaded = false;
  bool packageLoding = false;

  setLoding(isLoding) {
    loaded = isLoding;
    packageLoding = isLoding;

    notifyListeners();
  }

  Future<void> sectionData() async {
    loaded = true;
    sectionModel = await ApiService().sectionDataShowResponse();
    loaded = false;

    notifyListeners();
  }

  Future<void> getPackages() async {
    packageLoding = true;
    packageModel = await ApiService().packgeResponse();
    printLog("get_package status :==> ${packageModel.status}");
    printLog("get_package message :==> ${packageModel.message}");
    packageLoding = false;
    notifyListeners();
  }

  clearProvider() {
    printLog("================ Clear Provider ===============");

    packageModel = PackageModel();
    sectionModel = SectionModel();
    loaded = false;
    packageLoding = false;
  }
}
