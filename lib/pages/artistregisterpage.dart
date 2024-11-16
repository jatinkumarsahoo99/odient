import 'dart:io';
import 'package:dtcameo/utils/dimens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dtcameo/pages/bottombar.dart';
import 'package:dtcameo/pages/celebrityloginpage.dart';
import 'package:dtcameo/provider/artistprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/firebaseconstant.dart';
import 'package:dtcameo/utils/shareperf.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/myimage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class ArtistRegisterPage extends StatefulWidget {
  const ArtistRegisterPage({super.key});

  @override
  State<ArtistRegisterPage> createState() => _ArtistRegisterPageState();
}

class _ArtistRegisterPageState extends State<ArtistRegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String? firebaseId;
  String? countryCode, countryName;
  int? selectedValue;
  DateTime _selectedDate = DateTime.now();
  bool isVisible = true;
  bool isCheck = false;
  ProgressDialog? prDialog;
  String? email, userName, devicetype, deviceToken, strType;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ArtistProvider artistProvider = ArtistProvider();

  @override
  void initState() {
    artistProvider = Provider.of<ArtistProvider>(context, listen: false);
    _getDeviceToken();
    getApi();
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

  Future<void> getApi() async {
    await artistProvider.getProfession();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        extendBody: false,
        resizeToAvoidBottomInset: true,
        backgroundColor: colorPrimaryDark,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.antiAliasWithSaveLayer,
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
                    width: 76,
                    height: 76,
                    isAppicon: true,
                    imagePath: "appicon.png",
                    fit: BoxFit.fill,
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
                height: MediaQuery.of(context).size.height * 1.1,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: colorPrimary,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36))),
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(
                        parent: NeverScrollableScrollPhysics()),
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _myTitle(title: 'name'),
                        const SizedBox(height: 5),
                        myTextField(_nameController, TextInputAction.next,
                            TextInputType.name, "Abc....."),
                        const SizedBox(height: 20),
                        _myTitle(title: 'profession'),
                        const SizedBox(height: 5),
                        professionSelecte(),
                        const SizedBox(height: 20),
                        _myTitle(title: 'mobilenumber'),
                        const SizedBox(height: 5),
                        phoneField(),
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
                          obscureText: isVisible,
                          style: Utils.googleFontStyle(
                              4, 13, FontStyle.normal, white, FontWeight.w600),
                          decoration: InputDecoration(
                              hintText: "*********",
                              hintStyle: Utils.googleFontStyle(4, 13,
                                  FontStyle.normal, grey, FontWeight.w600),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  icon: Icon(
                                    isVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: white,
                                  )),
                              fillColor: colorPrimaryDark,
                              filled: true,
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none)),
                        ),
                        const SizedBox(height: 20),
                        _myTitle(title: 'dob'),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: dateController,
                          style: Utils.googleFontStyle(
                              2, 15, FontStyle.normal, white, FontWeight.w600),
                          readOnly: true,
                          onTap: () {
                            dateTimeData(context);
                          },
                          decoration: InputDecoration(
                              hintText: "23/05/1995",
                              hintStyle: Utils.googleFontStyle(4, 15,
                                  FontStyle.normal, grey, FontWeight.w500),
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
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none)),
                        ),
                        const SizedBox(height: 20),
                        _myTitle(title: 'fees'),
                        const SizedBox(height: 5),
                        myTextField(_feesController, TextInputAction.next,
                            TextInputType.number, "20000...."),
                        const SizedBox(height: 35),
                        normalSignUp(),
                        const SizedBox(height: 40),
                        account(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
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
      cursorColor: white,
      style: Utils.googleFontStyle(
          2, 12, FontStyle.normal, white, FontWeight.w500),
      decoration: InputDecoration(
          hintText: labletext,
          hintStyle: Utils.googleFontStyle(
              2, 12, FontStyle.normal, grey, FontWeight.w500),
          contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          fillColor: colorPrimaryDark,
          filled: true,
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none)),
    );
  }

  Widget professionSelecte() {
    return Consumer<ArtistProvider>(
      builder: (context, artistProvider, child) {
        if (artistProvider.loaded) {
          return professionShimmer();
        } else {
          if (artistProvider.professionModel.status == 200 &&
              (artistProvider.professionModel.result?.length ?? 0) > 0) {
            return DropdownButtonFormField(
              dropdownColor: colorPrimaryDark,
              style: Utils.googleFontStyle(
                  4, 15, FontStyle.normal, white, FontWeight.w500),
              decoration: InputDecoration(
                  hintText: "Type profession...",
                  hintStyle: Utils.googleFontStyle(
                      2, 12, FontStyle.normal, grey, FontWeight.w500),
                  contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  fillColor: colorPrimaryDark,
                  filled: true,
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none)),
              value: selectedValue,
              items: artistProvider.professionModel.result!.map(
                (profession) {
                  return DropdownMenuItem(
                      value: profession.id,
                      child: MyText(
                        text: profession.name ?? "",
                        fontsize: Dimens.textTitle,
                        color: white,
                        fontwaight: FontWeight.w600,
                      ));
                },
              ).toList(),
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                  printLog("selected value is : $selectedValue");
                });
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget professionShimmer() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: CustomWidget.rectangular(
        height: 40,
        width: MediaQuery.of(context).size.width,
      ),
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
        fontSize: Dimens.textTitle,
        fontWeight: FontWeight.w500,
      ),
      style: Utils.googleFontStyle(
          2, 12, FontStyle.normal, white, FontWeight.w500),
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.phone_android),
          fillColor: colorPrimaryDark,
          filled: true,
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          hintText: "8254768....",
          hintStyle: Utils.googleFontStyle(
              2, 12, FontStyle.normal, grey, FontWeight.w500)),
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
              builder: (context) => const CelebrityLoginPage(),
            ));
          },
          child: MyText(
            text: "artistlogin",
            multilanguage: true,
            fontsize: Dimens.textTitle,
            color: colorAccent,
          ),
        ),
      ],
    );
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
            selectedValue.toString(),
            _phoneController.text,
            countryCode ?? "",
            countryName ?? "",
            _emailController.text,
            password,
            dateController.text.toString(),
            _feesController.text.toString(),
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
            } else if (_feesController.text.isEmpty) {
              Utils().showToast("Fees is required");
            } else {
              firebaseRegister(email, password);
            }
          },
          child: MyText(
            text: "artistregister",
            multilanguage: true,
            fontsize: Dimens.textMedium,
            fontwaight: FontWeight.w600,
            color: white,
          )),
    );
  }

  Future<void> normalRegister(
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
    Utils().showProgress(context);
    try {
      await artistProvider.getRegister(
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

      if (artistProvider.userModel.status == 200 &&
          (artistProvider.userModel.result?.length ?? 0) > 0) {
        Utils().showToast(artistProvider.userModel.message.toString());
        Utils.saveUser(
          userId: artistProvider.userModel.result?[0].id.toString(),
          userName: artistProvider.userModel.result?[0].fullName.toString(),
          userEmail: artistProvider.userModel.result?[0].email.toString(),
          userMobilenumber:
              artistProvider.userModel.result?[0].mobileNumber.toString(),
          userImage: artistProvider.userModel.result?[0].image.toString(),
          userType: artistProvider.userModel.result?[0].type.toString(),
          dob: artistProvider.userModel.result?[0].dateOfBirth.toString(),
          bio: artistProvider.userModel.result?[0].bio.toString(),
          isArtist: artistProvider.userModel.result?[0].isArtist.toString(),
          isBuy: artistProvider.userModel.result?[0].isBuy.toString(),
          countryName:
              artistProvider.userModel.result?[0].countryName.toString(),
          countryCode:
              artistProvider.userModel.result?[0].countryCode.toString(),
        );
        Constant.userId = artistProvider.userModel.result?[0].id.toString();
        Constant.userBuy = artistProvider.userModel.result?[0].isBuy.toString();

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
        Utils().showToast(artistProvider.userModel.message.toString());
      }
    } catch (e) {
      if (!mounted) return;
      Utils.hideProgress();
      Utils().showToast(artistProvider.userModel.message.toString());
    }
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
