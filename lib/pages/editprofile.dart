import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtcameo/pages/bottombar.dart';
import 'package:dtcameo/provider/profileprovider.dart';
import 'package:dtcameo/provider/profileupdateprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/firebaseconstant.dart';
import 'package:dtcameo/utils/shareperf.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mynetworkimmage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:dtcameo/utils/dimens.dart';

class EditProfile extends StatefulWidget {
  final String? professionId, typeEdit;
  const EditProfile({super.key, this.professionId, required this.typeEdit});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwdController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  File? imageFile;
  String? userType, countryCode, countryName;
  bool isEditing = false;
  ProgressDialog? progressDialog;
  ImagePicker imagePicker = ImagePicker();
  Profileprovider profileprovider = Profileprovider();
  ProfileUpdateProvider profileUpdateProvider = ProfileUpdateProvider();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    profileprovider = Provider.of<Profileprovider>(context, listen: false);
    progressDialog = ProgressDialog(context);
    super.initState();
    getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getApi();
    });
  }

  Future<void> getImagePick() async {
    final imagePath = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (imagePath != null) {
      setState(() {
        imageFile = File(imagePath.path);
        isEditing = true;
      });
    }
  }

  getData() async {
    userType = await SharePre().read("usertype");
    printLog("Your user type is >>>>>>>>>>>>>>>>>>>>>>>>>>> :$userType");
  }

  getApi() async {
    await profileprovider.getProfile(context, Constant.userId ?? "");
    nameController.text =
        profileprovider.profileModel.result?[0].fullName ?? "";
    emailController.text = profileprovider.profileModel.result?[0].email ?? "";
    phoneController.text =
        profileprovider.profileModel.result?[0].mobileNumber ?? "";
    dateController.text =
        profileprovider.profileModel.result?[0].dateOfBirth ?? "";
    bioController.text = profileprovider.profileModel.result?[0].bio ?? "";
    userType =
        profileprovider.profileModel.result?[0].firebaseId.toString() ?? "";
    printLog("Your new user type is :=================== $userType");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: colorPrimaryDark,
        appBar: AppBar(
          backgroundColor: colorPrimaryDark,
          iconTheme: const IconThemeData(color: white),
          leading: Utils.backButton(context),
          title: MyText(
            text: "edit_prof",
            multilanguage: true,
            color: white,
            fontsize: Dimens.textTitle,
            fontwaight: FontWeight.w600,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                Opacity(
                  opacity: .5,
                  child: Container(
                    height: 210,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              profileprovider.profileModel.result?[0].image ??
                                  ""),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 160, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(alignment: Alignment.center, child: imageUpdate()),
                      const SizedBox(height: 30),
                      textFiled(),
                      const SizedBox(height: 30),
                      submitButton(),
                      const SizedBox(height: 40),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageUpdate() {
    return Consumer<Profileprovider>(
      builder: (context, profileprovider, child) {
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            Positioned(
                child: imageFile != null
                    ? Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(imageFile!),
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.fill,
                            ),
                            shape: BoxShape.circle),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: MyNetworkImage(
                          imageUrl: profileprovider.profileModel.status == 200
                              ? profileprovider.profileModel.result != null
                                  ? (profileprovider
                                          .profileModel.result?[0].image ??
                                      "")
                                  : ""
                              : '',
                          fit: BoxFit.fill,
                          imgHeight: 150,
                          imgWidth: 150,
                        ),
                      )),
            Positioned(
              child: InkWell(
                  onTap: () {
                    getImagePick();
                  },
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: white,
                    child: Icon(Icons.camera_alt_rounded,
                        color: colorAccent, size: 21),
                  )),
            )
          ],
        );
      },
    );
  }

  Widget textFiled() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          color: white,
          text: 'name',
          multilanguage: true,
          fontsize: Dimens.textMedium,
          fontwaight: FontWeight.w500,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: nameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          style: Utils.googleFontStyle(
              2, 15, FontStyle.normal, white, FontWeight.w600),
          decoration: InputDecoration(
              hintText: "Marium Bitz",
              hintStyle: Utils.googleFontStyle(
                  4, 15, FontStyle.normal, grey, FontWeight.w500),
              prefixIcon: const Icon(
                Icons.person,
                color: white,
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: white,
                  size: 30,
                ),
                onPressed: () {
                  nameController.clear();
                },
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      width: 1,
                      color: colorAccent,
                      style: BorderStyle.solid,
                      strokeAlign: 1)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      width: 1,
                      color: colorAccent,
                      style: BorderStyle.solid,
                      strokeAlign: 1)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      width: 1,
                      color: colorAccent,
                      style: BorderStyle.solid,
                      strokeAlign: 1))),
        ),
        const SizedBox(height: 20),
        MyText(
          color: white,
          text: 'email',
          multilanguage: true,
          fontsize: Dimens.textMedium,
          fontwaight: FontWeight.w500,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
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
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: white,
                  size: 30,
                ),
                onPressed: () {
                  emailController.clear();
                },
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      width: 1,
                      color: colorAccent,
                      style: BorderStyle.solid,
                      strokeAlign: 1)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      width: 1,
                      color: colorAccent,
                      style: BorderStyle.solid,
                      strokeAlign: 1)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      width: 1,
                      color: colorAccent,
                      style: BorderStyle.solid,
                      strokeAlign: 1))),
        ),
        const SizedBox(height: 20),
        MyText(
          text: "mobilenumber",
          fontsize: Dimens.textTitle,
          color: white,
          multilanguage: true,
          fontwaight: FontWeight.w500,
        ),
        const SizedBox(height: 10),
        Consumer<Profileprovider>(builder: (context, profileProvider, child) {
          return IntlPhoneField(
            disableLengthCheck: true,
            textAlignVertical: TextAlignVertical.center,
            autovalidateMode: AutovalidateMode.disabled,
            showCountryFlag: true,
            showDropdownIcon: false,
            initialCountryCode:
                profileprovider.profileModel.result?[0].countryName == "" ||
                        profileprovider.profileModel.result?[0].countryName ==
                            null
                    ? "IN"
                    : profileprovider.profileModel.result?[0].countryName
                            .toString() ??
                        "IN",
            onCountryChanged: (country) {
              countryCode = "+${country.dialCode.toString()}";
              countryName = country.code.replaceAll('+', '');
              printLog('countrycode===> $countryCode');
              printLog('countryName===> $countryName');
            },
            onChanged: (phone) {
              countryName = phone.countryISOCode;
              countryCode = phone.countryCode;
            },
            dropdownTextStyle: Utils.googleFontStyle(
                2, 15, FontStyle.normal, white, FontWeight.w600),
            style: Utils.googleFontStyle(
                2, 15, FontStyle.normal, white, FontWeight.w600),
            controller: phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.phone_android),
              fillColor: colorPrimaryDark,
              filled: true,
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      width: 1,
                      color: colorAccent,
                      style: BorderStyle.solid,
                      strokeAlign: 1)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      width: 1,
                      color: colorAccent,
                      style: BorderStyle.solid,
                      strokeAlign: 1)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      width: 1,
                      color: colorAccent,
                      style: BorderStyle.solid,
                      strokeAlign: 1)),
              hintText: "8254768....",
              hintStyle: Utils.googleFontStyle(
                  4, 15, FontStyle.normal, grey, FontWeight.w500),
            ),
          );
        }),
        const SizedBox(height: 20),
        MyText(
          color: white,
          text: 'dob',
          multilanguage: true,
          fontsize: Dimens.textMedium,
          fontwaight: FontWeight.w500,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: dateController,
          keyboardType: TextInputType.datetime,
          textInputAction: TextInputAction.next,
          style: Utils.googleFontStyle(
              2, 15, FontStyle.normal, white, FontWeight.w600),
          readOnly: true,
          onTap: () {
            dateTimeData(context);
          },
          decoration: InputDecoration(
              hintText: "23/05/1995",
              hintStyle: Utils.googleFontStyle(
                  4, 15, FontStyle.normal, grey, FontWeight.w500),
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
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      width: 1,
                      color: colorAccent,
                      style: BorderStyle.solid,
                      strokeAlign: 1)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      width: 1,
                      color: colorAccent,
                      style: BorderStyle.solid,
                      strokeAlign: 1)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      width: 1,
                      color: colorAccent,
                      style: BorderStyle.solid,
                      strokeAlign: 1))),
        ),
        const SizedBox(height: 20),
        MyText(
          color: white,
          text: 'bio',
          multilanguage: true,
          fontsize: Dimens.textMedium,
          fontwaight: FontWeight.w500,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: bioController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          maxLines: 4,
          style: Utils.googleFontStyle(
              4, 13, FontStyle.normal, white, FontWeight.w600),
          decoration: InputDecoration(
              hintText: "I’ve been a huge fan of you.",
              hintStyle: Utils.googleFontStyle(
                  4, 13, FontStyle.normal, grey, FontWeight.w400),
              prefixIcon: const Icon(Icons.description, color: white),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      width: 1,
                      color: colorAccent,
                      style: BorderStyle.solid,
                      strokeAlign: 1)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      width: 1,
                      color: colorAccent,
                      style: BorderStyle.solid,
                      strokeAlign: 1)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      width: 1,
                      color: colorAccent,
                      style: BorderStyle.solid,
                      strokeAlign: 1))),
        ),
      ],
    );
  }

  Widget submitButton() {
    return Container(
      height: 42,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            primaryGradient,
            colorAccent,
            colorAccent,
            colorAccent,
            colorAccent
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20)),
      child: TextButton(
          onPressed: () async {
            dynamic image;
            if (nameController.text.isEmpty || nameController.text == "") {
              Utils().showToast("Please Enter FullName");
            } else if (emailController.text.isEmpty ||
                emailController.text == "") {
              Utils().showToast("Please Enter Email");
            } else if (phoneController.text.isEmpty ||
                phoneController.text == "") {
              Utils().showToast("Please Enter Mobile Number");
            } else {
              if (isEditing) {
                image = File(imageFile?.path ?? "");
              } else {
                image = File("");
              }
              printLog("update profile successfully ================");
              await updateAPI(
                  widget.professionId ?? "",
                  nameController.text,
                  emailController.text,
                  phoneController.text,
                  dateController.text,
                  bioController.text,
                  countryCode ?? "",
                  countryName ?? "",
                  image);
              printLog(
                  "update profile successfully ${auth.currentUser?.uid}================");

              FirebaseFirestore.instance
                  .collection(FirestoreConstants.pathUserCollection)
                  .doc(auth.currentUser?.uid)
                  // .doc(profileUpdateProvider.updateModel.result?[0].firebaseId)
                  .update({
                FirestoreConstants.email:
                    profileUpdateProvider.updateModel.result?[0].email,
                FirestoreConstants.deviceToken:
                    profileUpdateProvider.updateModel.result?[0].deviceToken,
                FirestoreConstants.name:
                    profileUpdateProvider.updateModel.result?[0].fullName,
                FirestoreConstants.profileurl:
                    profileUpdateProvider.updateModel.result?[0].image,
                FirestoreConstants.createdAt:
                    DateTime.now().millisecondsSinceEpoch.toString(),
                FirestoreConstants.bioData:
                    profileUpdateProvider.updateModel.result?[0].bio,
                FirestoreConstants.username: "",
                FirestoreConstants.mobileNumber:
                    profileUpdateProvider.updateModel.result?[0].mobileNumber,
                FirestoreConstants.chattingWith: null,
              });
            }
          },
          child: MyText(
            text: "save",
            multilanguage: true,
            fontsize: Dimens.textMedium,
            fontwaight: FontWeight.w600,
            color: white,
          )),
    );
  }

  updateAPI(
    String professionId,
    String fullname,
    String email,
    String mobilenumber,
    String dob,
    String bio,
    String countryCode,
    String countryName,
    File image,
  ) async {
    profileUpdateProvider =
        Provider.of<ProfileUpdateProvider>(context, listen: false);
    progressDialog?.show();
    printLog("=======>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<=======");
    await profileUpdateProvider.getUpdateProfile(professionId, fullname, email,
        mobilenumber, dob, bio, countryCode, countryName, image);
    if (profileUpdateProvider.loaded) {
      if (!mounted) return;
      progressDialog?.show();
    } else {
      if (profileUpdateProvider.updateModel.status == 200 &&
          (profileUpdateProvider.updateModel.result?.length ?? 0) > 0) {
        Utils().showToast(profileUpdateProvider.updateModel.message ?? "");
        if (!mounted) return;
        progressDialog?.hide();
        Utils.hideProgress();
        if (widget.typeEdit == "loginType") {
          printLog("Login type is : ${widget.typeEdit}");
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const BottomBar(),
              ));
            },
          );
        } else if (widget.typeEdit == "profileType") {
          printLog("Login type is : ${widget.typeEdit}");
          Navigator.of(context).pop();
        } else {
          printLog("Login No Selected type is : ${widget.typeEdit}");
        }
      } else {
        if (!mounted) return;
        Utils().showToast(profileUpdateProvider.updateModel.message ?? "");
        progressDialog?.hide();
        Utils.hideProgress();
      }
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
