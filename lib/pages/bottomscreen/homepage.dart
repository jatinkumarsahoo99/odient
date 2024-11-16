import 'package:dtcameo/chatmodel/model/sectionmodel.dart' as list;
import 'package:dtcameo/chatmodel/model/sectionmodel.dart';
import 'package:dtcameo/pages/viewall.dart';
import 'package:dtcameo/pages/login.dart';
import 'package:dtcameo/pages/paymentoption.dart';
import 'package:dtcameo/pages/professionpage.dart';
import 'package:dtcameo/pages/search.dart';
import 'package:dtcameo/pages/detailspage.dart';
import 'package:dtcameo/pages/notificationpage.dart';
import 'package:dtcameo/pages/videoplayer.dart';
import 'package:dtcameo/provider/homeprovider.dart';
import 'package:dtcameo/utils/adhlper.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mynetworkimmage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  late Homeprovider homeprovider;

  @override
  void initState() {
    homeprovider = Provider.of<Homeprovider>(context, listen: false);
    printLog("Your Courrency code is : ${Constant.currencySymbol}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAPi();
    });
    super.initState();
  }

  Future<void> getAPi() async {
    homeprovider.setLoding(true);
    await homeprovider.sectionData();
    await homeprovider.getPackages();
  }

  @override
  void dispose() {
    homeprovider.clearProvider();
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
          text: "browse",
          multilanguage: true,
          fontsize: Dimens.textBig,
          fontwaight: FontWeight.w600,
          color: white,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ));
              },
              icon: const Icon(Icons.notifications))
        ],
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchItem(),
            const SizedBox(height: 25),
            /* Remaining Sections */
            Consumer<Homeprovider>(
              builder: (context, homeProvider, child) {
                if (homeProvider.loaded) {
                  return sectionShimmer();
                } else {
                  if (homeProvider.sectionModel.result != null) {
                    return setSectionByType(homeProvider.sectionModel.result);
                  } else {
                    return const SizedBox.shrink();
                  }
                }
              },
            ),
            SizedBox(
              height: 150,
              child: subscription(),
            ),
          ],
        ),
      ),
    );
  }

  /* Section wise data show */
