import 'package:dtcameo/chatmodel/model/professionmodel.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:dtcameo/chatmodel/model/usermodel.dart';

class ArtistProvider extends ChangeNotifier {
  ProfessionModel professionModel = ProfessionModel();
  UserModel userModel = UserModel();
  UserModel socialModel = UserModel();
  UserModel otpModel = UserModel();
  bool loaded = false;

  Future<void> getProfession() async {
    loaded = true;
    professionModel = await ApiService().getProfessionResponse();
    loaded = false;
    notifyListeners();
  }

  Future<void> getRegister(
    String type,
    String firebaseId,
    String fullname,
    String professionId,
    String mobilenumber,
    String countryCode,
    String countryName,
    String email,
    String password,
    String dob,
    String fees,
    String devicetype,
    String devicetoken,
  ) async {
    loaded = true;
    userModel = await ApiService().artistRegisterResponse(
        type,
        firebaseId,
        fullname,
        professionId,
        mobilenumber,
        countryCode,
        countryName,
        email,
        password,
        dob,
        fees,
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
    userModel = await ApiService().artistLoginResponse(
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
    otpModel = await ApiService().artistOtpLoginResponse(type, firebaseId,
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
    socialModel = await ApiService().artistSocialLoginResponse(
        type, firebaseId, email, devicetype, devicetoken);
    loaded = false;

    notifyListeners();
  }

  clearProvider() {
    printLog("================ Clear Provider ==============");
    professionModel = ProfessionModel();
    loaded = false;
  }
}
