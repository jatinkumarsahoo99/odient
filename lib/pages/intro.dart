import 'package:dtcameo/pages/bottombar.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/myimage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MyImage(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
              imagePath: "splash-img.png"),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*Row(
                  children: [
                    MyText(
                      text: "appname",
                      color: white,
                      multilanguage: true,
                      fontsize: Dimens.textExtraBig,
                      fontFamily: "JejuHallasan",
                      fontwaight: FontWeight.w400,
                    ),
                    const SizedBox(width: 30),
                    const MyImage(
                      width: 33,
                      height: 33,
                      imagePath: "appicon.png",
                      isAppicon: true,
                    )
                  ],
                ),*/
                const SizedBox(height: 30),
                MyText(
                  text: "title",
                  color: white,
                  multilanguage: true,
                  fontsize: Dimens.textTitle,
                  maxline: 2,
                  overflow: TextOverflow.ellipsis,
                  fontwaight: FontWeight.w500,
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    Utils.setFirstTime("0");
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const BottomBar(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 42,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [
                                primaryGradient,
                                primaryGradient,
                                colorAccent,
                                colorAccent,
                                colorAccent,
                                colorAccent
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(20)),
                      child: MyText(
                        text: "button",
                        color: white,
                        multilanguage: true,
                        fontsize: Dimens.textMedium,
                        fontwaight: FontWeight.w600,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
