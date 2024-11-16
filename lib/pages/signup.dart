import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dtcameo/pages/bottombar.dart';
import 'package:dtcameo/pages/login.dart';
import 'package:dtcameo/provider/generalprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/firebaseconstant.dart';
import 'package:dtcameo/utils/shareperf.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/myimage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool? checkboxOption1 = false;
  bool? checkboxOption2 = false;
  String? selectedMonth;
  String? selectedDate;
  String? selectedYear;
  String? countryCode;
  String? countryName;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _conPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool isVisible1 = true;
  bool isVisible2 = true;
  ProgressDialog? prDialog;
  String? email, userName, devicetype, deviceToken, strType, firebaseId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  GeneralProvider generalProvider = GeneralProvider();

  @override
  void initState() {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    _getDeviceToken();
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
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
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: colorPrimary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36))),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _myTitle(title: 'name'),
                    const SizedBox(height: 5),
                    myTextField(_nameController, TextInputAction.next,
                        TextInputType.name, "Abc"),
                    const SizedBox(height: 20),
                    _myTitle(title: 'email'),
                    const SizedBox(height: 5),
                    myTextField(_emailController, TextInputAction.next,
                        TextInputType.emailAddress, "abc@gmail.com"),
                    const SizedBox(height: 20),
                    _myTitle(title: 'password'),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: isVisible1,
                      style: Utils.googleFontStyle(
                          4, 14, FontStyle.normal, white, FontWeight.w600),
                      decoration: InputDecoration(
                          hintText: "*********",
                          hintStyle: Utils.googleFontStyle(
                              4, 14, FontStyle.normal, grey, FontWeight.w600),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: white,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible1 = !isVisible1;
                                });
                              },
                              icon: Icon(
                                isVisible1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: white,
                              )),
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
                    _myTitle(title: 'con_password'),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _conPasswordController,
                      obscureText: isVisible2,
                      style: Utils.googleFontStyle(
                          4, 14, FontStyle.normal, white, FontWeight.w600),
                      decoration: InputDecoration(
                          hintText: "*********",
                          hintStyle: Utils.googleFontStyle(
                              4, 14, FontStyle.normal, grey, FontWeight.w600),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: white,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible2 = !isVisible2;
                                });
                              },
                              icon: Icon(
                                isVisible2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: white,
                              )),
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
                    _myTitle(title: 'mobilenumber'),
                    const SizedBox(height: 5),
                    phoneField(),
                    const SizedBox(height: 20),
                    _myTitle(title: 'dob'),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: dateController,
                      style: Utils.googleFontStyle(
                          2, 14, FontStyle.normal, white, FontWeight.w600),
                      readOnly: true,
                      onTap: () {
                        dateTimeData(context);
                      },
                      decoration: InputDecoration(
                          hintText: "23/05/1995",
                          hintStyle: Utils.googleFontStyle(
                              4, 14, FontStyle.normal, grey, FontWeight.w500),
                          prefixIcon: const Icon(
                            Icons.date_range,
                            color: white,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: white,
                              size: 30,
                            ),
                            onPressed: () {
                              dateTimeData(context);
                            },
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(15, 0, 15, 0),
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
                    const SizedBox(height: 35),
                    normalSignUp(),
                    const SizedBox(height: 25),
                    account(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myTextField(controller, textInputAction, keyboardType, labletext) {
    return TextFormField(
      textAlign: TextAlign.left,
      obscureText: false,
      keyboardType: keyboardType,
      controller: controller,
      textInputAction: textInputAction,
      cursorColor: colorPrimaryDark,
      style: Utils.googleFontStyle(
          2, 14, FontStyle.normal, white, FontWeight.w500),
      decoration: InputDecoration(
          hintText: labletext,
          hintStyle: GoogleFonts.lato(
              fontSize: Dimens.textMedium,
              color: grey,
              fontWeight: FontWeight.w500),
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
    );
  }

  Widget _myTitle({required String? title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: MyText(
        text: title!,
        fontsize: Dimens.textTitle,
        color: white,
        multilanguage: true,
        fontwaight: FontWeight.w500,
      ),
    );
  }

  Widget phoneField() {
    return IntlPhoneField(
      disableLengthCheck: true,
      textAlignVertical: TextAlignVertical.center,
      autovalidateMode: AutovalidateMode.disabled,
      showCountryFlag: true,
      showDropdownIcon: false,
      initialCountryCode: "IN",
      onCountryChanged: (country) {
        countryCode = "+${country.dialCode.toString()}";
        countryName = country.code.replaceAll('+', '');
        printLog('countrycode===> $countryCode');
        printLog('countryName===> $countryName');
      },
      onChanged: (phone) {
        printLog('===> ${phone.completeNumber}');
        printLog('===> ${_phoneController.text}');

        countryName = phone.countryISOCode;
        countryCode = phone.countryCode;
      },
      dropdownTextStyle: GoogleFonts.inter(
        color: white,
        fontSize: Dimens.textMedium,
        fontWeight: FontWeight.w500,
      ),
      style: Utils.googleFontStyle(
          2, 14, FontStyle.normal, white, FontWeight.w500),
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.phone_android),
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
              borderSide: BorderSide.none),
          hintText: "8254768....",
          hintStyle: Utils.googleFontStyle(
              2, 14, FontStyle.normal, grey, FontWeight.w500)),
    );
  }

  Widget normalSignUp() {
    return Container(
      height: 42,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: colorAccent),
      child: TextButton(
          onPressed: () {
            String name = _nameController.text.toString();
            String mobile = _phoneController.text.toString();
            String email = _emailController.text.toString();
            String password = _passwordController.text.toString();

            if (name.isEmpty) {
              Utils().showToast("Name is Required..");
            } else if (mobile.isEmpty) {
              Utils().showToast("Mobile nuber is Required..");
            } else if (mobile.length < 10) {
              Utils().showToast("Mobile number must be 10 digit");
            } else if (email.isEmpty) {
              Utils().showToast("Email is Required..");
            } else if (password.isEmpty) {
              Utils().showToast("Password is Required..");
            } else if (password.length < 6) {
              Utils().showToast("Password must be 6 letter Required..");
            } else if (password != _conPasswordController.text) {
              Utils().showToast("Your password is not same");
            } else {
              firebaseRegister(email, password);
            }
          },
          child: MyText(
            text: "signup",
            multilanguage: true,
            fontsize: Dimens.textBig,
            fontwaight: FontWeight.w600,
            color: white,
          )),
    );
  }

  Future<void> normalRegister(
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
    Utils().showProgress(context);
    try {
      await generalProvider.getRegister(
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

      if (generalProvider.userModel.status == 200 &&
          (generalProvider.userModel.result?.length ?? 0) > 0) {
        Utils().showToast(generalProvider.userModel.message.toString());
        Utils.saveUser(
          userId: generalProvider.userModel.result?[0].id.toString(),
          userName: generalProvider.userModel.result?[0].fullName.toString(),
          userEmail: generalProvider.userModel.result?[0].email.toString(),
          userMobilenumber:
              generalProvider.userModel.result?[0].mobileNumber.toString(),
          userImage: generalProvider.userModel.result?[0].image.toString(),
          userType: generalProvider.userModel.result?[0].type.toString(),
          dob: generalProvider.userModel.result?[0].dateOfBirth.toString(),
          bio: generalProvider.userModel.result?[0].bio.toString(),
          isArtist: generalProvider.userModel.result?[0].isArtist.toString(),
          isBuy: generalProvider.userModel.result?[0].isBuy.toString(),
          countryName:
              generalProvider.userModel.result?[0].countryName.toString(),
          countryCode:
              generalProvider.userModel.result?[0].countryCode.toString(),
        );
        Constant.userId = generalProvider.userModel.result?[0].id.toString();
        Constant.userBuy =
            generalProvider.userModel.result?[0].isBuy.toString();

        printLog("Login User id is : ${Constant.userId}");
        if (!mounted) return;
        Utils.hideProgress();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomBar(),
              ),
              (Route<dynamic> route) => false);
        });
      } else {
        if (!mounted) return;
        Utils.hideProgress();
        Utils().showToast(generalProvider.userModel.message.toString());
      }
    } catch (e) {
      if (!mounted) return;
      Utils.hideProgress();
      Utils().showToast(generalProvider.userModel.message.toString());
    }
  }

  firebaseRegister(String email, String password) async {
    printLog("firebaseRegister email ========> $email");
    printLog("firebaseRegister password =====> $password");
    User? user = await createUserWithEmailAndPassword(email, password);

    prDialog?.hide();
    if (user != null) {
      try {
        assert(await user.getIdToken() != null);
        printLog("User Name: ${user.displayName}");
        printLog("User Email ${user.email}");
        printLog("User photoUrl ${user.photoURL}");
        printLog("uid ===> ${user.uid}");
        firebaseId = user.uid;
        printLog('firebaseId :===> $firebaseId');
        SharePre().save("firebaseid", firebaseId);

        // Check is already sign up
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection(FirestoreConstants.pathUserCollection)
            .where(FirestoreConstants.userid, isEqualTo: firebaseId)
            .get();

        final List<DocumentSnapshot> documents = result.docs;

        if (documents.isEmpty) {
          // Writing data to server because here is a new user
          FirebaseFirestore.instance
              .collection(FirestoreConstants.pathUserCollection)
              .doc(firebaseId)
              .set({
            FirestoreConstants.email: email,
            FirestoreConstants.name: _nameController.text,
            FirestoreConstants.profileurl: Constant.userPlaceholder,
            FirestoreConstants.userid: firebaseId,
            FirestoreConstants.createdAt:
                DateTime.now().millisecondsSinceEpoch.toString(),
            FirestoreConstants.bioData: "",
            FirestoreConstants.username: "",
            FirestoreConstants.mobileNumber: _phoneController.text,
            FirestoreConstants.chattingWith: null,
            FirestoreConstants.pushToken: deviceToken
          });
        } else {
          printLog('strdeviceToken ....==>> $deviceToken');
          printLog('firebaseId ....==>> $firebaseId');
          // Update data to Firestore
          FirebaseFirestore.instance
              .collection(FirestoreConstants.pathUserCollection)
              .doc(firebaseId)
              .update({
                FirestoreConstants.email: email,
                FirestoreConstants.name: _nameController.text,
                FirestoreConstants.profileurl: Constant.userPlaceholder,
                FirestoreConstants.userid: firebaseId,
                FirestoreConstants.createdAt:
                    DateTime.now().millisecondsSinceEpoch.toString(),
                FirestoreConstants.bioData: "",
                FirestoreConstants.username: "",
                FirestoreConstants.mobileNumber: _phoneController.text,
                FirestoreConstants.dob: dateController.text,
                FirestoreConstants.chattingWith: null,
                FirestoreConstants.pushToken: deviceToken
              })
              .then((value) => printLog("User Updated"))
              .onError((error, stackTrace) {
                printLog("updateDataFirestore error ===> ${error.toString()}");
                printLog(
                    "updateDataFirestore stackTrace ===> ${stackTrace.toString()}");
              });
        }
        normalRegister(
            "4",
            firebaseId ?? "",
            _nameController.text,
            _phoneController.text,
            _emailController.text,
            password,
            dateController.text.toString(),
            countryCode ?? "",
            countryName ?? "",
            devicetype ?? "",
            deviceToken ?? "");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          printLog('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          Utils().showToast(e.message ?? "");
          printLog('The account already exists for that email.');
        }
      }
    }
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      printLog('createUserWithEmailAndPassword Error 1 :===> $e');
      if (e.code == 'email-already-in-use') {
        printLog('The account already exists for that email.');
        try {
          UserCredential userCredential =
              await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          return userCredential.user;
        } on FirebaseAuthException catch (e) {
          printLog('createUserWithEmailAndPassword Error 2 :===> $e');
          if (e.code == 'email-already-in-use') {
            printLog('The account already exists for that email.');
            Utils().showToast(e.message.toString());
          }
        }
      }
      return null;
    }
  }

  Widget account() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyText(
          text: "alreadyhaveanaccount",
          multilanguage: true,
          fontsize: Dimens.textMedium,
          color: white,
        ),
        const SizedBox(width: 4),
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const Login(),
            ));
          },
          child: MyText(
            text: "login",
            multilanguage: true,
            fontsize: Dimens.textMedium,
            color: colorAccent,
          ),
        ),
      ],
    );
  }

  Future<void> dateTimeData(BuildContext context) async {
    final DateTime? dateTime = await showDatePicker(
        context: context,
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
        initialDate: DateTime.now());
    if (dateTime != null && dateTime != _selectedDate) {
      setState(() {
        _selectedDate = dateTime;
        dateController.text =
            '${dateTime.day}-${dateTime.month}-${dateTime.year}';
        printLog("Your Date of Brith is : ${dateController.text.toString()}");
      });
    }
  }
}
