import 'package:dtcameo/provider/generalprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/myimage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _emailController = TextEditingController();

  GeneralProvider generalProvider = GeneralProvider();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: colorPrimaryDark,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Utils.backButton(context),
              ),
              const SizedBox(height: 20),
              const Align(
                  alignment: Alignment.center,
                  child: MyImage(
                    width: 100,
                    height: 100,
                    imagePath: "appicon.png",
                    fit: BoxFit.fill,
                    isAppicon: true,
                  )),
              Align(
                alignment: Alignment.center,
                child: MyText(
                  text: 'appname',
                  fontFamily: "JejuHallasan",
                  color: white,
                  multilanguage: true,
                  fontsize: Dimens.textExtraBig,
                  fontwaight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                decoration: const BoxDecoration(
                    color: colorPrimary,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36))),
                child: Column(
                  children: [
                    MyText(
                        text: "forgetpassword",
                        multilanguage: true,
                        maxline: 2,
                        fontsize: Dimens.textlargeBig,
                        color: white,
                        fontwaight: FontWeight.bold),
                    const SizedBox(height: 25),
                    textFiled(),
                    const SizedBox(height: 50),
                    normalButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFiled() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      style: Utils.googleFontStyle(
          4, 14, FontStyle.normal, white, FontWeight.w600),
      decoration: InputDecoration(
          hintText: "melpeters@gmail.com",
          hintStyle: Utils.googleFontStyle(
              4, 14, FontStyle.normal, grey, FontWeight.w600),
          prefixIcon: const Icon(
            Icons.email,
            color: white,
          ),
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
    );
  }

  Widget normalButton() {
    return ElevatedButton(
      onPressed: () {
        if (_emailController.text.toString().isEmpty) {
          Utils().showToast("Email is required");
        } else {
          getApi(_emailController.text.toString());
        }
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: colorAccent,
          minimumSize: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * .05)),
      child: MyText(
        text: "send_email",
        maxline: 1,
        multilanguage: true,
        fontstyle: FontStyle.normal,
        fontwaight: FontWeight.w600,
        fontsize: Dimens.textBig,
        color: white,
      ),
    );
  }

  Future getApi(String email) async {
    Utils().showProgress(context);

    try {
      await generalProvider.getForgetPassowrd(email);
      if (generalProvider.forgetPasswordModel.status == 200) {
        Utils().showToast(generalProvider.forgetPasswordModel.message ?? "");
        if (!mounted) return;
        Utils.hideProgress();
        Navigator.of(context).pop();
      } else {
        if (!mounted) return;
        Utils.hideProgress();
        Utils().showToast(generalProvider.forgetPasswordModel.message ?? "");
      }
    } catch (e) {
      if (!mounted) return;
      Utils.hideProgress();
      Utils().showToast(generalProvider.forgetPasswordModel.message ?? "");
      printLog(e.toString());
    }
  }
}
