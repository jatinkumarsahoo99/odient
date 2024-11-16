import 'package:dtcameo/chatmodel/model/professionmodel.dart';
import 'package:dtcameo/chatmodel/model/questionmoel.dart';
import 'package:dtcameo/chatmodel/model/successmodel.dart';
import 'package:dtcameo/chatmodel/model/usermodel.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class VideoRequestProvider extends ChangeNotifier {
  SuccessModel successModel = SuccessModel();
  ProfessionModel categoryModel = ProfessionModel();
  QuestionModel questionModel = QuestionModel();
  UserModel profileModel = UserModel();

  /* Loading  */
  bool loaded = false;
  bool questionLoding = false;
  bool profileLoding = false;
  bool requestLoading = false;

  setLoding(isLoding) {
    loaded = isLoding;
    questionLoding = isLoding;
    profileLoding = isLoding;
    requestLoading = isLoding;
    notifyListeners();
  }

  Future<void> getCategory() async {
    loaded = true;
    categoryModel = await ApiService().categoryResponse();
    loaded = false;
    notifyListeners();
  }

  Future<void> getQuestion(String categoryId) async {
    questionLoding = true;
    questionModel = await ApiService().questionResponse(categoryId);
    questionLoding = false;

    notifyListeners();
  }

  Future<void> getProfile(String id) async {
    profileLoding = true;
    profileModel = await ApiService().getProfileResponse(id);
    profileLoding = false;
    notifyListeners();
  }

  Future<void> getVideoRequest(String videoFor, String fullName,
      String toUserId, String categoryId, String fees, answers) async {
    requestLoading = true;
    successModel = await ApiService().videoRequestResponse(
        videoFor, fullName, toUserId, categoryId, fees, answers);
    requestLoading = false;

    notifyListeners();
  }

  clearProvider() {
    successModel = SuccessModel();
    categoryModel = ProfessionModel();
    questionModel = QuestionModel();
    profileModel = UserModel();
    loaded = false;
    questionLoding = false;
    requestLoading = false;
    profileLoding = false;
  }
}
