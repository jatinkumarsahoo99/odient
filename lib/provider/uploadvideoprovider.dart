import 'dart:io';
import 'package:dtcameo/chatmodel/model/uploadvideomodel.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class UploadVideoProvider extends ChangeNotifier {
  UploadVideoModel uploadVideoModel = UploadVideoModel();
  bool loading = false;

  Future<void> getUplod(String userId, String requestId, File videoUrl,
      String titile, File image, String tages) async {
    loading = true;
    uploadVideoModel = await ApiService()
        .uploadVideoResponse(userId, requestId, videoUrl, titile, image, tages);
    loading = false;

    notifyListeners();
  }

  clearProvider() {
    uploadVideoModel = UploadVideoModel();
    loading = false;
  }
}
