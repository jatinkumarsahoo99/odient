import 'dart:convert';

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dtcameo/pages/bottombar.dart';
import 'package:dtcameo/pages/celebrityloginpage.dart';
import 'package:dtcameo/pages/editprofile.dart';
import 'package:dtcameo/pages/forgetpassword.dart';
import 'package:dtcameo/pages/phonepage.dart';
import 'package:dtcameo/pages/signup.dart';
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
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool checkboxOption1 = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isVisible = true;
  dynamic seen;
  File? imageFile;
  String? email, userName, devicetype, deviceToken, strType, firebaseId;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                decoration: const BoxDecoration(
                    color: colorPrimary,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textFiled(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              activeColor: white,
                              checkColor: colorAccent,
                              focusColor: white,
                              hoverColor: white,
                              visualDensity: VisualDensity.standard,
                              value: checkboxOption1,
                              onChanged: (value) {
                                setState(() {
                                  checkboxOption1 = value!;
                                });
                              },
                            ),
                            const SizedBox(width: 6),
                            MyText(
                              text: "rememberme",
                              multilanguage: true,
                              color: lightGrey,
                              fontsize: Dimens.textMedium,
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ForgetPassword(),
                            ));
                          },
                          child: MyText(
                            text: "forgetpassword",
                            multilanguage: true,
                            fontsize: Dimens.textMedium,
                            fontwaight: FontWeight.w500,
                            color: yellow,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    !checkboxOption1
                        ? Container(
                            alignment: Alignment.center,
                            height: 45,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: grey,
                                borderRadius: BorderRadius.circular(39)),
                            child: MyText(
                                text: "login",
                                multilanguage: true,
                                fontstyle: FontStyle.normal,
                                fontsize: Dimens.textBig,
                                color: white,
                                fontwaight: FontWeight.w700),
                          )
                        : btnLogin(),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: MyText(
                        text: "or",
                        multilanguage: true,
                        fontsize: Dimens.textMedium,
                        fontwaight: FontWeight.w700,
                        color: grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        googleButton(),
                        const SizedBox(width: 30),
                        appleButton(),
                        const SizedBox(width: 30),
                        btnOtp(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    celeLoginBtn(),
                    const SizedBox(height: 20),
                    account(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: "emailadress",
          multilanguage: true,
          fontsize: Dimens.textTitle,
          color: white,
          fontwaight: FontWeight.w500,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: emailController,
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
        ),
        const SizedBox(height: 15),
        MyText(
          text: "password",
          multilanguage: true,
          fontsize: Dimens.textTitle,
          color: white,
          fontwaight: FontWeight.w500,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: passwordController,
          obscureText: isVisible,
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
                      isVisible = !isVisible;
                    });
                  },
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
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
      ],
    );
  }

  Widget googleButton() {
    return InkWell(
      onTap: () {
        googleLogin();
      },
      child: Container(
        height: 50,
        width: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: white,
            border: Border.all(
                width: 1, color: colorAccent, style: BorderStyle.solid)),
        child: const MyImage(
          width: 18,
          height: 18,
          imagePath: "google.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget btnOtp() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PhonePage(),
          ),
        );
      },
      child: Container(
        height: 50,
        width: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: white,
            border: Border.all(
                width: 1, color: colorAccent, style: BorderStyle.solid)),
        child: const Icon(
          Icons.phone_android,
          size: 26,
        ),
      ),
    );
  }

  Widget appleButton() {
    return InkWell(
      onTap: () {
        signInWithApple();
      },
      child: Container(
        height: 50,
        width: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: white,
            border: Border.all(
                width: 1, color: colorAccent, style: BorderStyle.solid)),
        child: const Icon(
          Icons.apple,
          size: 26,
        ),
      ),
    );
  }

  updateDataInFirestore({required String firebasedid}) {
    printLog('strDeviceToken ....==>> $deviceToken');
    printLog('firebasedid ....==>> $firebasedid');
    // Update data to Firestore
    FirebaseFirestore.instance
        .collection(FirestoreConstants.pathUserCollection)
        .doc(firebasedid)
        .update({
          FirestoreConstants.email: email,
          FirestoreConstants.name: "",
          FirestoreConstants.profileurl: Constant.userPlaceholder,
          FirestoreConstants.userid: firebaseId,
          FirestoreConstants.createdAt:
              DateTime.now().millisecondsSinceEpoch.toString(),
          FirestoreConstants.bioData: "",
          FirestoreConstants.username: "",
          FirestoreConstants.mobileNumber: "",
          FirestoreConstants.dob: "",
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

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        Utils().showToast('Invalid Email');
        printLog('Firebase Authentication Exception: ${e.code}/////////////');
      } else if (e.code == 'user-not-found') {
        Utils().showToast('User not found for this Email');
        printLog('Firebase Authentication Exception: ${e.code}/////////////');
      } else if (e.code == 'wrong-password') {
        Utils().showToast('Wrong Password');
        printLog('Firebase Authentication Exception: ${e.code}/////////////');
      }
      return null;
    }
  }

  Widget btnLogin() {
    return Container(
      height: 42,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: colorAccent, borderRadius: BorderRadius.circular(20)),
      child: TextButton(
        onPressed: () async {
          if (emailController.text.isEmpty) {
            Utils().showToast("Email is required..");
          } else if (passwordController.text.isEmpty) {
            Utils().showToast("Password is required..");
          } else if (passwordController.text.length < 6) {
            Utils().showToast("Password must be 6 digit ");
          } else {
            User? user = await signInWithEmailAndPassword(
                emailController.text, passwordController.text);

            if (user != null) {
              try {
                assert(await user.getIdToken() != null);
                printLog("User Name: ${user.displayName}");
                printLog("User Email ${user.email}");
                printLog("User photoUrl ${user.photoURL}");
                printLog("uid ===> ${user.uid}");
                firebaseId = user.uid;
                printLog('firebasedid :===> $firebaseId');
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
                    FirestoreConstants.email:
                        generalProvider.userModel.result?[0].email ?? "",
                    FirestoreConstants.name:
                        generalProvider.userModel.result?[0].fullName ?? "",
                    FirestoreConstants.profileurl:
                        generalProvider.userModel.result?[0].image ?? "",
                    FirestoreConstants.userid: firebaseId,
                    FirestoreConstants.createdAt:
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    FirestoreConstants.bioData:
                        generalProvider.userModel.result?[0].bio ?? "",
                    FirestoreConstants.username:
                        generalProvider.userModel.result?[0].fullName ?? "",
                    FirestoreConstants.mobileNumber:
                        generalProvider.userModel.result?[0].mobileNumber ?? "",
                    FirestoreConstants.dob:
                        generalProvider.userModel.result?[0].dateOfBirth ?? "",
                    FirestoreConstants.chattingWith: null,
                    FirestoreConstants.pushToken: deviceToken
                  });
                } else {
                  updateDataInFirestore(firebasedid: firebaseId ?? "");
                }
              } catch (e) {
                printLog(e.toString());
              }
            }

            normalLoginApi("4", firebaseId ?? "", emailController.text,
                passwordController.text, devicetype ?? "", deviceToken ?? "");
          }
        },
        child: MyText(
          text: "login",
          multilanguage: true,
          fontsize: Dimens.textMedium,
          fontwaight: FontWeight.w600,
          color: white,
        ),
      ),
    );
  }

  Widget celeLoginBtn() {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const CelebrityLoginPage(),
          ));
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: orange,
            minimumSize: const Size(double.maxFinite, 50)),
        child: MyText(
          text: "loginifyouarealredyacelebrity",
          multilanguage: true,
          fontstyle: FontStyle.normal,
          fontsize: Dimens.textTitle,
          fontwaight: FontWeight.w700,
          color: colorPrimaryDark,
        ));
  }

  Future<void> normalLoginApi(
    String type,
    String firebaseId,
    String email,
    String password,
    String devicetype,
    String devicetoken,
  ) async {
    Utils().showProgress(context);
    try {
      await generalProvider.getLogin(
          type, firebaseId, email, password, devicetype, devicetoken);

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

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
              builder: (context) => const SignUp(),
            ));
          },
          child: MyText(
            text: "signup",
            multilanguage: true,
            fontsize: Dimens.textTitle,
            color: colorAccent,
          ),
        ),
      ],
    );
  }

