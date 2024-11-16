import 'dart:io';

import 'package:dtcameo/pages/artistregisterpage.dart';
import 'package:dtcameo/pages/bottombar.dart';
import 'package:dtcameo/pages/editprofile.dart';
import 'package:dtcameo/provider/artistprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/shareperf.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/myimage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class ArtistOtpPage extends StatefulWidget {
  final String? mobileNumber, countryCode, countryName;
  const ArtistOtpPage(
      {super.key,
      required this.mobileNumber,
      required this.countryCode,
      required this.countryName});

  @override
  State<ArtistOtpPage> createState() => _ArtistOtpPageState();
}

class _ArtistOtpPageState extends State<ArtistOtpPage> {
  final pinPutController = TextEditingController();
  String? seen,
      email,
      userName,
      devicetype,
      deviceToken,
      strType,
      firebaseId,
      verificationId;
  final numberController = TextEditingController();
  late ProgressDialog prDialog;
  int? forceResendingToken;
  bool codeResended = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    printLog("Your Country code is :${widget.countryCode}");
    printLog("Your Country name is :${widget.countryName}");
    super.initState();
    prDialog = ProgressDialog(context);
    _getDeviceToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      codeSend(false);
    });
  }

  _getDeviceToken() async {
    if (Platform.isAndroid) {
      deviceToken = await FirebaseMessaging.instance.getToken();
      devicetype = "1";
    } else {
      final status = OneSignal.User.pushSubscription.token;
      deviceToken = status;
      devicetype = "2";
    }
    printLog("===>strDeviceToken $deviceToken");
    printLog("===>platform ${Platform.isAndroid}");
  }

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Utils.backButton(context),
            const SizedBox(height: 20),
            const Align(
                alignment: Alignment.center,
                child: MyImage(
                  width: 76,
                  height: 76,
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
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              decoration: const BoxDecoration(
                  color: colorPrimary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  numberShow(),
                  const SizedBox(height: 40),
                  otpFiled(),
                  const SizedBox(height: 40),
                  timeShow(),
                  const SizedBox(height: 50),
                  verifyBtn(),
                  const SizedBox(height: 100),
                  account(),
                  const SizedBox(height: 25),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget account() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyText(
          text: "donthaveanaccount",
          multilanguage: true,
          fontsize: Dimens.textTitle,
          color: white,
        ),
        const SizedBox(width: 4),
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const ArtistRegisterPage(),
            ));
          },
          child: MyText(
            text: "artistregister",
            multilanguage: true,
            fontsize: Dimens.textTitle,
            color: colorAccent,
          ),
        ),
      ],
    );
  }

  Widget numberShow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyText(
          text: "entertheotp",
          fontsize: Dimens.textTitle,
          color: white,
          multilanguage: true,
          fontwaight: FontWeight.w400,
        ),
        const SizedBox(width: 5),
        MyText(
          text: widget.mobileNumber ?? "",
          fontsize: Dimens.textTitle,
          color: white,
          fontwaight: FontWeight.w700,
        ),
      ],
    );
  }

  Widget timeShow() {
    return InkWell(
      onTap: () {
        if (!codeResended) {
          codeSend(true);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyText(
            text: "resendotpin",
            fontsize: Dimens.textBigSmall,
            color: white,
            multilanguage: true,
            fontwaight: FontWeight.w500,
          ),
          const SizedBox(width: 5),
          MyText(
            text: "00:30",
            fontsize: Dimens.textBigSmall,
            color: orange,
            fontwaight: FontWeight.w700,
          ),
        ],
      ),
    );
  }

  Widget verifyBtn() {
    return ElevatedButton(
        onPressed: () async {
          printLog("Clicked sms Code =====> ${pinPutController.text}");
          if (pinPutController.text.toString().isEmpty) {
            Utils.showSnackbar(context, "info", "enterreceivedotp", true);
          } else {
            if (verificationId == null || verificationId == "") {
              Utils.showSnackbar(context, "info", "otp_not_working", true);
              return;
            }
            Utils().showProgress(context);
            _checkOTPAndLogin();
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: colorAccent,
            minimumSize: const Size(double.maxFinite, 50)),
        child: MyText(
          text: "verify",
          multilanguage: true,
          fontstyle: FontStyle.normal,
          fontsize: Dimens.textTitle,
          fontwaight: FontWeight.w700,
          color: white,
        ));
  }

  /* Enter Received OTP */
  Widget otpFiled() {
    return Pinput(
      length: 6,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      controller: pinPutController,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      defaultPinTheme: PinTheme(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(color: white, width: 1),
          shape: BoxShape.rectangle,
          color: transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        textStyle: GoogleFonts.outfit(
          color: white,
          fontSize: Dimens.textTitle,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  codeSend(bool isResend) async {
    printLog("codeSend mobileNumber ===> ${widget.mobileNumber.toString()}");
    codeResended = isResend;
    Utils().showProgress(context);
    await phoneSignIn(phoneNumber: widget.mobileNumber.toString());
    prDialog.hide();
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: "${widget.countryCode} $phoneNumber",
      forceResendingToken: forceResendingToken,
      verificationCompleted: _onVerificationCompleted,
      verificationFailed: _onVerificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _onCodeTimeout,
    );
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    printLog("verification completed ======> ${authCredential.smsCode}");
    setState(() {
      pinPutController.text = authCredential.smsCode ?? "";
    });
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    prDialog.hide();
    if (exception.code == 'invalid-phone-number') {
      printLog("The phone number entered is invalid!");
      Utils.showSnackbar(context, "fail", "invalidphonenumber", true);
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    this.forceResendingToken = forceResendingToken;
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {
        prDialog.hide();
      });
    });
    printLog("verificationId =======> $verificationId");
    printLog("resendingToken =======> ${forceResendingToken.toString()}");
    printLog("code sent");
  }

  _onCodeTimeout(String verificationId) {
    printLog("_onCodeTimeout verificationId =======> $verificationId");
    this.verificationId = verificationId;
    prDialog.hide();
    codeResended = false;
    return null;
  }

  _checkOTPAndLogin() async {
    bool error = false;
    UserCredential? userCredential;

    printLog("_checkOTPAndLogin verificationId =====> $verificationId");
    printLog("_checkOTPAndLogin smsCode =====> ${pinPutController.text}");

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential? phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId ?? "",
      smsCode: pinPutController.text.toString(),
    );

    printLog(
        "phoneAuthCredential.smsCode        =====> ${phoneAuthCredential.smsCode}");
    printLog(
        "phoneAuthCredential.verificationId =====> ${phoneAuthCredential.verificationId}");
    try {
      userCredential = await _auth.signInWithCredential(phoneAuthCredential);
      firebaseId = userCredential.user?.uid;
      await SharePre().save("firebaseid", firebaseId);
      printLog(
          "_checkOTPAndLogin userCredential =====> ${userCredential.user?.phoneNumber ?? ""}");
    } on FirebaseAuthException catch (e) {
      prDialog.hide();
      printLog("_checkOTPAndLogin error Code =====> ${e.code}");
      if (e.code == 'invalid-verification-code' ||
          e.code == 'invalid-verification-id') {
        if (!mounted) return;
        Utils.showSnackbar(context, "info", "otp_invalid", true);
        return;
      } else if (e.code == 'session-expired') {
        if (!mounted) return;
        Utils.showSnackbar(context, "fail", "otp_session_expired", true);
        return;
      } else {
        error = true;
      }
    }
    printLog(
        "Firebase Verification Complated & phoneNumber => ${userCredential?.user?.phoneNumber} and isError => $error");
    if (!error && userCredential != null) {
      _login(widget.mobileNumber.toString());
    } else {
      prDialog.hide();
      if (!mounted) return;
      Utils.showSnackbar(context, "fail", "otp_login_fail", true);
    }
  }

  _login(String mobile) async {
    printLog("click on Submit mobile => $mobile");
    var artistprovider = Provider.of<ArtistProvider>(context, listen: false);
    if (!prDialog.isShowing()) {
      Utils().showProgress(context);
    }
    await artistprovider.getOtp(
        "1",
        firebaseId ?? "",
        mobile,
        widget.countryCode ?? "",
        widget.countryName ?? "",
        devicetype ?? "",
        deviceToken ?? "");
    printLog("Login status code : ${artistprovider.otpModel.status}");
    if (!artistprovider.loaded) {
      if (artistprovider.otpModel.status == 200) {
        printLog('otpModel ==>> ${artistprovider.otpModel.toString()}');
        printLog('Login Successfull!');
        Utils.saveUser(
          userId: artistprovider.otpModel.result?[0].id.toString(),
          userName: artistprovider.otpModel.result?[0].fullName.toString(),
          userEmail: artistprovider.otpModel.result?[0].email.toString(),
          userMobilenumber:
              artistprovider.otpModel.result?[0].mobileNumber.toString(),
          userImage: artistprovider.otpModel.result?[0].image.toString(),
          dob: artistprovider.otpModel.result?[0].dateOfBirth.toString(),
          bio: artistprovider.otpModel.result?[0].bio.toString(),
          userType: artistprovider.otpModel.result?[0].type.toString(),
          isArtist: artistprovider.otpModel.result?[0].isArtist.toString(),
          isBuy: artistprovider.otpModel.result?[0].isBuy.toString(),
          countryName:
              artistprovider.otpModel.result?[0].countryName.toString(),
          countryCode:
              artistprovider.otpModel.result?[0].countryCode.toString(),
        );

        Constant.userId = artistprovider.otpModel.result?[0].id.toString();
        Constant.userBuy = artistprovider.otpModel.result?[0].isBuy.toString();

        printLog('Constant userID ==>> ${Constant.userId}');

        prDialog.hide();
        if (artistprovider.otpModel.result?[0].fullName.toString() == "" ||
            artistprovider.otpModel.result?[0].email.toString() == "" ||
            artistprovider.otpModel.result?[0].mobileNumber.toString() == "") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const EditProfile(
                    typeEdit: "loginType",
                  ),
                ),
                (route) => false);
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const BottomBar(),
                ),
                (route) => false);
          });
        }
      } else {
        prDialog.hide();
        if (!mounted) return;
        Utils().showToast(artistprovider.otpModel.message ?? "");
      }
    }
  }
}
