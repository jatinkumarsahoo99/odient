import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dtcameo/pages/artistphonepage.dart';
import 'package:dtcameo/pages/artistregisterpage.dart';
import 'package:dtcameo/pages/bottombar.dart';
import 'package:dtcameo/pages/editprofile.dart';
import 'package:dtcameo/pages/forgetpassword.dart';
import 'package:dtcameo/provider/artistprovider.dart';
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
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class CelebrityLoginPage extends StatefulWidget {
  const CelebrityLoginPage({super.key});

  @override
  State<CelebrityLoginPage> createState() => _CelebrityLoginPageState();
}

class _CelebrityLoginPageState extends State<CelebrityLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? firebaseId;
  bool isVisible = true;
  bool isCheck = false;
  dynamic seen;
  File? imageFile;
  String? email, userName, devicetype, deviceToken, strType;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ArtistProvider artistProvider = ArtistProvider();

  @override
  void initState() {
    artistProvider = Provider.of<ArtistProvider>(context, listen: false);
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
                  width: 76,
                  height: 76,
                  imagePath: "appicon.png",
                  fit: BoxFit.fill,
                  isAppicon: true,
                ),
              ),
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
                    textLogin(),
                    const SizedBox(height: 30),
                    textFiled(),
                    _build(),
                    const SizedBox(height: 50),
                    loginButton(),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: MyText(
                        text: "or",
                        multilanguage: true,
                        fontsize: Dimens.textSmall,
                        fontwaight: FontWeight.w700,
                        color: grey,
                      ),
                    ),
                    const SizedBox(height: 40),
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
                    const SizedBox(height: 40),
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

  Widget textLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          color: white,
          text: "celebritylogin",
          fontsize: Dimens.textExtraBig,
          fontwaight: FontWeight.w600,
          maxline: 2,
          overflow: TextOverflow.ellipsis,
          multilanguage: true,
          fontFamily: 'limelight',
        ),
        const SizedBox(height: 10),
        MyText(
          color: white,
          text: "celeb_credentials",
          fontsize: Dimens.textBig,
          maxline: 2,
          overflow: TextOverflow.ellipsis,
          multilanguage: true,
        ),
        const SizedBox(height: 10),
        MyText(
          color: white,
          text: "celebrity_portal",
          fontsize: Dimens.textMedium,
          maxline: 5,
          overflow: TextOverflow.ellipsis,
          multilanguage: true,
        ),
      ],
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
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          style: Utils.googleFontStyle(
              4, 13, FontStyle.normal, white, FontWeight.w600),
          decoration: InputDecoration(
              hintText: "melpeters@gmail.com",
              hintStyle: Utils.googleFontStyle(
                  4, 13, FontStyle.normal, grey, FontWeight.w600),
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
          controller: _passwordController,
          obscureText: isVisible,
          style: Utils.googleFontStyle(
              4, 13, FontStyle.normal, white, FontWeight.w600),
          decoration: InputDecoration(
            hintText: "*********",
            hintStyle: Utils.googleFontStyle(
                4, 13, FontStyle.normal, grey, FontWeight.w600),
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
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

/* Api Call Social  */
  Future<void> checkAndNavigate(
      String mail, String firebaseId, String displayname, String type) async {
    email = mail;
    userName = displayname;
    strType = type;

    printLog("Your email is : $email");
    printLog("Your UserName is : $userName");
    printLog("Your Type is : $type");

    Utils().showProgress(context);
    try {
      await artistProvider.getSocial(
        strType ?? "",
        firebaseId,
        email ?? "",
        devicetype ?? "",
        deviceToken ?? "",
      );
      if (artistProvider.socialModel.status == 200 &&
          (artistProvider.socialModel.result?.length ?? 0) > 0) {
        Utils().showToast(artistProvider.socialModel.message.toString());
        Utils.saveUser(
          userId: artistProvider.socialModel.result?[0].id.toString() ?? "",
          userName: artistProvider.socialModel.result?[0].fullName ?? "",
          userEmail: artistProvider.socialModel.result?[0].email ?? "",
          userMobilenumber:
              artistProvider.socialModel.result?[0].mobileNumber.toString() ??
                  "",
          userImage: artistProvider.socialModel.result?[0].image ?? "",
          userType: artistProvider.socialModel.result?[0].type.toString() ?? "",
          dob: artistProvider.socialModel.result?[0].dateOfBirth.toString() ??
              "",
          bio: artistProvider.socialModel.result?[0].bio.toString() ?? "",
          isArtist:
              artistProvider.socialModel.result?[0].isArtist.toString() ?? "",
          isBuy: artistProvider.socialModel.result?[0].isBuy.toString(),
          countryName:
              artistProvider.socialModel.result?[0].countryName.toString(),
          countryCode:
              artistProvider.socialModel.result?[0].countryCode.toString(),
        );

        //user id show
        Constant.userId =
            artistProvider.socialModel.result?[0].id.toString() ?? "";
        Constant.userBuy =
            artistProvider.socialModel.result?[0].isBuy.toString() ?? "";
        printLog("Login page user id is ${Constant.userId}");

        if (!mounted) return;
        Utils.hideProgress();

        if (type == "4") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const BottomBar(),
                ),
                (route) => false);
          });
        } else {
          if (artistProvider.socialModel.result?[0].fullName.toString() == "" ||
              artistProvider.socialModel.result?[0].email.toString() == "" ||
              artistProvider.socialModel.result?[0].mobileNumber.toString() ==
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
        Utils().showToast(artistProvider.socialModel.message.toString());
      }
    } catch (e) {
      // Hide Progress Dialog
      if (!mounted) return;
      Utils.hideProgress();
      Utils().showToast(artistProvider.socialModel.message.toString());
      printLog(e.toString());
    }
  }