/* Social Login Start */
  Future<void> checkAndNavigate(String mail, String firebaseId,
      String displayname, String loginType) async {
    email = mail;
    userName = displayname;
    strType = loginType;

    printLog("Your email is : $email");
    printLog("Your UserName is : $userName");
    printLog("Your Type is : $loginType");

    Utils().showProgress(context);
    try {
      await generalProvider.getSocial(
        strType ?? "",
        firebaseId,
        email ?? "",
        devicetype ?? "",
        deviceToken ?? "",
      );
      if (generalProvider.socialModel.status == 200 &&
          (generalProvider.socialModel.result?.length ?? 0) > 0) {
        Utils().showToast(generalProvider.socialModel.message.toString());
        Utils.saveUser(
          userId: generalProvider.socialModel.result?[0].id.toString() ?? "",
          userName: displayname,
          userEmail: email,
          userMobilenumber:
              generalProvider.socialModel.result?[0].mobileNumber.toString() ??
                  "",
          userImage: generalProvider.socialModel.result?[0].image ?? "",
          userType:
              generalProvider.socialModel.result?[0].type.toString() ?? "",
          dob: generalProvider.socialModel.result?[0].dateOfBirth.toString() ??
              "",
          bio: generalProvider.socialModel.result?[0].bio.toString() ?? "",
          isArtist:
              generalProvider.socialModel.result?[0].isArtist.toString() ?? "",
          isBuy: generalProvider.socialModel.result?[0].isBuy.toString(),
          countryName:
              generalProvider.socialModel.result?[0].countryName.toString(),
          countryCode:
              generalProvider.socialModel.result?[0].countryCode.toString(),
        );

        Constant.userId =
            generalProvider.socialModel.result?[0].id.toString() ?? "";
        Constant.userBuy =
            generalProvider.socialModel.result?[0].isBuy.toString() ?? "";
        if (!mounted) return;
        Utils.hideProgress();

        if (loginType == "4") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const BottomBar(),
                ),
                (route) => false);
          });
        } else {
          if (generalProvider.socialModel.result?[0].fullName.toString() ==
                  "" ||
              generalProvider.socialModel.result?[0].email.toString() == "" ||
              generalProvider.socialModel.result?[0].mobileNumber.toString() ==
                  "") {
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
        }
      } else {
        // Hide Progress Dialog
        if (!mounted) return;
        Utils.hideProgress();
        Utils().showToast(generalProvider.socialModel.message.toString());
      }
    } catch (e) {
      // Hide Progress Dialog
      if (!mounted) return;
      Utils.hideProgress();
      Utils().showToast(generalProvider.socialModel.message.toString());
      printLog(e.toString());
    }
  }

  /* Apple Login */
  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      printLog(appleCredential.authorizationCode);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final authResult = await _auth.signInWithCredential(oauthCredential);

      /*  ************************************/
      String? displayName =
          '${appleCredential.givenName} ${appleCredential.familyName}';
      String userEmail = authResult.user?.email.toString() ?? "";
      // printLog("===>userEmail $userEmail");
      // printLog("===>displayName $displayName");

      final firebaseUser = authResult.user;

      String firebasedId = firebaseUser?.uid ?? "";
      SharePre().save("firebaseid", firebasedId);

      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection(FirestoreConstants.pathUserCollection)
          .where(FirestoreConstants.userid, isEqualTo: firebasedId)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isEmpty) {
        // Writing data to server because here is a new user
        FirebaseFirestore.instance
            .collection(FirestoreConstants.pathUserCollection)
            .doc(firebasedId)
            .set({
          FirestoreConstants.email: firebaseUser?.email ?? "",
          FirestoreConstants.deviceToken: deviceToken,
          FirestoreConstants.name: displayName,
          FirestoreConstants.profileurl:
              firebaseUser?.photoURL ?? Constant.userPlaceholder,
          FirestoreConstants.userid: firebasedId,
          FirestoreConstants.createdAt:
              DateTime.now().millisecondsSinceEpoch.toString(),
          FirestoreConstants.bioData:
              "Hey! there I'm using ${Constant.appName} app.",
          FirestoreConstants.username: "",
          FirestoreConstants.mobileNumber: firebaseUser?.phoneNumber ?? "",
          FirestoreConstants.chattingWith: null,
        });
      }
      checkAndNavigate(userEmail, firebasedId, displayName, "3");
    } catch (exception) {
      if (exception is FirebaseAuthException &&
          exception.code == 'firebase_auth/email-already-in-use') {
        printLog("The email is already in use.");
      } else {
        printLog("Apple Login exception =====> $exception");
      }
    }
    return null;
  }

