import 'package:dtcameo/pages/detailspage.dart';
import 'package:dtcameo/pages/professionpage.dart';
import 'package:dtcameo/pages/videoplayer.dart';
import 'package:dtcameo/provider/sectiondetailprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mynetworkimmage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/nodata.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ViewAll extends StatefulWidget {
  final String? type, title, sectionid, screenLayOut;
  const ViewAll(
      {super.key,
      required this.title,
      required this.type,
      required this.screenLayOut,
      required this.sectionid});

  @override
  State<ViewAll> createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  final ScrollController _scrollController = ScrollController();
  SectionDetailsProvider sectionDetailsProvider = SectionDetailsProvider();
  @override
  void initState() {
    printLog("type ==> ${widget.type}");
    printLog("screenLayOut ==> ${widget.screenLayOut}");
    sectionDetailsProvider =
        Provider.of<SectionDetailsProvider>(context, listen: false);
    _scrollController.addListener(_scrollListener);
    printLog("Your Section Screen layout ${widget.screenLayOut}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData(0);
    });
    super.initState();
  }

  _scrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (sectionDetailsProvider.currentPage ?? 0) <
            (sectionDetailsProvider.totalPage ?? 0)) {
      printLog("-----?? api call page 2 ");
      sectionDetailsProvider.setLoadMore(true);
      _fetchData(sectionDetailsProvider.currentPage ?? 0);
    }
  }

  Future<void> _fetchData(int? nextPage) async {
    printLog("morePage  =======> ${sectionDetailsProvider.isMorePage}");
    printLog("currentPage =====> ${sectionDetailsProvider.currentPage}");
    printLog("totalPage   =====> ${sectionDetailsProvider.totalPage}");

    if (widget.type.toString() == "1") {
      sectionDetailsProvider.setLoading(true);
      await sectionDetailsProvider.getSectionVideo(
          widget.type ?? "", widget.sectionid ?? "", (nextPage ?? 0) + 1);
    } else if (widget.type.toString() == "2") {
      if (widget.screenLayOut.toString() == "artist Landscape") {
        sectionDetailsProvider.setLoading(true);
        await sectionDetailsProvider.getSectionDetails(
            widget.type ?? "", widget.sectionid ?? "", (nextPage ?? 0) + 1);
      } else {
        sectionDetailsProvider.setLoading(true);
        await sectionDetailsProvider.getSectionDetails(
            widget.type ?? "", widget.sectionid ?? "", (nextPage ?? 0) + 1);
      }
    } else if (widget.type.toString() == "3") {
      sectionDetailsProvider.setLoading(true);
      await sectionDetailsProvider.getSectionDetailsCategory(
          widget.type ?? "", widget.sectionid ?? "", (nextPage ?? 0) + 1);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    sectionDetailsProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      backgroundColor: colorPrimaryDark,
      appBar: AppBar(
        leading: Utils.backButton(context),
        backgroundColor: colorPrimaryDark,
        iconTheme: const IconThemeData(color: white),
        title: MyText(
          text: widget.title ?? "",
          fontsize: Dimens.textlargeBig,
          fontwaight: FontWeight.w600,
          color: white,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
            child: Column(
              children: [
                _buildUi(),
                /* Loader */
                Consumer<SectionDetailsProvider>(
                  builder: (context, sectionDetailsProvider, child) {
                    if (sectionDetailsProvider.loadMore) {
                      if (widget.type.toString() == "1") {
                        return videoShimmer();
                      } else if (widget.type.toString() == "2") {
                        if (widget.screenLayOut.toString() ==
                            "artist landscape") {
                          return newFeaturshimmer();
                        } else if (widget.screenLayOut.toString() ==
                            "artist round") {
                          return aritsRoundedShimmer();
                        } else if (widget.screenLayOut.toString() ==
                            "artist portrait") {
                          return artistPortrait();
                        } else {
                          return const SizedBox.shrink();
                        }
                      } else if (widget.type.toString() == "3") {
                        return professionShimmer();
                      } else {
                        return const SizedBox.shrink();
                      }
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
          Utils.showBannerAd(context),
        ],
      ),
    );
  }

/* All UI Start */
  Widget _buildUi() {
    if (widget.type == "1") {
      return videoData();
    } else if (widget.type.toString() == "2") {
      if (widget.screenLayOut.toString() == "artist landscape") {
        return newDataShow();
      } else if (widget.screenLayOut.toString() == "artist round") {
        return fetauredDataShow();
      } else if (widget.screenLayOut.toString() == "artist portrait") {
        return artistPortrait();
      } else {
        return const CircularProgressIndicator();
      }
    } else if (widget.type == "3") {
      return professionData();
    } else {
      return const SizedBox.shrink();
    }
  }
/* End */

/* Video Ui Start */
  Widget videoData() {
    return Consumer<SectionDetailsProvider>(
      builder: (context, sectionDetailsProvider, child) {
        if (sectionDetailsProvider.loaded) {
          return videoShimmer();
        } else {
          if (sectionDetailsProvider.videoList != null &&
              (sectionDetailsProvider.videoList?.length ?? 0) > 0) {
            return AlignedGridView.count(
              crossAxisCount: 3,
              itemCount: sectionDetailsProvider.videoList?.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                VideoPlayer(initialIndex: index),
                          ));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: MyNetworkImage(
                                imageUrl: sectionDetailsProvider
                                        .videoList?[index].image ??
                                    "",
                                fit: BoxFit.fill,
                                imgHeight: 100,
                                imgWidth: 123,
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
                      const SizedBox(height: 5),
                      MyText(
                        text:
                            sectionDetailsProvider.videoList?[index].name ?? "",
                        color: white,
                        fontsize: Dimens.textTitle,
                        fontwaight: FontWeight.w600,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          MyText(
                            text: Utils.kmbGenerator(sectionDetailsProvider
                                    .videoList?[index].totalView ??
                                0),
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
          } else {
            return const NoData();
          }
        }
      },
    );
  }

  /* Shimmer */
  Widget videoShimmer() {
    return AlignedGridView.count(
      crossAxisCount: 3,
      itemCount: 15,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CustomWidget.roundcorner(height: 100, width: 123),
                  CustomWidget.circular(height: 20, width: 20),
                ],
              ),
              SizedBox(height: 6),
              CustomWidget.roundcorner(height: 20, width: 90),
              SizedBox(height: 6),
              CustomWidget.roundcorner(height: 15, width: 70),
            ]);
      },
    );
  }

/* End */
  /* Category DataShow Start */
  Widget professionData() {
    printLog("Biussness");
    return Consumer<SectionDetailsProvider>(
      builder: (context, sectionDetailsProvider, child) {
        if (sectionDetailsProvider.loaded) {
          return professionShimmer();
        } else {
          if (sectionDetailsProvider.categoryList != null &&
              (sectionDetailsProvider.categoryList?.length ?? 0) > 0) {
            return AlignedGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: sectionDetailsProvider.categoryList?.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfessionPage(
                        professionId: sectionDetailsProvider
                                .categoryList?[index].id
                                .toString() ??
                            "",
                         title: sectionDetailsProvider
                                .categoryList?[index].name
                                .toString() ??
                            "",
                      ),
                    ));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: 200,
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
                              imageUrl: sectionDetailsProvider
                                      .categoryList?[index].image ??
                                  "",
                              fit: BoxFit.fill),
                        ),
                        const SizedBox(height: 15),
                        MyText(
                          color: white,
                          text: sectionDetailsProvider
                                  .categoryList?[index].name ??
                              "",
                          maxline: 2,
                          overflow: TextOverflow.ellipsis,
                          fontwaight: FontWeight.w600,
                          fontsize: Dimens.textTitle,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const NoData();
          }
        }
      },
    );
  }

