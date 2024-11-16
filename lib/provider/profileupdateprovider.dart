import 'dart:io';

import 'package:dtcameo/chatmodel/model/usermodel.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class ProfileUpdateProvider extends ChangeNotifier {
  UserModel updateModel = UserModel();

  bool loaded = false;

  Future<void> getUpdateProfile(
    String professionId,
    String fullname,
    String email,
    String mobilenumber,
    String dob,
    String bio,
    String countryCode,
    String countryName,
    File image,
  ) async {
    loaded = true;
    updateModel = await ApiService().profileUpdateResponse(
        professionId,
        fullname,
        email,
        mobilenumber,
        dob,
        bio,
        countryCode,
        countryName,
        image);
    printLog("=================================================");
    printLog("${updateModel.status}");
    printLog("${updateModel.message}");
    printLog("=================================================");
    loaded = false;
    notifyListeners();
  }

  Future<void> getU(
    String professionId,
    String fullname,
    String email,
    String mobilenumber,
    String dob,
    String bio,
    String countryCode,
    String countryName,
    image,
  ) async {
    loaded = true;
    updateModel = await ApiService().profileUpdateResponse(
        professionId,
        fullname,
        email,
        mobilenumber,
        dob,
        bio,
        countryCode,
        countryName,
        image);
    printLog("=================================================");
    printLog("${updateModel.status}");
    printLog("${updateModel.message}");
    printLog("=================================================");

    loaded = false;

    notifyListeners();
  }
}
