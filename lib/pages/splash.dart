import 'package:dtcameo/pages/bottombar.dart';
import 'package:dtcameo/pages/intro.dart';
import 'package:dtcameo/provider/generalprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/shareperf.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/myimage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String? seen;

  @override
  Widget build(BuildContext context) {
    navigatSecondScreen();
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: MyImage(
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          imagePath: "odient.png",
        ),
      ),
    );
  }

  Future<void> navigatSecondScreen() async {
    final generalProvider =
        Provider.of<GeneralProvider>(context, listen: false);
    await generalProvider.getGenralSetting(context);
    Utils.getCurrencySymbol();
    SharePre sharePre = SharePre();
    seen = await sharePre.read("seen") ?? "0";
    printLog("Your seen is $seen");
    Constant.userId = await sharePre.read("userid");
    if (seen == "1") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BottomBar(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Intro(),
        ),
      );
    }
  }
}