/* Category Shimmer */
  Widget professionShimmer() {
    return AlignedGridView.count(
      crossAxisCount: 2,
      itemCount: 10,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      scrollDirection: Axis.vertical,
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
                  CustomWidget.circular(height: 80, width: 80),
                  SizedBox(height: 6),
                  CustomWidget.roundcorner(height: 20, width: 100)
                ],
              ),
            )
          ],
        );
      },
    );
  }

/* End */

/* Featured Data Start  */
  Widget fetauredDataShow() {
    return Consumer<SectionDetailsProvider>(
      builder: (context, sectionDetailsProvider, child) {
        if (sectionDetailsProvider.loaded) {
          return aritsRoundedShimmer();
        }
        if (sectionDetailsProvider.secationDetailList != null &&
            (sectionDetailsProvider.secationDetailList?.length ?? 0) > 0) {
          return AlignedGridView.count(
            crossAxisCount: 2,
            itemCount: sectionDetailsProvider.secationDetailList?.length,
            shrinkWrap: true,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                height: 210,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
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
                          id: sectionDetailsProvider
                                  .secationDetailList?[index].id
                                  .toString() ??
                              "",
                          professionId: sectionDetailsProvider
                                  .secationDetailList?[index].professionId
                                  .toString() ??
                              "",
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: MyNetworkImage(
                          imgHeight: 100,
                          imgWidth: 100,
                          imageUrl: sectionDetailsProvider
                                  .secationDetailList?[index].image ??
                              "",
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 5),
                      MyText(
                        text: sectionDetailsProvider
                                .secationDetailList?[index].fullName ??
                            "",
                        color: white,
                        maxline: 2,
                        overflow: TextOverflow.ellipsis,
                        fontwaight: FontWeight.w700,
                        fontsize: Dimens.textTitle,
                      ),
                      const SizedBox(height: 5),
                      MyText(
                        text: sectionDetailsProvider
                                .secationDetailList?[index].profession ??
                            "",
                        color: white,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        fontwaight: FontWeight.w300,
                        fontsize: Dimens.textSmall,
                      ),
                      const SizedBox(height: 5),
                      MyText(
                        text:
                            "${Constant.currencySymbol} ${sectionDetailsProvider.secationDetailList?[index].fees.toString() ?? ""}",
                        color: white,
                        fontwaight: FontWeight.w700,
                        fontsize: Dimens.textSmall,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const NoData();
        }
      },
    );
  }

/* Shimmer */
  Widget aritsRoundedShimmer() {
    return AlignedGridView.count(
      crossAxisCount: 2,
      itemCount: 10,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: const CustomWidget.rectangular(height: 200)),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomWidget.circular(height: 100, width: 100),
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
    );
  }
/* End */

/* New Data Show Start  */
  Widget newDataShow() {
    return Consumer<SectionDetailsProvider>(
      builder: (context, sectionDetailsProvider, child) {
        if (sectionDetailsProvider.loaded) {
          return newFeaturshimmer();
        } else {
          if (sectionDetailsProvider.secationDetailList != null &&
              (sectionDetailsProvider.secationDetailList?.length ?? 0) > 0) {
            return ListView.builder(
              itemCount: sectionDetailsProvider.secationDetailList?.length,
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        id: sectionDetailsProvider.secationDetailList?[index].id
                                .toString() ??
                            "0",
                      ),
                    ));
                  },
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
                        MyNetworkImage(
                          imgWidth: 100,
                          imgHeight: 100,
                          imageUrl: sectionDetailsProvider
                                  .secationDetailList?[index].image ??
                              "",
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: sectionDetailsProvider
                                        .secationDetailList?[index].fullName ??
                                    "",
                                color: white,
                                maxline: 2,
                                overflow: TextOverflow.ellipsis,
                                fontwaight: FontWeight.w600,
                                fontsize: Dimens.textTitle,
                              ),
                              MyText(
                                color: white,
                                text: sectionDetailsProvider
                                        .secationDetailList?[index]
                                        .profession ??
                                    "",
                                maxline: 2,
                                overflow: TextOverflow.ellipsis,
                                fontwaight: FontWeight.w300,
                                fontsize: Dimens.textSmall,
                              ),
                              MyText(
                                text:
                                    "${Constant.currencySymbol} ${sectionDetailsProvider.secationDetailList?[index].fees ?? ""}",
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
                );
              },
            );
          } else {
            return const NoData();
          }
        }
      },
    );
  }

