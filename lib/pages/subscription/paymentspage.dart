import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:dtcameo/pages/makepaymentpage.dart';
import 'package:dtcameo/provider/profileprovider.dart';
import 'package:dtcameo/provider/profileupdateprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/shareperf.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mynetworkimmage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final String? id, fees, name, reuestId, image, professionId;
  const PaymentPage(
      {super.key,
      required this.id,
      required this.fees,
      required this.name,
      required this.image,
      required this.reuestId,
      required this.professionId});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _emailController = TextEditingController();
  String? fullname, mobilenumber, dob, bio, countryCode, countryName;
  dynamic imageFile;
  SharePre sharePre = SharePre();
  int activeStep = 2;
  Profileprovider profileprovider = Profileprovider();

  @override
  void initState() {
    profileprovider = Provider.of<Profileprovider>(context, listen: false);
    printLog(widget.id ?? "");
    printLog(widget.fees ?? "");
    _getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getApi();
    });
    super.initState();
  }

  getApi() async {
    profileprovider.setLoding(true);
    await profileprovider.getProfile(context, Constant.userId ?? "");
  }

  _getData() async {
    fullname = await sharePre.read("username");
    mobilenumber = await sharePre.read("mobilenumber");
    dob = await sharePre.read("dob");
    bio = await sharePre.read("bio");
    countryCode = await sharePre.read("countrycode");
    imageFile = await sharePre.read("image");
    _emailController.text = await sharePre.read("useremail");
    printLog("${_emailController.text.toString()} ==========================");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      appBar: AppBar(
        leading: Utils.backButton(context),
        backgroundColor: colorPrimaryDark,
        iconTheme: const IconThemeData(color: white),
        title: MyText(
          text: "payment",
          multilanguage: true,
          fontsize: Dimens.textlargeBig,
          fontwaight: FontWeight.w600,
          color: white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(alignment: Alignment.center, child: profileDetail()),
            const SizedBox(height: 10),
            stepsData(),
            const SizedBox(height: 30),
            MyText(
              color: white,
              text: 'emailadress',
              multilanguage: true,
              fontsize: Dimens.textTitle,
              fontwaight: FontWeight.w500,
            ),
            const SizedBox(height: 10),
            MyText(
              color: white,
              text: 'send',
              multilanguage: true,
              fontsize: Dimens.textSmall,
              fontwaight: FontWeight.w400,
            ),
            const SizedBox(height: 10),
            textFiled(),
            const SizedBox(height: 40),
            MyText(
              color: white,
              text: 'order',
              multilanguage: true,
              fontsize: Dimens.textBig,
            ),
            const SizedBox(height: 20),
            orderSummary(),
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MakePaymentStage(
                      fees: widget.fees ?? "",
                      id: widget.id ?? "",
                      requestId: widget.reuestId,
                    ),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [primaryGradient, colorAccent],
                  ),
                ),
                child: const MyText(
                  color: white,
                  text: 'proceed',
                  multilanguage: true,
                  fontwaight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderSummary() {
    return Consumer<Profileprovider>(
      builder: (context, profileProvider, child) {
        if (profileProvider.profileLoding) {
          return orderShimmer();
        } else {
          if (profileProvider.profileModel.status == 200 &&
              (profileProvider.profileModel.result?.length ?? 0) > 0) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      color: white,
                      text: 'subtotal',
                      multilanguage: true,
                      fontsize: Dimens.textBig,
                    ),
                    MyText(
                      color: colorAccent,
                      text:
                          "${Constant.currencySymbol} ${profileProvider.profileModel.result?[0].fees.toString() ?? ""}",
                      fontsize: Dimens.textBig,
                      fontwaight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const DottedLine(
                    dashLength: 10,
                    dashGapLength: 5,
                    lineThickness: 1,
                    dashColor: colorAccent),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      color: white,
                      text: 'total',
                      multilanguage: true,
                      fontsize: Dimens.textBig,
                    ),
                    MyText(
                      color: colorAccent,
                      text:
                          "${Constant.currencySymbol} ${profileProvider.profileModel.result?[0].fees.toString() ?? ""}",
                      fontsize: Dimens.textBig,
                      fontwaight: FontWeight.bold,
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget orderShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomWidget.roundcorner(height: 25, width: 160),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomWidget.roundcorner(height: 20, width: 160),
            CustomWidget.roundcorner(height: 20, width: 100),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomWidget.roundcorner(height: 20, width: 160),
            CustomWidget.roundcorner(height: 20, width: 100),
          ],
        ),
        CustomWidget.roundcorner(
            height: 20, width: MediaQuery.sizeOf(context).width),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomWidget.roundcorner(height: 20, width: 160),
            CustomWidget.roundcorner(height: 20, width: 100),
          ],
        )
      ],
    );
  }

  Widget textFiled() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          boxShadow: const [BoxShadow(color: colorAccent, blurRadius: 4)],
          color: colorPrimary,
          borderRadius: BorderRadius.circular(34)),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.go,
              style: Utils.googleFontStyle(
                  4, 13, FontStyle.normal, white, FontWeight.w600),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "You@example.com",
                hintStyle: Utils.googleFontStyle(
                    4, 13, FontStyle.normal, white, FontWeight.w400),
              ),
            ),
          ),
          Consumer<ProfileUpdateProvider>(
            builder: (context, profileUpdateProvider, child) {
              return ElevatedButton(
                onPressed: () async {
                  if (_emailController.text.isEmpty) {
                    Utils().showToast("Email is Required..");
                  } else {
                    await profileUpdateProvider.getU(
                        widget.professionId ?? "",
                        fullname ?? "",
                        _emailController.text,
                        mobilenumber ?? "",
                        dob ?? "",
                        bio ?? "",
                        countryCode ?? "",
                        countryName ?? "",
                        imageFile ?? File(''));
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: colorAccent,
                    minimumSize: const Size(121, 53)),
                child: MyText(
                  text: "submit",
                  multilanguage: true,
                  fontsize: Dimens.textBigSmall,
                  color: white,
                  fontwaight: FontWeight.w500,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget profileDetail() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: MyNetworkImage(
            imgWidth: 100,
            imgHeight: 100,
            imageUrl: widget.image ?? "",
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(width: 15),
        MyText(
          color: colorAccent,
          text: widget.name ?? "",
          fontsize: Dimens.textMedium,
          fontwaight: FontWeight.w800,
        ),
      ],
    );
  }

  Widget stepsData() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 34,
              width: 34,
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: grey),
              child: MyText(
                text: "1",
                fontsize: Dimens.textTitle,
                color: white,
                fontwaight: FontWeight.w700,
              ),
            ),
            MyText(
              text: "writeyourrequest",
              multilanguage: true,
              fontsize: Dimens.textSmall,
              maxline: 2,
              overflow: TextOverflow.ellipsis,
              color: white,
              fontwaight: FontWeight.w600,
            )
          ],
        ),
        const Expanded(
          child: DottedLine(
              dashLength: 10,
              dashGapLength: 5,
              lineThickness: 1,
              dashColor: grey),
        ),
        Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activeStep == 2 ? colorAccent : grey),
              child: MyText(
                text: "2",
                fontsize: Dimens.textTitle,
                color: white,
                fontwaight: FontWeight.w700,
              ),
            ),
            MyText(
              text: "makepayment",
              multilanguage: true,
              fontsize: Dimens.textSmall,
              maxline: 2,
              overflow: TextOverflow.ellipsis,
              color: activeStep == 2 ? colorAccent : white,
              fontwaight: FontWeight.w600,
            )
          ],
        )
      ],
    );
  }
}
