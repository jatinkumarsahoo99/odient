import 'package:dtcameo/pages/bottomscreen/following.dart';
import 'package:dtcameo/pages/bottomscreen/homepage.dart';
import 'package:dtcameo/pages/bottomscreen/inboxscreen.dart';
import 'package:dtcameo/pages/bottomscreen/feed.dart';
import 'package:dtcameo/pages/bottomscreen/settings.dart';
import 'package:dtcameo/provider/generalprovider.dart';
import 'package:dtcameo/provider/profileprovider.dart';
import 'package:dtcameo/utils/adhlper.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/shareperf.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  SharePre sharePre = SharePre();
  int index = 0;
  @override
  void initState() {
    super.initState();
    AdHelper().initGoogleMobileAds();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  _getData() async {
    final generalsetting = Provider.of<GeneralProvider>(context, listen: false);
    final profileProvider =
        Provider.of<Profileprovider>(context, listen: false);
    pushNotification();
    if (!mounted) return;
    if (Constant.userId != null) {
      await profileProvider.getProfile(context, Constant.userId ?? "");
    } else {
      Utils.updatePremium("0");
      Utils.loadAds(context);
    }
    if (!mounted) return;
    await generalsetting.getGenralSetting(context);
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  pushNotification() async {
    Constant.oneSignalAppId = await sharePre.read(Constant.oneSignalAppIdKey);
    printLog("OneSignal===>${Constant.oneSignalAppId}");
    /*  Push Notification Method OneSignal Start */
    if (!kIsWeb) {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      // Initialize OneSignal
      printLog("OneSignal PushNotification===> ${Constant.oneSignalAppId}");
      OneSignal.initialize(Constant.oneSignalAppId ?? "");
      OneSignal.Notifications.requestPermission(false);
      OneSignal.Notifications.addPermissionObserver((state) {
        printLog("Has permission ==> $state");
      });
      OneSignal.User.pushSubscription.addObserver((state) {
        printLog(
            "pushSubscription state ==> ${state.current.jsonRepresentation()}");
      });
      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        /// preventDefault to not display the notification
        event.preventDefault();
        // Do async work
        /// notification.display() to display after preventing default
        event.notification.display();
      });
    }
  }

  onChange(int item) {
    AdHelper.showFullscreenAd(context, Constant.interstialAdType, () async {
      setState(() {
        index = item;
      });
    });
  }

  List<Widget> screen = [
    const HomePage(),
    const Feed(),
    const InboxScreen(),
    const Following(),
    const Settings()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: screen.elementAt(index),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Utils.showBannerAd(context),
          BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: "Browse",
                  backgroundColor: colorPrimaryDark),
              BottomNavigationBarItem(
                  icon: Icon(Icons.explore),
                  label: "Feed",
                  backgroundColor: colorPrimaryDark),
              BottomNavigationBarItem(
                  icon: Icon(Icons.inbox),
                  label: "Inbox",
                  backgroundColor: colorPrimaryDark),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border_rounded),
                  label: "Following",
                  backgroundColor: colorPrimaryDark),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "Settings",
                  backgroundColor: colorPrimaryDark),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: index,
            onTap: onChange,
            backgroundColor: colorPrimaryDark,
            iconSize: 25,
            selectedIconTheme: const IconThemeData(color: colorAccent),
            selectedFontSize: 12,
            selectedItemColor: colorAccent,
            unselectedIconTheme: const IconThemeData(color: grey),
            unselectedItemColor: grey,
          ),
        ],
      ),
    );
  }
}
