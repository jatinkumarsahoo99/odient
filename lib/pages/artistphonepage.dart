import 'package:dtcameo/pages/artistotppage.dart';
import 'package:dtcameo/pages/artistregisterpage.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/myimage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ArtistPhonePage extends StatefulWidget {
  const ArtistPhonePage({super.key});

  @override
  State<ArtistPhonePage> createState() => _ArtistPhonePageState();
}

class _ArtistPhonePageState extends State<ArtistPhonePage> {
  String? countryCode = "";
  String? mobileNumber = '';
  String? countryName = '';
  final TextEditingController _phoneController = TextEditingController();
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
                  phoneField(),
                  const SizedBox(height: 40),
                  otpBtn(),
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
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      googleButton(),
                      const SizedBox(width: 30),
                      appleButton(),
                    ],
                  ),
                  // const SizedBox(height: 40),
                  // celeLoginBtn(),
                  const SizedBox(height: 40),
                  account(),
                  const SizedBox(height: 40),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget phoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: "mobilenumber",
          fontsize: Dimens.textTitle,
          color: white,
          multilanguage: true,
          fontwaight: FontWeight.w500,
        ),
        const SizedBox(height: 10),
        IntlPhoneField(
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
            mobileNumber = phone.completeNumber;
            printLog('===>mobileNumber $mobileNumber');
            countryName = phone.countryISOCode;
            countryCode = phone.countryCode;
          },
          dropdownTextStyle: Utils.googleFontStyle(
              4, 12, FontStyle.normal, white, FontWeight.w400),
          style: Utils.googleFontStyle(
              4, 12, FontStyle.normal, white, FontWeight.w400),
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
                  2, 12, FontStyle.normal, grey, FontWeight.w500)),
        )
      ],
    );
  }

  Widget appleButton() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: white,
          border: Border.all(
              width: 1, color: colorAccent, style: BorderStyle.solid)),
      child: const Icon(
        Icons.apple,
        size: 26,
      ),
    );
  }

  Widget googleButton() {
    return Container(
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
    );
  }

  // Widget celeLoginBtn() {
  //   return ElevatedButton(
  //       onPressed: () {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => const CelebrityLoginPage(),
  //             ));
  //       },
  //       style: ElevatedButton.styleFrom(
  //           backgroundColor: orange,
  //           minimumSize: const Size(double.maxFinite, 50)),
  //       child: MyText(
  //         text: "loginifyouarealredyacelebrity",
  //         multilanguage: true,
  //         fontstyle: FontStyle.normal,
  //         fontsize: Dimens.textTitle,
  //         fontwaight: FontWeight.w700,
  //         color: colorPrimaryDark,
  //       ));
  // }

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
            text: "signup",
            multilanguage: true,
            fontsize: Dimens.textTitle,
            color: colorAccent,
          ),
        ),
      ],
    );
  }

  Widget otpBtn() {
    return ElevatedButton(
        onPressed: () {
          if (_phoneController.text.isEmpty) {
            Utils().showToast("Phone number is required.");
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArtistOtpPage(
                  mobileNumber: _phoneController.text.toString(),
                  countryCode: countryCode ?? "",
                  countryName: countryName ?? "",
                ),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: colorAccent,
            minimumSize: const Size(double.maxFinite, 50)),
        child: MyText(
          text: "sendotp",
          multilanguage: true,
          fontstyle: FontStyle.normal,
          fontsize: Dimens.textTitle,
          fontwaight: FontWeight.w700,
          color: white,
        ));
  }
}