/* End */
/* Google Login */
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
  Widget btnOtp() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ArtistPhonePage(),
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

  /* Apple Login */
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

  Widget _build() {
    return Row(
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
              side: const BorderSide(
                  width: 1, color: white, style: BorderStyle.solid),
              value: isCheck,
              onChanged: (value) {
                setState(() {
                  isCheck = value!;
                });
              },
            ),
            MyText(
              color: grey,
              text: 'rememberme',
              fontsize: Dimens.textSmall,
              maxline: 2,
              overflow: TextOverflow.ellipsis,
              multilanguage: true,
            ),
          ],
        ),
        InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ForgetPassword(),
              )),
          child: MyText(
              text: "forgetpassword",
              maxline: 2,
              multilanguage: true,
              fontstyle: FontStyle.normal,
              fontsize: Dimens.textSmall,
              color: yellow),
        )
      ],
    );
  }

/* Login Button with Api call */
  Widget loginButton() {
    return InkWell(
      onTap: () async {
        if (isCheck) {
          if (_emailController.text.isEmpty) {
            Utils().showToast("Email is required..");
          } else if (_passwordController.text.isEmpty) {
            Utils().showToast("Password is required..");
          } else if (_passwordController.text.length < 6) {
            Utils().showToast("Password must be 6 digit ");
          } else {
            /* Firebase Messaging Start */
            User? user = await signInWithEmailAndPassword(
                _emailController.text, _passwordController.text);

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
                        artistProvider.userModel.result?[0].email ?? "",
                    FirestoreConstants.name:
                        artistProvider.userModel.result?[0].fullName ?? "",
                    FirestoreConstants.profileurl:
                        artistProvider.userModel.result?[0].image ?? "",
                    FirestoreConstants.userid: firebaseId,
                    FirestoreConstants.createdAt:
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    FirestoreConstants.bioData:
                        artistProvider.userModel.result?[0].bio ?? "",
                    FirestoreConstants.username:
                        artistProvider.userModel.result?[0].fullName ?? "",
                    FirestoreConstants.mobileNumber:
                        artistProvider.userModel.result?[0].mobileNumber ?? "",
                    FirestoreConstants.dob:
                        artistProvider.userModel.result?[0].dateOfBirth ?? "",
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
            /* Firebase Messaging End */
            /* Normal Login Api Start */
            normalLoginApi("4", firebaseId ?? "", _emailController.text,
                _passwordController.text, devicetype ?? "", deviceToken ?? "");
            /* Normal Login Api Start */
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: !isCheck ? grey : colorAccent,
        ),
        child: MyText(
            text: "login_celebrity",
            multilanguage: true,
            fontstyle: FontStyle.normal,
            fontsize: Dimens.textTitle,
            color: white,
            fontwaight: FontWeight.w700),
      ),
    );
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

/* Login Api Call */
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
      await artistProvider.getLogin(
          type, firebaseId, email, password, devicetype, devicetoken);
      printLog("Loading true");
      if (!artistProvider.loaded) {
        printLog("Loading False");
        if (artistProvider.userModel.status == 200 &&
            (artistProvider.userModel.result?.length ?? 0) > 0) {
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
          Constant.userBuy =
              artistProvider.userModel.result?[0].isBuy.toString();

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
          Utils().showToast(artistProvider.userModel.message.toString());
        }
      }
    } catch (e) {
      if (!mounted) return;
      Utils.hideProgress();
      Utils().showToast(artistProvider.userModel.message.toString());
    }
  }
  /* End */
}
