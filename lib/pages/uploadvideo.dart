import 'dart:io';
import 'package:dtcameo/provider/uploadvideoprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class UploadVideo extends StatefulWidget {
  final String requestId;
  const UploadVideo({super.key, required this.requestId});

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagesController = TextEditingController();
  VideoPlayerController? _controller;
  File? videoFile;
  ImagePicker videoPicker = ImagePicker();
  File? imageFile;
  late UploadVideoProvider uploadVideoProvider;

  @override
  void initState() {
    uploadVideoProvider =
        Provider.of<UploadVideoProvider>(context, listen: false);
    super.initState();
  }

  getImagePicked() async {
    XFile? imagePath = await videoPicker.pickImage(source: ImageSource.gallery);
    if (imagePath != null) {
      setState(() {
        imageFile = File(imagePath.path);
      });
    }
  }

  getVideoPicked() async {
    XFile? videoPath = await videoPicker.pickVideo(source: ImageSource.gallery);
    if (videoPath != null) {
      videoFile = File(videoPath.path);
      _controller = VideoPlayerController.file(File(videoPath.path))
        ..initialize().then((_) {
          setState(() {});
          _controller!.pause();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: colorPrimary,
        appBar: AppBar(
          backgroundColor: colorPrimary,
          iconTheme: const IconThemeData(color: white),
          centerTitle: false,
          title: MyText(
            text: "videorequestlist",
            color: white,
            multilanguage: true,
            fontsize: Dimens.textBig,
            fontwaight: FontWeight.w600,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: [
              _buildData(),
              const SizedBox(height: 30),
              _buildButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: 'video_url',
          multilanguage: true,
          fontsize: Dimens.textBig,
          color: white,
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                color: transparent,
                border: Border.all(
                    width: 2, color: white, style: BorderStyle.solid)),
            child: InkWell(
              onTap: () {
                getVideoPicked();
              },
              child: videoFile != null
                  ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: VideoPlayer(_controller!),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.play_arrow,
                          size: 25,
                          color: white,
                        ),
                        const SizedBox(height: 5),
                        MyText(
                          text: 'selectthevideo',
                          multilanguage: true,
                          fontsize: Dimens.textTitle,
                          color: white,
                        ),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        MyText(
          text: 'videotitle',
          multilanguage: true,
          fontsize: Dimens.textBig,
          color: white,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _titleController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          style: Utils.googleFontStyle(
              3, 15, FontStyle.normal, white, FontWeight.w500),
          decoration: InputDecoration(
              hintText: "Enter the title",
              hintStyle: Utils.googleFontStyle(
                  3, 15, FontStyle.normal, grey, FontWeight.w500),
              contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              fillColor: colorPrimaryDark,
              filled: true,
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(34),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(34),
                  borderSide: BorderSide.none),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(34),
                  borderSide: BorderSide.none)),
        ),
        const SizedBox(height: 20),
        MyText(
          text: 'image',
          multilanguage: true,
          fontsize: Dimens.textBig,
          color: white,
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                color: transparent,
                border: Border.all(
                    width: 2, color: white, style: BorderStyle.solid)),
            child: InkWell(
              onTap: () {
                getImagePicked();
              },
              child: imageFile != null
                  ? Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(imageFile!), fit: BoxFit.fill),
                          border: Border.all(
                              width: 2,
                              color: white,
                              style: BorderStyle.solid)),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.play_arrow,
                          size: 25,
                          color: white,
                        ),
                        const SizedBox(height: 5),
                        MyText(
                          text: 'selecttheimage',
                          multilanguage: true,
                          fontsize: Dimens.textTitle,
                          color: white,
                        ),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        MyText(
          text: 'tages',
          multilanguage: true,
          fontsize: Dimens.textBig,
          color: white,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _tagesController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          style: Utils.googleFontStyle(
              3, 15, FontStyle.normal, white, FontWeight.w500),
          decoration: InputDecoration(
              hintText: "Enter the Tages",
              hintStyle: Utils.googleFontStyle(
                  3, 15, FontStyle.normal, grey, FontWeight.w500),
              contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              fillColor: colorPrimaryDark,
              filled: true,
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(34),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(34),
                  borderSide: BorderSide.none),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(34),
                  borderSide: BorderSide.none)),
        ),
      ],
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
      onPressed: () {
        if (videoFile == null) {
          Utils().showToast("Video is Required");
        } else if (_titleController.text.isEmpty) {
          Utils().showToast("Title is Required...");
        } else {
          uploadApi(
              Constant.userId ?? "",
              widget.requestId,
              videoFile!,
              _titleController.text.toString(),
              imageFile!,
              _tagesController.text.toString());
        }
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: colorAccent,
          minimumSize: Size(MediaQuery.of(context).size.width, 41)),
      child: MyText(
        text: 'continue',
        multilanguage: true,
        fontsize: Dimens.textBig,
        color: white,
      ),
    );
  }

  uploadApi(String userId, String requestId, File videoUrl, String titile,
      File image, String tages) async {
    Utils().showProgress(context);
    try {
      await uploadVideoProvider.getUplod(
          userId, requestId, videoUrl, titile, image, tages);
      if (uploadVideoProvider.uploadVideoModel.status == 200) {
        printLog(uploadVideoProvider.uploadVideoModel.success ?? "");
        Utils()
            .showToast(uploadVideoProvider.uploadVideoModel.success.toString());
        if (!mounted) return;
        Utils.hideProgress();
        Navigator.of(context).pop();
      } else {
        if (!mounted) return;
        Utils.hideProgress();
        Utils()
            .showToast(uploadVideoProvider.uploadVideoModel.success.toString());
      }
    } catch (e) {
      if (!mounted) return;
      Utils.hideProgress();
      printLog("Error ${e.toString()}");
      Utils()
          .showToast(uploadVideoProvider.uploadVideoModel.success.toString());
    }
  }
}