/* Shimmer */
  Widget newFeaturshimmer() {
    return ListView.builder(
      itemCount: 10,
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            CustomWidget.roundcorner(
                height: 120, width: MediaQuery.of(context).size.width),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CustomWidget.roundcorner(height: 100, width: 100),
                  SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomWidget.roundcorner(height: 18, width: 100),
                        CustomWidget.roundcorner(height: 15, width: 88),
                        CustomWidget.roundcorner(height: 15, width: 65),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

/* Featured Data Start  */
  Widget artistPortrait() {
    return Consumer<SectionDetailsProvider>(
      builder: (context, sectionDetailsProvider, child) {
        if (sectionDetailsProvider.loaded) {
          return artistPortraitShimmer();
        }
        if (sectionDetailsProvider.secationDetailList != null &&
            (sectionDetailsProvider.secationDetailList?.length ?? 0) > 0) {
          return AlignedGridView.count(
            crossAxisCount: 3,
            itemCount: sectionDetailsProvider.secationDetailList?.length,
            shrinkWrap: true,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        id: sectionDetailsProvider.secationDetailList?[index].id
                                .toString() ??
                            "",
                        professionId: sectionDetailsProvider
                                .secationDetailList?[index].professionId
                                .toString() ??
                            "",
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: MyNetworkImage(
                        imgHeight: 150,
                        imgWidth: MediaQuery.of(context).size.width,
                        imageUrl: sectionDetailsProvider
                                .secationDetailList?[index].image ??
                            "",
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(height: 5),
                    MyText(
                      text: sectionDetailsProvider
                              .secationDetailList?[index].fullName ??
                          "",
                      color: white,
                      fontwaight: FontWeight.w700,
                      fontsize: Dimens.textTitle,
                    ),
                    const SizedBox(height: 5),
                    MyText(
                      text: sectionDetailsProvider
                              .secationDetailList?[index].profession ??
                          "",
                      color: white,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      fontwaight: FontWeight.w300,
                      fontsize: Dimens.textSmall,
                    ),
                    const SizedBox(height: 5),
                    MyText(
                      text:
                          "${Constant.currencySymbol} ${sectionDetailsProvider.secationDetailList?[index].fees.toString() ?? ""}",
                      color: white,
                      fontwaight: FontWeight.w700,
                      fontsize: Dimens.textSmall,
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return const NoData();
        }
      },
    );
  }

/* Shimmer */
  Widget artistPortraitShimmer() {
    return AlignedGridView.count(
      crossAxisCount: 3,
      itemCount: 10,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomWidget.roundcorner(height: 150, width: 192),
            SizedBox(height: 4),
            CustomWidget.roundcorner(height: 18, width: 73),
            CustomWidget.roundcorner(height: 15, width: 93),
            CustomWidget.roundcorner(height: 15, width: 75),
          ],
        );
      },
    );
  }
/* End */
}