/* Apple login end */
/* Google Login */
  Future<void> googleLogin() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    GoogleSignInAccount user = googleUser;
    if (!mounted) return;
    Utils().showProgress(context);

    UserCredential userCredential;
    try {
      GoogleSignInAuthentication googleSignInAuthentication =
          await user.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      if (!mounted) return;
      Utils().showProgress(context);

      userCredential = await _auth.signInWithCredential(credential);
      assert(await userCredential.user?.getIdToken() != null);
      String firebaseId = userCredential.user?.uid ?? "";
      SharePre().save("firebaseid", firebaseId);
      printLog('firebasedid :===> $firebaseId');
      imageFile = File(userCredential.user?.photoURL ?? "");
      printLog('Image File :===> $imageFile');
      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection(FirestoreConstants.pathUserCollection)
          .where(FirestoreConstants.userid,
              isEqualTo: userCredential.user?.uid ?? "")
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isEmpty) {
        // Writing data to server because here is a new user
        FirebaseFirestore.instance
            .collection(FirestoreConstants.pathUserCollection)
            .doc(userCredential.user?.uid ?? "")
            .set({
          FirestoreConstants.email: userCredential.user?.email,
          FirestoreConstants.deviceToken: deviceToken,
          FirestoreConstants.name: userCredential.user?.displayName,
          FirestoreConstants.profileurl: userCredential.user?.photoURL,
          FirestoreConstants.userid: userCredential.user?.uid ?? "",
          FirestoreConstants.createdAt:
              DateTime.now().millisecondsSinceEpoch.toString(),
          FirestoreConstants.bioData:
              "Hey! there I'm using ${Constant.appName} app.",
          FirestoreConstants.username: "",
          FirestoreConstants.mobileNumber:
              userCredential.user?.phoneNumber ?? "",
          FirestoreConstants.chattingWith: null,
        });
      }
      checkAndNavigate(user.email, firebaseId, user.displayName ?? "", "2");
    } on FirebaseAuthException catch (e) {
      printLog('===>Exp${e.code.toString()}');
      printLog('===>Exp${e.message.toString()}');
      if (e.code.toString() == "user-not-found") {
      } else if (e.code == 'wrong-password') {
        // Hide Progress Dialog
        Utils.hideProgress();
        printLog('Wrong password provided.');
        Utils().showToast('Wrong password provided.');
      } else {
        // Hide Progress Dialog
        Utils.hideProgress();
      }
    }
  }

/* Google login End */
/* End */
}