/* Sections START ************** */
  Widget setSectionByType(List<list.Result>? sectionList) {
    return ListView.builder(
      itemCount: sectionList?.length ?? 0,
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        if (sectionList?[index].data != null &&
            (sectionList?[index].data?.length ?? 0) > 0) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleViewAll(
                sectionList: sectionList,
                index: index,
                onViewAllClick: () {
                  if ((sectionList?[index].viewAll ?? 0) == 1) {
                    if (!mounted) return;
                    AdHelper.interstitialAd(
                      context,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ViewAll(
                                sectionid:
                                    sectionList?[index].id.toString() ?? "",
                                title: sectionList?[index].title ?? "",
                                type: sectionList?[index].type.toString() ?? "",
                                screenLayOut:
                                    sectionList?[index].screenLayout ?? "",
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: getRemainingDataHeight(
                  sectionList?[index].screenLayout ?? "",
                ),
                child: setSectionData(sectionList: sectionList, index: index),
              ),
              const SizedBox(height: 20),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

/* End */

/* Section list title show */
  Widget _buildTitleViewAll({
    required List<list.Result>? sectionList,
    required int index,
    required Function()? onViewAllClick,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: MyText(
                color: white,
                text: sectionList?[index].title.toString() ?? "",
                textalign: TextAlign.start,
                fontsize: Dimens.textTitle,
                fontwaight: FontWeight.w600,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                fontstyle: FontStyle.normal,
              ),
            ),
          ),
          if ((sectionList?[index].viewAll ?? 0) == 1)
            InkWell(
              onTap: onViewAllClick,
              child: MyText(
                text: 'see',
                color: colorAccent,
                multilanguage: true,
                fontsize: Dimens.textMedium,
                fontwaight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
/* End */

/* Section Wise data show */
  Widget setSectionData(
      {required List<list.Result>? sectionList, required int index}) {
    if ((sectionList?[index].screenLayout ?? "") == "artist round") {
      return artistRound(sectionList?[index].data);
    } else if ((sectionList?[index].screenLayout ?? "") == "artist landscape") {
      return artistLandscape(sectionList?[index].data);
    } else if ((sectionList?[index].screenLayout ?? "") == "artist portrait") {
      return artistPortrait(sectionList?[index].data);
    } else if ((sectionList?[index].screenLayout ?? "") == "profession") {
      return profession(sectionList?[index].data);
    } else if ((sectionList?[index].screenLayout ?? "") == "portrait") {
      return videoPortrait(sectionList?[index].data);
    } else if ((sectionList?[index].screenLayout ?? "") == "landscape") {
      return videoLandscape(sectionList?[index].data);
    } else if ((sectionList?[index].screenLayout ?? "") == "square") {
      return videoSquare(sectionList?[index].data);
    } else {
      return const SizedBox.shrink();
    }
  }

/* End */

  /* Section Shimmer */
  Widget sectionShimmer() {
    return ListView.builder(
      itemCount: 5, // itemCount must be greater than 5
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return setHomeSections(context, "artist round");
        } else if (index == 1) {
          return setHomeSections(context, "artist landscape");
        } else if (index == 2) {
          return setHomeSections(context, "artist portrait");
        } else if (index == 3) {
          return setHomeSections(context, "portrait");
        } else if (index == 4) {
          return setHomeSections(context, "artist landscape");
        } else if (index == 5) {
          return setHomeSections(context, "artist round");
        } else {
          return setHomeSections(context, "profession");
        }
      },
    );
  }

/* End */
  Widget setHomeSections(context, String layoutType) {
    return Column(
      children: [
        const SizedBox(height: 12),
        if (layoutType == "profession") professionShimmer(),
        if (layoutType == "artist portrait") artistPortraitShimmer(),
        if (layoutType == "artist landscape") artistRoundShimmer(),
        if (layoutType == "artist round") artistLandscapShimmer(),
        if (layoutType == "portrait") videoPortraitShimmer(),
      ],
    );
  }

/* Section Wise height show */
  double getRemainingDataHeight(String? layoutType) {
    if (layoutType == "artist round") {
      return 250;
    } else if (layoutType == "artist landscape") {
      return 250;
    } else if (layoutType == "artist portrait") {
      return 255;
    } else if (layoutType == "profession") {
      return 200;
    } else if (layoutType == "portrait") {
      return 210;
    } else if (layoutType == "landscape") {
      return 170;
    } else if (layoutType == "square") {
      return 190;
    } else {
      return 120;
    }
  }

  Widget searchItem() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: white),
      readOnly: true,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Search(),
        ));
      },
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: const TextStyle(color: white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: colorPrimary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        prefixIcon: const Icon(Icons.search, color: white),
      ),
    );
  }

