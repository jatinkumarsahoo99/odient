import 'dart:math' as number;

import 'package:dtcameo/utils/adhlper.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/shareperf.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

printLog(String message) {
  if (kDebugMode) {
    return print(message);
  }
}

class Utils {
  // Global FontFamily All app Text
  static TextStyle googleFontStyle(int inter, double fontsize,
      FontStyle fontstyle, Color color, FontWeight fontwaight) {
    if (inter == 1) {
      return GoogleFonts.bodoniModa(
          fontSize: fontsize,
          fontStyle: fontstyle,
          color: color,
          fontWeight: fontwaight);
    } else if (inter == 2) {
      return GoogleFonts.lato(
          fontSize: fontsize,
          fontStyle: fontstyle,
          color: color,
          fontWeight: fontwaight);
    } else if (inter == 3) {
      return GoogleFonts.rubik(
          fontSize: fontsize,
          fontStyle: fontstyle,
          color: color,
          fontWeight: fontwaight);
    } else {
      return GoogleFonts.inter(
          fontSize: fontsize,
          fontStyle: fontstyle,
          color: color,
          fontWeight: fontwaight);
    }
  }

  /* Back Button in Ios and android */
  static backButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(
        Icons.arrow_back_ios_new,
        size: 20,
        color: white,
      ),
    );
  }

  /* End */
/* Number show 10k or 10M */

/* End */
// Time change code UTC forment to normal forment
  static timeDuaration(int inputTime) {
    int input = inputTime;
    if (input == 0) {
      return "";
    }

    int seconds = input ~/ 1000; // convert milliseconds to seconds
    int hours = seconds ~/ 3600;
    seconds %= 3600;
    int minutes = seconds ~/ 60;
    seconds %= 60;

    String output =
        "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    return output;
  }

// Date chage code UTC forment to normal forment
  static dateTimeShow(String inputDate) {
    String input = inputDate;
    if (input.isEmpty) {
      return "";
    }
    try {
      DateTime dateTime = DateTime.parse(input);
      String output = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
      return output;
    } catch (e) {
      printLog("Error....${e.toString()}");
    }
  }

// Time chage code UTC forment to normal forment
  static timeShow(String inputDate) {
    String input = inputDate;
    if (input.isEmpty) {
      return "";
    }
    try {
      DateTime dateTime = DateTime.parse(input);
      String output = "${dateTime.hour}:${dateTime.second}";
      return output;
    } catch (e) {
      printLog("Error....${e.toString()}");
    }
  }

  static String kmbGenerator(int num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }

  static setFirstTime(value) async {
    SharePre sharePref = SharePre();
    await sharePref.save("seen", value);
    String seenValue = await sharePref.read("seen");
    printLog('setFirstTime seen ==> $seenValue');
  }

  static ProgressDialog? prDialog;
// Global Progress Dilog
  void showProgress(BuildContext context) async {
    prDialog = ProgressDialog(context);
    prDialog = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false, showLogs: false);

    prDialog!.style(
      message: "Please Wait",
      borderRadius: 5,
      progressWidget: Container(
        padding: const EdgeInsets.all(8),
        child: const CircularProgressIndicator(),
      ),
      maxProgress: 100,
      progressTextStyle: TextStyle(
        color: Colors.black,
        fontSize: Dimens.textBigSmall,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: white,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
        color: colorPrimaryDark,
        fontSize: Dimens.textMedium,
        fontWeight: FontWeight.normal,
      ),
    );

    await prDialog!.show();
  }

  static void hideProgress() {
    if (prDialog != null && prDialog!.isShowing()) {
      prDialog?.hide();
      prDialog = null;
    }
  }

  static BoxDecoration setGradTTBBGWithBorder(Color colorStart, Color colorEnd,
      Color bcolorPrimary, double radius, double border) {
    return BoxDecoration(
      border: Border.all(
        color: bcolorPrimary,
        width: border,
      ),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[colorStart, colorEnd],
      ),
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  // Global  Toast Message
  showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: colorAccent,
        textColor: white,
        fontSize: Dimens.textMedium);
  }

// Widget Page Loader
  static Widget pageLoader() {
    return const Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: white,
      ),
    );
  }

