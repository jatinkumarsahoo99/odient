import 'package:dtcameo/chatmodel/model/subscriptionmodel.dart';
import 'package:dtcameo/chatmodel/model/usertranscationmodel.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class HistroyProvider extends ChangeNotifier {
  SubscriptionModel subscriptionModel = SubscriptionModel();
  UserTranscationModel userTranscationModel = UserTranscationModel();

  bool subscripLoding = false;

  setLoding(isLoding) {
    subscripLoding = isLoding;
    notifyListeners();
  }

  Future<void> getSubscription(String userid) async {
    subscripLoding = true;
    subscriptionModel = await ApiService().subscriptionListResponse(userid);
    subscripLoding = false;

    notifyListeners();
  }

  Future<void> getUserTransaction(String userid) async {
    subscripLoding = true;
    userTranscationModel = await ApiService().userTransacationResponse(userid);
    subscripLoding = false;

    notifyListeners();
  }

  clearProvider() {
    printLog("================== Clear Provider ==============");
    subscriptionModel = SubscriptionModel();
    userTranscationModel = UserTranscationModel();
    subscripLoding = false;
  }
}