/* Video Landscap Layout Start */

  Widget videoLandscape(List<Datum>? sectionDataList) {
    return ListView.builder(
      itemCount: sectionDataList?.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VideoPlayer(initialIndex: index),
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: MyNetworkImage(
                        imageUrl: sectionDataList?[index].image ?? "",
                        fit: BoxFit.cover,
                        imgWidth: 160,
                        imgHeight: 100,
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: white, shape: BoxShape.circle),
                      child: const Icon(Icons.play_arrow,
                          color: colorAccent, size: 15),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              MyText(
                text: sectionDataList?[index].name ?? "",
                color: white,
                fontsize: Dimens.textMedium,
                fontwaight: FontWeight.w600,
                maxline: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  MyText(
                    text: Utils.kmbGenerator(
                        sectionDataList?[index].totalView ?? 0),
                    fontsize: Dimens.textMedium,
                    color: colorAccent,
                    fontwaight: FontWeight.w600,
                    maxline: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 5),
                  MyText(
                    text: "Views",
                    fontsize: Dimens.textMedium,
                    color: grey,
                    fontwaight: FontWeight.w600,
                    maxline: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  /* Video Square Layout End */

  Widget videoSquare(List<Datum>? sectionDataList) {
    return ListView.builder(
      itemCount: sectionDataList?.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VideoPlayer(initialIndex: index),
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: MyNetworkImage(
                        imageUrl: sectionDataList?[index].image ?? "",
                        fit: BoxFit.cover,
                        imgWidth: 120,
                        imgHeight: 120,
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: white, shape: BoxShape.circle),
                      child: const Icon(Icons.play_arrow,
                          color: colorAccent, size: 15),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              MyText(
                text: sectionDataList?[index].name ?? "",
                color: white,
                fontsize: Dimens.textMedium,
                fontwaight: FontWeight.w600,
                maxline: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  MyText(
                    text: Utils.kmbGenerator(
                        sectionDataList?[index].totalView ?? 0),
                    fontsize: Dimens.textMedium,
                    color: colorAccent,
                    fontwaight: FontWeight.w600,
                    maxline: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 5),
                  MyText(
                    text: "Views",
                    fontsize: Dimens.textMedium,
                    color: grey,
                    fontwaight: FontWeight.w600,
                    maxline: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

/* Video Square Layout End */

  /* Video Portrait Layout Start */

  Widget videoPortrait(List<Datum>? sectionDataList) {
    return ListView.builder(
      itemCount: sectionDataList?.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VideoPlayer(initialIndex: index),
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: MyNetworkImage(
                        imageUrl: sectionDataList?[index].image ?? "",
                        fit: BoxFit.fill,
                        imgWidth: 120,
                        imgHeight: 140,
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: white, shape: BoxShape.circle),
                      child: const Icon(Icons.play_arrow,
                          color: colorAccent, size: 15),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              MyText(
                text: sectionDataList?[index].name ?? "",
                color: white,
                fontsize: Dimens.textMedium,
                fontwaight: FontWeight.w600,
                maxline: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  MyText(
                    text: Utils.kmbGenerator(
                        sectionDataList?[index].totalView ?? 0),
                    fontsize: Dimens.textSmall,
                    color: colorAccent,
                    fontwaight: FontWeight.w600,
                    maxline: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 5),
                  MyText(
                    text: "Views",
                    fontsize: Dimens.textSmall,
                    color: grey,
                    fontwaight: FontWeight.w600,
                    maxline: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget videoPortraitShimmer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: ListView.builder(
        itemCount: 15,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return const Column(children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CustomWidget.roundcorner(height: 90, width: 123),
                CustomWidget.circular(height: 20, width: 20),
              ],
            ),
            SizedBox(height: 6),
            CustomWidget.roundcorner(height: 20, width: 90),
            SizedBox(height: 6),
            CustomWidget.roundcorner(height: 15, width: 70),
          ]);
        },
      ),
    );
  }

/* Video Portrait Layout End */

/* Artist Round Layout Show Start */

  Widget artistRound(List<Datum>? sectionDataList) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 250,
      child: ListView.builder(
        itemCount: sectionDataList?.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              width: 160,
              height: 210,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: colorPrimaryDark,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      color: colorAccent,
                      blurRadius: 4,
                    ),
                  ]),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        id: sectionDataList?[index].id.toString() ?? "",
                        professionId:
                            sectionDataList?[index].professionId.toString() ??
                                "",
                      ),
                    ),
                  );
                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: MyNetworkImage(
                          imgWidth: 100,
                          imgHeight: 100,
                          imageUrl: sectionDataList?[index].image ?? "",
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 15),
                      MyText(
                        color: white,
                        text: sectionDataList?[index].fullName ?? "",
                        maxline: 2,
                        overflow: TextOverflow.ellipsis,
                        fontwaight: FontWeight.w600,
                        fontsize: Dimens.textTitle,
                      ),
                      const SizedBox(height: 3),
                      MyText(
                        text: sectionDataList?[index].profession ?? "",
                        color: white,
                        textalign: TextAlign.center,
                        maxline: 2,
                        overflow: TextOverflow.ellipsis,
                        fontwaight: FontWeight.w300,
                        fontsize: Dimens.textSmall,
                      ),
                      const SizedBox(height: 3),
                      MyText(
                        text:
                            "${Constant.currencySymbol} ${sectionDataList?[index].fees ?? ""}",
                        color: white,
                        fontsize: Dimens.textSmall,
                        fontwaight: FontWeight.w600,
                      ),
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget artistRoundShimmer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 230,
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomWidget.roundcorner(height: 15, width: 150),
              CustomWidget.roundcorner(height: 15, width: 93),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return const Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    CustomWidget.roundcorner(height: 203, width: 155),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CustomWidget.circular(height: 80, width: 80),
                          SizedBox(height: 4),
                          CustomWidget.roundcorner(height: 18, width: 73),
                          CustomWidget.roundcorner(height: 15, width: 93),
                          CustomWidget.roundcorner(height: 15, width: 75),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

/* Artist Round Layout Show End */

/* artistPortrait Layout Start */

  Widget artistPortrait(List<Datum>? sectionDataList) {
    return ListView.builder(
      itemCount: sectionDataList?.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(
                  id: sectionDataList?[index].id.toString() ?? "",
                  professionId:
                      sectionDataList?[index].professionId.toString() ?? "",
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyNetworkImage(
                  imgWidth: 120,
                  imgHeight: 140,
                  imageUrl: sectionDataList?[index].image ?? "",
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: sectionDataList?[index].fullName ?? "",
                        color: white,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        fontwaight: FontWeight.w600,
                        fontsize: Dimens.textTitle,
                      ),
                      const SizedBox(height: 5),
                      MyText(
                        text: sectionDataList?[index].profession ?? "",
                        color: white,
                        textalign: TextAlign.start,
                        maxline: 2,
                        overflow: TextOverflow.ellipsis,
                        fontwaight: FontWeight.w300,
                        fontsize: Dimens.textMedium,
                      ),
                      const SizedBox(height: 5),
                      MyText(
                        text:
                            "${Constant.currencySymbol} ${sectionDataList?[index].fees ?? ""}",
                        color: white,
                        fontsize: Dimens.textSmall,
                        fontwaight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget artistPortraitShimmer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 285,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomWidget.roundcorner(
            height: 22,
            width: 100,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomWidget.roundcorner(height: 165, width: 155),
                    SizedBox(height: 4),
                    CustomWidget.roundcorner(height: 15, width: 73),
                    CustomWidget.roundcorner(height: 13, width: 93),
                    CustomWidget.roundcorner(height: 13, width: 75),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

/* artistPortrait Layout End */

/* Artist Lanscap Layout Start */

  Widget artistLandscape(List<Datum>? sectionDataList) {
    return AlignedGridView.count(
      crossAxisCount: 2,
      itemCount: sectionDataList?.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  DetailsPage(id: sectionDataList?[index].id.toString() ?? ""),
            ));
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 130,
              width: 250,
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                  color: colorPrimaryDark,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      color: colorAccent,
                      blurRadius: 4,
                    ),
                  ]),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: MyNetworkImage(
                      imgWidth: 100,
                      imgHeight: 100,
                      imageUrl: sectionDataList?[index].image ?? "",
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: sectionDataList?[index].fullName ?? "",
                          color: white,
                          maxline: 2,
                          overflow: TextOverflow.ellipsis,
                          fontwaight: FontWeight.w600,
                          fontsize: Dimens.textTitle,
                        ),
                        MyText(
                          color: white,
                          text: sectionDataList?[index].profession ?? "",
                          maxline: 2,
                          overflow: TextOverflow.ellipsis,
                          fontwaight: FontWeight.w300,
                          fontsize: Dimens.textSmall,
                        ),
                        MyText(
                          text:
                              "${Constant.currencySymbol} ${sectionDataList?[index].fees ?? ""}",
                          color: white,
                          maxline: 2,
                          overflow: TextOverflow.ellipsis,
                          fontsize: Dimens.textSmall,
                          fontwaight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget artistLandscapShimmer() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 270,
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomWidget.roundcorner(height: 15, width: 150),
              CustomWidget.roundcorner(height: 15, width: 93),
            ],
          ),
          Expanded(
            child: AlignedGridView.count(
              crossAxisCount: 2,
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return const Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    CustomWidget.roundcorner(height: 130, width: 248),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CustomWidget.roundcorner(height: 100, width: 100),
                          SizedBox(width: 4),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomWidget.roundcorner(height: 18, width: 103),
                              CustomWidget.roundcorner(height: 15, width: 98),
                              CustomWidget.roundcorner(height: 15, width: 75),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

/* Artist Lanscap Layout End */

/* Profession Layout Start */

  Widget profession(List<Datum>? sectionDataList) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: sectionDataList?.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfessionPage(
                  professionId: sectionDataList?[index].id.toString() ?? "",
                  title: sectionDataList?[index].name.toString() ?? "",
                ),
              ));
            },
            child: Container(
              alignment: Alignment.center,
              width: 150,
              height: 150,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: colorPrimaryDark,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      color: colorAccent,
                      blurRadius: 4,
                    ),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: MyNetworkImage(
                        imgHeight: 80,
                        imgWidth: 80,
                        imageUrl: sectionDataList?[index].image ?? "",
                        fit: BoxFit.fill),
                  ),
                  const SizedBox(height: 15),
                  MyText(
                    color: white,
                    text: sectionDataList?[index].name ?? "",
                    maxline: 2,
                    overflow: TextOverflow.ellipsis,
                    fontwaight: FontWeight.w600,
                    fontsize: Dimens.textTitle,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget professionShimmer() {
    return SizedBox(
      height: 130,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return const Stack(
            alignment: Alignment.center,
            children: [
              CustomWidget.roundcorner(height: 150, width: 150),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CustomWidget.circular(height: 60, width: 60),
                    SizedBox(height: 6),
                    CustomWidget.roundcorner(height: 20, width: 100)
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

/* Profession Layout End */

/* Subscription Layout Start */

  Widget subscription() {
    return Consumer<Homeprovider>(
      builder: (context, homeProvider, child) {
        if (homeprovider.packageLoding) {
          return subscriptionShimmer();
        } else {
          if (homeprovider.packageModel.status == 200 &&
              (homeprovider.packageModel.result?.length ?? 0) > 0) {
            return ListView.builder(
              itemCount: homeprovider.packageModel.result?.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Constant.userId == null
                        ? Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Login(),
                          ))
                        : Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PaymentOption(
                                price: homeprovider
                                        .packageModel.result?[index].price
                                        .toString() ??
                                    "",
                                description: homeprovider
                                        .packageModel.result?[index].name ??
                                    "",
                                packageid: homeprovider
                                        .packageModel.result?[index].id
                                        .toString() ??
                                    "",
                              ),
                            ),
                          );
                  },
                  child: Container(
                    width: 300,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [primaryGradient, colorAccent],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MyNetworkImage(
                          imgWidth: 100,
                          imgHeight: 100,
                          imageUrl:
                              homeprovider.packageModel.result?[index].image ??
                                  "",
                          fit: BoxFit.fill,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyText(
                              text: homeprovider
                                      .packageModel.result?[index].name ??
                                  "",
                              fontsize: Dimens.textlargeBig,
                              fontwaight: FontWeight.w300,
                              color: white,
                            ),
                            MyText(
                              text:
                                  " ${homeprovider.packageModel.result?[index].time ?? ""}  ${homeprovider.packageModel.result?[index].type ?? ""}",
                              fontsize: Dimens.textBig,
                              fontwaight: FontWeight.w400,
                              color: white,
                            ),
                            MyText(
                              text:
                                  "${Constant.currencySymbol} ${homeprovider.packageModel.result?[index].price ?? ""}",
                              fontsize: Dimens.textExtraBig,
                              fontwaight: FontWeight.w800,
                              color: white,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget subscriptionShimmer() {
    return ListView.builder(
      itemCount: 10,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const Stack(
          alignment: Alignment.center,
          children: [
            CustomWidget.rectangular(height: 122, width: 280),
            Row(
              children: [
                CustomWidget.roundcorner(height: 112, width: 101),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomWidget.roundcorner(height: 24, width: 69),
                    CustomWidget.roundcorner(height: 61, width: 102),
                  ],
                )
              ],
            )
          ],
        );
      },
    );
  }

/* Subscription Layout End */
}