// Global SnakBar
  static void showSnackbar(BuildContext context, String showFor, String message,
      bool multilanguage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: showFor == "fail"
            ? red
            : showFor == "info"
                ? colorAccent
                : showFor == "success"
                    ? primaryGradient
                    : red,
        content: MyText(
          text: message,
          fontsize: Dimens.textMedium,
          multilanguage: multilanguage,
          fontstyle: FontStyle.normal,
          fontwaight: FontWeight.w500,
          color: white,
          textalign: TextAlign.center,
        ),
      ),
    );
  }

  static saveUser(
      {required userId,
      required userName,
      required userEmail,
      required userMobilenumber,
      required userImage,
      required userType,
      required dob,
      required bio,
      required isArtist,
      required isBuy,
      required countryCode,
      required countryName}) async {
    SharePre sharePre = SharePre();
    if (userId != null) {
      await sharePre.save('userid', userId);
      await sharePre.save('username', userName);
      await sharePre.save('useremail', userEmail);
      await sharePre.save('mobilenumber', userMobilenumber);
      await sharePre.save('image', userImage);
      await sharePre.save('usertype', userType);
      await sharePre.save('dob', dob);
      await sharePre.save('bio', bio);
      await sharePre.save('isartist', isArtist);
      await sharePre.save('isbuy', isBuy);
      await sharePre.save('countrycode', countryCode);
      await sharePre.save('countryname', countryName);
    } else {
      await sharePre.remove('userid');
      await sharePre.remove('username');
      await sharePre.remove('useremail');
      await sharePre.remove('mobilenumber');
      await sharePre.remove('image');
      await sharePre.remove('usertype');
      await sharePre.remove('dob');
      await sharePre.remove('bio');
      await sharePre.remove('isartist');
      await sharePre.remove('isbuy');
      await sharePre.remove('countrycode');
      await sharePre.remove('countryname');
    }
  }

  /* ***************** generate Unique OrderID START ***************** */
  static String generateRandomOrderID() {
    int getRandomNumber;
    String? finalOID;
    printLog("fixFourDigit =>>> ${Constant.fixFourDigit}");
    printLog("fixSixDigit =>>> ${Constant.fixSixDigit}");

    number.Random r = number.Random();
    int ran5thDigit = r.nextInt(9);
    printLog("Random ran5thDigit =>>> $ran5thDigit");

    int randomNumber = number.Random().nextInt(9999999);
    printLog("Random randomNumber =>>> $randomNumber");
    if (randomNumber < 0) {
      randomNumber = -randomNumber;
    }
    getRandomNumber = randomNumber;
    printLog("getRandomNumber =>>> $getRandomNumber");

    finalOID = "${Constant.fixFourDigit.toInt()}"
        "$ran5thDigit"
        "${Constant.fixSixDigit.toInt()}"
        "$getRandomNumber";
    printLog("finalOID =>>> $finalOID");

    return finalOID;
  }
  /* ***************** generate Unique OrderID END ***************** */

  static void getCurrencySymbol() async {
    SharePre sharedPref = SharePre();
    Constant.currencySymbol = await sharedPref.read("currency_code") ?? "";
    printLog('Constant currencySymbol ==> ${Constant.currencySymbol}');
    Constant.currency = await sharedPref.read("currency") ?? "";
    printLog('Constant currency ==> ${Constant.currency}');
  }

  static void updatePremium(String isPremiumBuy) async {
    printLog('updatePremium isPremiumBuy ==> $isPremiumBuy');
    SharePre sharedPre = SharePre();
    await sharedPre.save("isbuy", isPremiumBuy);
    String? isPremium = await sharedPre.read("isbuy");
    Constant.userBuy = await sharedPre.read("isbuy");
    printLog('updatePremium ===============> $isPremium');
  }

  /* Google AdMob Methods End */
  static Future<bool> checkPremiumUser() async {
    SharePre sharedPre = SharePre();
    String? isPremiumBuy = await sharedPre.read("isbuy");
    Constant.userBuy = await sharedPre.read("isbuy");
    printLog('checkPremiumUser isPremiumBuy ==> $isPremiumBuy');
    if (isPremiumBuy != null && isPremiumBuy == "1") {
      return true;
    } else {
      return false;
    }
  }

  static loadAds(BuildContext context) async {
    bool? isPremiumBuy = await Utils.checkPremiumUser();
    printLog("loadAds isPremiumBuy :==> $isPremiumBuy");
    if (context.mounted) {
      AdHelper.getAds(context);
    }
    if (!kIsWeb && !isPremiumBuy) {
      AdHelper.createInterstitialAd();
      AdHelper.createRewardedAd();
    }
  }

  /* Google admob  */
  static Widget showBannerAd(BuildContext context) {
    if (!kIsWeb) {
      return Container(
        constraints: BoxConstraints(
          minHeight: 0,
          minWidth: 0,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: AdHelper.bannerAd(context),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
