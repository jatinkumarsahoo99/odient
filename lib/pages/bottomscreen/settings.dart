import 'package:dtcameo/pages/aboutinformation.dart';
import 'package:dtcameo/pages/allorders.dart';
import 'package:dtcameo/pages/profile.dart';
import 'package:dtcameo/pages/login.dart';
import 'package:dtcameo/pages/subscription/subscriptionhistroy.dart';
import 'package:dtcameo/pages/subscription/subscriptionpage.dart';
import 'package:dtcameo/pages/usertransactionhistory.dart';
import 'package:dtcameo/pages/videorequestpage.dart';
import 'package:dtcameo/provider/profileprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/shareperf.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mynetworkimmage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SharePre sharePre = SharePre();
  String? isArtist;
  Profileprovider profileprovider = Profileprovider();

  @override
  void initState() {
    profileprovider = Provider.of<Profileprovider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
      getProFileA();
    });
    super.initState();
  }

  Future<void> getProFileA() async {
    profileprovider.setLoding(true);
    if (Constant.userId != null) {
      await profileprovider.getProfile(context, Constant.userId ?? "");
    }
    await profileprovider.getPage();
  }

  getData() async {
    isArtist = await sharePre.read('isartist');
    Constant.currencySymbol = await sharePre.read('currency_code');

    printLog("User buy Arist or not : $isArtist");
  }

  @override
  void dispose() {
    profileprovider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      appBar: AppBar(
        backgroundColor: colorPrimaryDark,
        iconTheme: const IconThemeData(color: white),
        title: MyText(
          text: 'setting',
          multilanguage: true,
          fontsize: Dimens.textBig,
          color: white,
          fontwaight: FontWeight.w600,
        ),
      ),
      body: settingDataShow(),
    );
  }

  Widget settingDataShow() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Constant.userId == null
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Profile(),
                      ));
            },
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: white,
                    size: 20,
                  ),
                  const SizedBox(width: 20),
                  MyText(
                    color: white,
                    text: 'myprofile',
                    multilanguage: true,
                    fontsize: Dimens.textTitle,
                    fontwaight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Consumer<Profileprovider>(builder: (context, profileProvider, child) {
            return Column(children: [
              isArtist == "0"
                  ? Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Constant.userId == null
                                ? Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  ))
                                : Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const AllOrders(),
                                  ));
                          },
                          child: SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.shopping_cart,
                                  color: white,
                                  size: 20,
                                ),
                                const SizedBox(width: 20),
                                MyText(
                                  color: white,
                                  text: 'allorders',
                                  multilanguage: true,
                                  fontsize: Dimens.textTitle,
                                  fontwaight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )
                  : const SizedBox.shrink(),
              isArtist == "1"
                  ? Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Constant.userId == null
                                ? Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  ))
                                : Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const VideoRequestPage(),
                                  ));
                          },
                          child: SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.request_page_outlined,
                                  color: white,
                                  size: 20,
                                ),
                                const SizedBox(width: 20),
                                MyText(
                                  color: white,
                                  text: 'videorequestlist',
                                  multilanguage: true,
                                  fontsize: Dimens.textTitle,
                                  fontwaight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )
                  : const SizedBox.shrink(),
            ]);
          }),
          buildGetPages(),
          InkWell(
            onTap: () {
              Constant.userId == null
                  ? Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Login(),
                    ))
                  : Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SubscriptionPage(),
                    ));
            },
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  const Icon(
                    Icons.subscriptions_outlined,
                    color: white,
                    size: 20,
                  ),
                  const SizedBox(width: 20),
                  MyText(
                    color: white,
                    text: 'subscription',
                    multilanguage: true,
                    fontsize: Dimens.textTitle,
                    fontwaight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              Constant.userId == null
                  ? Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Login(),
                    ))
                  : Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SubscriptionHistroy(),
                    ));
            },
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  const Icon(
                    Icons.history,
                    color: white,
                    size: 20,
                  ),
                  const SizedBox(width: 20),
                  MyText(
                    color: white,
                    text: 'supscriptionhistory',
                    multilanguage: true,
                    fontsize: Dimens.textTitle,
                    fontwaight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              Constant.userId == null
                  ? Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Login(),
                    ))
                  : Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UserTransactionHistory(),
                    ));
            },
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  const Icon(
                    Icons.history,
                    color: white,
                    size: 20,
                  ),
                  const SizedBox(width: 20),
                  MyText(
                    color: white,
                    text: 'usertransacationhistory',
                    multilanguage: true,
                    fontsize: Dimens.textTitle,
                    fontwaight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              _languageChangeDialog();
            },
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  const Icon(
                    Icons.translate_rounded,
                    color: white,
                    size: 20,
                  ),
                  const SizedBox(width: 20),
                  MyText(
                    color: white,
                    text: 'chng_language',
                    multilanguage: true,
                    fontsize: Dimens.textTitle,
                    fontwaight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              Constant.userId != null
                  ? _logoutButton()
                  : Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      )
                      .then(
                        (value) => getProFileA(),
                      );
            },
            child: Constant.userId == null
                ? SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.login,
                          color: colorAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 20),
                        MyText(
                          color: colorAccent,
                          text: 'login',
                          multilanguage: true,
                          fontsize: Dimens.textTitle,
                          fontwaight: FontWeight.w400,
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout_outlined,
                          color: white,
                          size: 20,
                        ),
                        const SizedBox(width: 20),
                        MyText(
                          color: white,
                          text: 'logout',
                          multilanguage: true,
                          fontsize: Dimens.textTitle,
                          fontwaight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              Constant.userId != null
                  ? _deleteAccountButton()
                  : Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      )
                      .then(
                        (value) => getProFileA(),
                      );
            },
            child: Constant.userId != null
                ? SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_outline_outlined,
                          color: white,
                          size: 20,
                        ),
                        const SizedBox(width: 20),
                        MyText(
                          color: white,
                          text: 'delete_account',
                          multilanguage: true,
                          fontsize: Dimens.textTitle,
                          fontwaight: FontWeight.w400,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 10),
          Constant.userBuy == "1"
              ? subscriptionDetails()
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  /* Get Pages */

  buildGetPages() {
    return Consumer<Profileprovider>(
        builder: (context, profileProvider, child) {
      if (profileProvider.pageModel.status == 200 &&
          (profileProvider.pageModel.result?.length ?? 0) > 0) {
        return AlignedGridView.count(
          crossAxisCount: 1,
          itemCount: profileprovider.pageModel.result?.length ?? 0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AboutInFormation(
                          appBarTitle:
                              profileprovider.pageModel.result?[index].title ??
                                  "",
                          loadURL:
                              profileprovider.pageModel.result?[index].url ??
                                  ""),
                    ));
                  },
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        MyNetworkImage(
                          imageUrl:
                              profileprovider.pageModel.result?[index].icon ??
                                  "",
                          fit: BoxFit.fill,
                          imgHeight: 20,
                          imgWidth: 20,
                        ),
                        const SizedBox(width: 20),
                        MyText(
                          color: white,
                          text:
                              profileprovider.pageModel.result?[index].title ??
                                  "",
                          fontsize: Dimens.textTitle,
                          fontwaight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

/* Subscription Details Start */
  Widget subscriptionDetails() {
    return Consumer<Profileprovider>(
        builder: (context, profileProvider, child) {
      if (profileProvider.profileModel.status == 200 &&
          (profileProvider.profileModel.result?.length ?? 0) > 0) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0.7,
              child: Container(
                height: 95,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [colorPrimary, colorAccent],
                        tileMode: TileMode.mirror,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    MyText(
                      color: white,
                      text: "currentplan",
                      multilanguage: true,
                      fontsize: Dimens.textTitle,
                      fontwaight: FontWeight.w500,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        MyText(
                          color: yellow,
                          text:
                              "${Constant.currencySymbol} ${profileProvider.profileModel.result?[0].packagePrice.toString() ?? "0"} /m",
                          fontsize: Dimens.textTitle,
                          fontwaight: FontWeight.w800,
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      decoration: BoxDecoration(
                        color: yellow,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: MyText(
                          text: "pro",
                          multilanguage: true,
                          fontstyle: FontStyle.normal,
                          fontsize: Dimens.textMedium,
                          letterSpacing: 3,
                          color: colorPrimaryDark,
                          fontwaight: FontWeight.w700),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Constant.userId == null
                            ? Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              )
                            : Constant.userBuy == "1"
                                ? Utils().showToast("You Alredy buy the")
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SubscriptionPage()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: colorAccent,
                          minimumSize: const Size(133, 31),
                          shadowColor: white,
                          elevation: 0),
                      child: MyText(
                        text: "upgradepremium",
                        multilanguage: true,
                        fontstyle: FontStyle.normal,
                        fontsize: Dimens.textSmall,
                        color: white,
                        fontwaight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

/* End */

  _languageChangeDialog() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isDismissible: true,
      showDragHandle: true,
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, state) {
            return DraggableScrollableSheet(
              initialChildSize: 0.55,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: colorPrimary,
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          color: white,
                          text: "chng_language",
                          multilanguage: true,
                          textalign: TextAlign.start,
                          fontsize: Dimens.textExtraBig,
                          fontwaight: FontWeight.bold,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal,
                        ),

                        /* English */
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: MediaQuery.sizeOf(context).width,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: white,
                                          style: BorderStyle.solid)),
                                  child: _buildLanguage(
                                    langName: "English",
                                    onClick: () {
                                      state(() {});
                                      LocaleNotifier.of(context)?.change('en');
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),

                                /* Hindi */
                                const SizedBox(height: 20),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: MediaQuery.sizeOf(context).width,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: white,
                                          style: BorderStyle.solid)),
                                  child: _buildLanguage(
                                    langName: "Hindi",
                                    onClick: () {
                                      state(() {});
                                      LocaleNotifier.of(context)?.change('hi');
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLanguage({
    required String langName,
    required Function() onClick,
  }) {
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(5),
      child: MyText(
        color: white,
        text: langName,
        textalign: TextAlign.center,
        fontsize: Dimens.textBig,
        maxline: 1,
        overflow: TextOverflow.ellipsis,
        fontwaight: FontWeight.w500,
        fontstyle: FontStyle.normal,
      ),
    );
  }

  _logoutButton() {
    return showModalBottomSheet(
      barrierColor: transparent,
      context: context,
      showDragHandle: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: colorPrimary,
      builder: (context) {
        return SizedBox(
          height: 312,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              children: [
                MyText(
                  text: "logout",
                  multilanguage: true,
                  fontsize: Dimens.textBig,
                  color: white,
                  fontwaight: FontWeight.w800,
                ),
                const SizedBox(height: 20),
                MyText(
                  text: "sure",
                  multilanguage: true,
                  fontsize: Dimens.textTitle,
                  color: white,
                  fontwaight: FontWeight.w500,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () async {
                    /* Clear Local Data Start */
                    await sharePre.clear();
                    profileprovider.clearProvider();
                    FirebaseAuth.instance.signOut();
                    await GoogleSignIn().signOut();
                    Constant.userId = null;
                    isArtist = null;
                    Constant.userBuy = null;
                    /* Clear Local Data End */

                    Navigator.of(context).pop();
                    if (!mounted) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorAccent,
                      minimumSize: Size(MediaQuery.of(context).size.width, 54)),
                  child: MyText(
                    text: "yeslogout",
                    multilanguage: true,
                    fontsize: Dimens.textBig,
                    color: white,
                    fontwaight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: transparent,
                      side: const BorderSide(
                          width: 1, color: white, style: BorderStyle.solid),
                      minimumSize: Size(MediaQuery.of(context).size.width, 54)),
                  child: MyText(
                    text: "cancel",
                    multilanguage: true,
                    fontsize: Dimens.textBig,
                    color: white,
                    fontwaight: FontWeight.w800,
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).then((value) async {
      Utils.loadAds(context);
      setState(() {});
    });
  }

  _deleteAccountButton() {
    showModalBottomSheet(
      barrierColor: transparent,
      context: context,
      showDragHandle: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: colorPrimary,
      builder: (context) {
        return SizedBox(
          height: 312,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              children: [
                MyText(
                  text: "delete_account",
                  multilanguage: true,
                  fontsize: Dimens.textBig,
                  color: white,
                  fontwaight: FontWeight.w800,
                ),
                const SizedBox(height: 20),
                MyText(
                  text: "account_delete",
                  multilanguage: true,
                  fontsize: Dimens.textTitle,
                  maxline: 2,
                  overflow: TextOverflow.ellipsis,
                  color: white,
                  fontwaight: FontWeight.w500,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () async {
                    /* Clear Local Data Start */
                    await sharePre.clear();
                    profileprovider.clearProvider();
                    FirebaseAuth.instance.signOut();
                    await GoogleSignIn().signOut();
                    Constant.userId = null;
                    isArtist = null;
                    Constant.userBuy = null;

                    /* Clear Local Data End */
                    Navigator.of(context).pop();
                    if (!mounted) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorAccent,
                      minimumSize: Size(MediaQuery.of(context).size.width, 54)),
                  child: MyText(
                    text: "yesdelete",
                    multilanguage: true,
                    fontsize: Dimens.textBig,
                    color: white,
                    fontwaight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: transparent,
                      side: const BorderSide(
                          width: 1, color: white, style: BorderStyle.solid),
                      minimumSize: Size(MediaQuery.of(context).size.width, 54)),
                  child: MyText(
                    text: "cancel",
                    multilanguage: true,
                    fontsize: Dimens.textBig,
                    color: white,
                    fontwaight: FontWeight.w800,
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).then((value) async {
      Utils.loadAds(context);
      setState(() {});
    });
  }
}
