import 'package:dtcameo/chatmodel/model/notificationmodel.dart';
import 'package:dtcameo/chatmodel/model/successmodel.dart';
import 'package:dtcameo/chatmodel/model/usermodel.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationModel notificationModel = NotificationModel();
  SuccessModel successModel = SuccessModel();
  UserModel profileModel = UserModel();

  bool loaded = false;

  setLoding(bool isLoding) {
    loaded = isLoding;

    notifyListeners();
  }

  Future<void> getNotification(String userid) async {
    loaded = true;
    notificationModel = await ApiService().getNotificationResponse(userid);
    loaded = false;

    notifyListeners();
  }

  Future<void> readNotification(String userid, String notificationid) async {
    successModel = await ApiService().readNotification(userid, notificationid);
    notifyListeners();
  }

  Future<void> getProfile(String id) async {
    loaded = true;
    profileModel = await ApiService().getProfileResponse(id);
    loaded = false;

    notifyListeners();
  }

  clearProvider() {
    printLog("================ Clear Provider ===============");
    profileModel = UserModel();
    notificationModel = NotificationModel();
    successModel = SuccessModel();
    loaded = false;
  }
}
