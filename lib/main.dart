import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtcameo/firebase_options.dart';
import 'package:dtcameo/pages/splash.dart';
import 'package:dtcameo/provider/artistprovider.dart';
import 'package:dtcameo/provider/categoryprovider.dart';
import 'package:dtcameo/provider/chatprovider.dart';
import 'package:dtcameo/provider/detilsprovider.dart';
import 'package:dtcameo/provider/followlistprovider.dart';
import 'package:dtcameo/provider/generalprovider.dart';
import 'package:dtcameo/provider/histroyprovider.dart';
import 'package:dtcameo/provider/homeprovider.dart';
import 'package:dtcameo/provider/latestvideoprovider.dart';
import 'package:dtcameo/provider/notificationprovider.dart';
import 'package:dtcameo/provider/orderprovider.dart';
import 'package:dtcameo/provider/paymentoptionprovider.dart';
import 'package:dtcameo/provider/professionprovider.dart';
import 'package:dtcameo/provider/profileprovider.dart';
import 'package:dtcameo/provider/profileupdateprovider.dart';
import 'package:dtcameo/provider/reviewprovider.dart';
import 'package:dtcameo/provider/rquestprovider.dart';
import 'package:dtcameo/provider/searchprovider.dart';
import 'package:dtcameo/provider/sectiondetailprovider.dart';
import 'package:dtcameo/provider/subscriptionprovider.dart';
import 'package:dtcameo/provider/uploadvideoprovider.dart';
import 'package:dtcameo/provider/videorequestprovider.dart';
import 'package:dtcameo/provider/videoviewprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Locales.init([
    'en',
    'hi'
  ]);
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => GeneralProvider()),
      ChangeNotifierProvider(create: (context) => Homeprovider()),
      ChangeNotifierProvider(create: (context) => Profileprovider()),
      ChangeNotifierProvider(create: (context) => Searchprovider()),
      ChangeNotifierProvider(create: (context) => Detilsprovider()),
      ChangeNotifierProvider(create: (context) => FollowListProvider()),
      ChangeNotifierProvider(create: (context) => NotificationProvider()),
      ChangeNotifierProvider(create: (context) => PaymentOptionProvider()),
      ChangeNotifierProvider(create: (context) => ReviewProvider()),
      ChangeNotifierProvider(create: (context) => SectionDetailsProvider()),
      ChangeNotifierProvider(create: (context) => VideoRequestProvider()),
      ChangeNotifierProvider(create: (context) => OrderProvider()),
      ChangeNotifierProvider(create: (context) => ProfileUpdateProvider()),
      ChangeNotifierProvider(create: (context) => SubscriptionProvider()),
      ChangeNotifierProvider(create: (context) => LatestVideoProvider()),
      ChangeNotifierProvider(create: (context) => CategoryProvider()),
      ChangeNotifierProvider(create: (context) => VideoViewProvider()),
      ChangeNotifierProvider(create: (context) => HistroyProvider()),
      ChangeNotifierProvider(create: (context) => ProfessionProvider()),
      ChangeNotifierProvider(create: (context) => RequestProvider()),
      ChangeNotifierProvider(create: (context) => UploadVideoProvider()),
      ChangeNotifierProvider(create: (context) => ArtistProvider()),
      ChangeNotifierProvider(
          create: (context) => ChatProvider(
              firebaseFirestore: firebaseFirestore,
              firebaseStorage: firebaseStorage)),
    ],
    child: const MyApp(),
  ));
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(builder: (locale) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.unknown
        }),
        title: 'Odient',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: colorPrimaryDark),
          useMaterial3: true,
        ),
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
        localeResolutionCallback:
            (Locale? locale, Iterable<Locale> supportedLocales) {
          return locale;
        },
        home: const Splash(),
      );
    });
  }
}
