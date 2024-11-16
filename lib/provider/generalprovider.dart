import 'package:dtcameo/chatmodel/model/generalmodel.dart';
import 'package:dtcameo/chatmodel/model/successmodel.dart';
import 'package:dtcameo/chatmodel/model/usermodel.dart';
import 'package:dtcameo/utils/adhlper.dart';
import 'package:dtcameo/utils/shareperf.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GeneralProvider extends ChangeNotifier {
  GeneralModel generalModel = GeneralModel();
  UserModel userModel = UserModel();
  UserModel socialModel = UserModel();
  UserModel otpModel = UserModel();
  SuccessModel forgetPasswordModel = SuccessModel();

  bool loaded = false;

  Future<void> getGenralSetting(BuildContext context) async {
    loaded = true;
    generalModel = await ApiService().genralResponse();
    if (generalModel.status == 200 && (generalModel.result?.length ?? 0) > 0) {
      for (var i = 0; i < (generalModel.result?.length ?? 0); i++) {
        SharePre().save(
          generalModel.result?[i].key.toString() ?? "",
          generalModel.result?[i].value.toString() ?? "",
        );
      }
      /* Get Ads Init */
      if (context.mounted && !kIsWeb) {
        AdHelper.getAds(context);
      }
    }
    loaded = false;

    notifyListeners();
  }

  Future<void> getRegister(
    String type,
    String firebaseId,
    String fullname,
    String mobilenumber,
    String email,
    String password,
    String dob,
    String countryCode,
    String countryName,
    String devicetype,
    String devicetoken,
  ) async {
    loaded = true;
    userModel = await ApiService().registerResponse(
        type,
        firebaseId,
        fullname,
        mobilenumber,
        email,
        password,
        dob,
        countryCode,
        countryName,
        devicetype,
        devicetoken);
    loaded = false;

    notifyListeners();
  }

  Future<void> getLogin(
    String type,
    String firebaseId,
    String email,
    String password,
    String devicetype,
    String devicetoken,
  ) async {
    loaded = true;
    userModel = await ApiService().loginResponse(
        type, firebaseId, email, password, devicetype, devicetoken);
    loaded = false;

    notifyListeners();
  }

  Future<void> getOtp(
    String type,
    String firebaseId,
    String mobileNumber,
    String countryCode,
    String countryName,
    String devicetype,
    String devicetoken,
  ) async {
    loaded = true;
    otpModel = await ApiService().otpLoginResponse(type, firebaseId,
        mobileNumber, countryCode, countryName, devicetype, devicetoken);
    loaded = false;

    notifyListeners();
  }

  Future<void> getSocial(
    String type,
    String firebaseId,
    String email,
    String devicetype,
    String devicetoken,
  ) async {
    loaded = true;
    socialModel = await ApiService()
        .socialLoginResponse(type, firebaseId, email, devicetype, devicetoken);
    loaded = false;

    notifyListeners();
  }

  Future<void> getForgetPassowrd(String email) async {
    loaded = true;
    forgetPasswordModel = await ApiService().forgetPasswordResponse(email);

    loaded = false;
    notifyListeners();
  }
}
