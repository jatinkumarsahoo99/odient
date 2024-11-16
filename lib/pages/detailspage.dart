import 'package:dtcameo/pages/bottomscreen/following.dart';
import 'package:dtcameo/pages/categoriesscreen.dart';
import 'package:dtcameo/pages/login.dart';
import 'package:dtcameo/pages/message.dart';
import 'package:dtcameo/pages/requestfor.dart';
import 'package:dtcameo/pages/reviewscreeen.dart';
import 'package:dtcameo/pages/videoplayer.dart';
import 'package:dtcameo/provider/detilsprovider.dart';
import 'package:dtcameo/utils/adhlper.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mynetworkimmage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/nodata.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class DetailsPage extends StatefulWidget {
  final String? id, professionId;
  const DetailsPage({super.key, required this.id, this.professionId});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  double rate = 0.0;
  Detilsprovider detailsProvider = Detilsprovider();

  @override
  void initState() {
    detailsProvider = Provider.of<Detilsprovider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAPi();
    });
    super.initState();
  }

  Future<void> getAPi() async {
    detailsProvider.setLoding(true);
    await detailsProvider.getDetails(widget.id ?? "", Constant.userId ?? "");
    await detailsProvider.getProfession(widget.id ?? "", 0);
    await detailsProvider.getReview(widget.id ?? "", 0);
    await detailsProvider.getVideo(widget.id ?? "");
  }

  @override
  void dispose() {
    detailsProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: white),
        leading: Utils.backButton(context),
        backgroundColor: colorPrimaryDark,
        actions: [
          Consumer<Detilsprovider>(
            builder: (context, detailsProvider, child) {
              if (detailsProvider.detailModel.status == 200) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [primaryGradient, colorAccent],
                          tileMode: TileMode.mirror),
                    ),
                    child: TextButton(
                        onPressed: () async {
                          Constant.userId == null
                              ? Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  ),
                                )
                              : await detailsProvider
                                  .setFollow(widget.id ?? "");
                        },
                        child: MyText(
                          text: (detailsProvider
                                          .detailModel.result?[0].isFollow ??
                                      0) ==
                                  1
                              ? "following"
                              : "follow",
                          multilanguage: true,
                          fontsize: Dimens.textSmall,
                          fontwaight: FontWeight.w700,
                          color: white,
                        )),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          children: [
            videoData(),
            const SizedBox(height: 20),
            userData(),
            reviewShow(),
            const SizedBox(height: 20),
            shimilarCelebrityData(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Consumer<Detilsprovider>(
        builder: (context, detilsprovider, child) {
          if (detailsProvider.loaded) {
            return bookShimmerData();
          } else {
            if (detailsProvider.detailModel.status == 200 &&
                (detailsProvider.detailModel.result?.length ?? 0) > 0) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Utils.showBannerAd(context),
                  requestForBook(),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          }
        },
      ),
    );
  }

/* Video show Start */
  Widget videoData() {
    return Consumer<Detilsprovider>(
      builder: (context, detailsProvider, child) {
        if (detailsProvider.videoLoding) {
          return videoShimmer();
        } else {
          if (detailsProvider.videoModel.status == 200 &&
              (detailsProvider.videoModel.result?.length ?? 0) > 0) {
            return SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: detailsProvider.videoModel.result?.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayer(
                                initialIndex: index,
                              ),
                            ));
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: MyNetworkImage(
                              imgWidth: 205,
                              imgHeight: 266,
                              imageUrl: detailsProvider
                                      .videoModel.result?[index].image ??
                                  "",
                              fit: BoxFit.fill,
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
                  );
                },
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget videoShimmer() {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return const CustomWidget.roundcorner(
            height: 266,
            width: 205,
          );
        },
      ),
    );
  }
/* Video show End */

/* Shimmer */
  Widget bookShimmerData() {
    return const Row(
      children: [
        Expanded(child: CustomWidget.roundcorner(height: 42, width: 317)),
        CustomWidget.roundcorner(height: 42, width: 66),
      ],
    );
  }

/* Shimmer */
  Widget userDetailsShimmer() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                CustomWidget.roundcorner(height: 24, width: 112),
                CustomWidget.roundcorner(height: 18, width: 121),
              ],
            ),
            CustomWidget.circular(height: 50, width: 50),
          ],
        ),
        const SizedBox(height: 10),
        CustomWidget.roundcorner(
            height: 100, width: MediaQuery.of(context).size.width),
        Stack(
          alignment: Alignment.center,
          children: [
            CustomWidget.roundcorner(
                height: 60, width: MediaQuery.of(context).size.width),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    CustomWidget.roundcorner(height: 16, width: 73),
                    CustomWidget.roundcorner(height: 19, width: 41),
                  ],
                ),
                CustomWidget.roundcorner(height: 50, width: 3),
                Column(
                  children: [
                    CustomWidget.roundcorner(height: 16, width: 73),
                    CustomWidget.roundcorner(height: 19, width: 41),
                  ],
                )
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

/* End */
/* Profiel Data Show  */
  Widget userData() {
    return Consumer<Detilsprovider>(
      builder: (context, detilsprovider, child) {
        if (detailsProvider.loaded) {
          return userDetailsShimmer();
        } else {
          if (detailsProvider.detailModel.status == 200 &&
              (detailsProvider.detailModel.result?.length ?? 0) > 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            color: white,
                            text: detailsProvider
                                    .detailModel.result?[0].fullName ??
                                "",
                            fontsize: Dimens.textlargeBig,
                            fontwaight: FontWeight.w600,
                          ),
                          MyText(
                            color: white,
                            text: detailsProvider
                                    .detailModel.result?[0].profession ??
                                "",
                            fontsize: Dimens.textTitle,
                            maxline: 2,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.start,
                            fontwaight: FontWeight.w300,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.only(top: 8),
                                decoration: const BoxDecoration(
                                    color: white, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: MyText(
                                    color: white,
                                    text: detailsProvider
                                            .detailModel.result?[0].tagLine ??
                                        "",
                                    fontsize: Dimens.textMedium,
                                    maxline: 7,
                                    textalign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    fontwaight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    MyNetworkImage(
                      imgWidth: 65,
                      imgHeight: 65,
                      imageUrl:
                          detailsProvider.detailModel.result?[0].image ?? "",
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ReadMoreText(
                  detailsProvider.detailModel.result?[0].bio ?? "",
                  trimMode: TrimMode.Line,
                  trimLines: 3,
                  style: Utils.googleFontStyle(
                      2, 16, FontStyle.normal, grey, FontWeight.w400),
                  lessStyle: Utils.googleFontStyle(
                      2, 16, FontStyle.normal, colorAccent, FontWeight.w700),
                  colorClickableText: colorAccent,
                  trimCollapsedText: 'More',
                  trimExpandedText: 'Less',
                  moreStyle: Utils.googleFontStyle(
                      2, 16, FontStyle.normal, colorAccent, FontWeight.w700),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                        await detilsprovider.urlOpenSocial(
                            detilsprovider.detailModel.result?[0].instagrmUrl ??
                                "");
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.instagram,
                        color: white,
                      ),
                    ),
                    Container(height: 30, width: 2, color: white),
                    InkWell(
                      onTap: () async {
                        await detilsprovider.urlOpenSocial(
                            detilsprovider.detailModel.result?[0].snapUrl ??
                                "");
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.snapchat,
                        color: white,
                      ),
                    ),
                    Container(height: 30, width: 2, color: white),
                    InkWell(
                      onTap: () async {
                        await detilsprovider.urlOpenSocial(
                            detilsprovider.detailModel.result?[0].facebookUrl ??
                                "");
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.facebook,
                        color: white,
                      ),
                    ),
                    Container(height: 30, width: 2, color: white),
                    InkWell(
                      onTap: () async {
                        await detilsprovider.urlOpenSocial(
                            detilsprovider.detailModel.result?[0].linkdinUrl ??
                                "");
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.linkedinIn,
                        color: white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: colorPrimaryDark,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ReviewScreen(
                                    id: detailsProvider
                                            .detailModel.result?[0].id
                                            .toString() ??
                                        "",
                                  )));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyText(
                              color: white,
                              text:
                                  'Review (${Utils.kmbGenerator(detailsProvider.detailModel.result?[0].totalReview ?? 0)})',
                              fontsize: Dimens.textMedium,
                              fontwaight: FontWeight.w400,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: yellow,
                                  size: 19,
                                ),
                                const SizedBox(width: 5),
                                MyText(
                                  color: white,
                                  text: detailsProvider
                                          .detailModel.result?[0].averageRating
                                          .toString() ??
                                      "0",
                                  fontsize: Dimens.textMedium,
                                  fontwaight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(height: 40, color: grey, width: 2),
                      InkWell(
                        onTap: () {
                          Constant.userId == null
                              ? Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ))
                              : Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Following(),
                                ));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyText(
                              color: white,
                              text: 'followers',
                              multilanguage: true,
                              fontsize: Dimens.textMedium,
                              fontwaight: FontWeight.w400,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.favorite_outline,
                                  size: 19,
                                  color: colorAccent,
                                ),
                                const SizedBox(width: 5),
                                MyText(
                                  color: white,
                                  text: Utils.kmbGenerator(detailsProvider
                                          .detailModel.result?[0].followers ??
                                      0),
                                  fontsize: Dimens.textMedium,
                                  fontwaight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            );
          } else {
            return const NoData();
          }
        }
      },
    );
  }

/* Review  Start */
  Widget reviewShow() {
    return Consumer<Detilsprovider>(
      builder: (context, detilsprovider, child) {
        if (detailsProvider.reviewLoding) {
          return reviewSHimmer();
        } else {
          if (detailsProvider.reviewModel.status == 200 &&
              (detailsProvider.reviewModel.result?.length ?? 0) > 0) {
            int itemCount = detailsProvider.reviewModel.result?.length ?? 0;
            int displayCount = itemCount > 3 ? 3 : itemCount;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      color: white,
                      text: 'review',
                      multilanguage: true,
                      fontsize: Dimens.textlargeBig,
                      fontwaight: FontWeight.w600,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewScreen(
                                id: detailsProvider.detailModel.result?[0].id
                                        .toString() ??
                                    "",
                              ),
                            ));
                      },
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
                ListView.builder(
                    itemCount: displayCount,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorPrimaryDark,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: MyNetworkImage(
                                      imgWidth: 50,
                                      imgHeight: 50,
                                      imageUrl: detailsProvider.reviewModel
                                              .result?[index].userImage ??
                                          "",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          color: white,
                                          text: detailsProvider.reviewModel
                                                  .result?[index].name ??
                                              "",
                                          fontsize: Dimens.textTitle,
                                          fontwaight: FontWeight.w600,
                                        ),
                                        const SizedBox(height: 3),
                                        MyText(
                                          color: white,
                                          text: Utils.dateTimeShow(
                                              detailsProvider
                                                      .reviewModel
                                                      .result?[index]
                                                      .createdAt ??
                                                  ""),
                                          fontsize: Dimens.textSmall,
                                          fontwaight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  RatingBar.builder(
                                    itemCount: 5,
                                    itemSize: 18,
                                    initialRating: 5,
                                    updateOnDrag: true,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    glowColor: yellow,
                                    itemBuilder: (context, review) => Icon(
                                      Icons.star_rounded,
                                      color: review <
                                              (detailsProvider.reviewModel
                                                      .result?[index].rating ??
                                                  0)
                                          ? yellow
                                          : grey,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  const SizedBox(width: 10),
                                  MyText(
                                    fontsize: Dimens.textSmall,
                                    color: white,
                                    text: detailsProvider
                                            .reviewModel.result?[index].rating
                                            .toString() ??
                                        "",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              MyText(
                                color: white,
                                text: detailsProvider.reviewModel.result?[index]
                                        .description ??
                                    "",
                                fontsize: Dimens.textMedium,
                                maxline: 4,
                                fontwaight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget reviewSHimmer() {
    return Column(
      children: [
        CustomWidget.roundcorner(
            height: 24, width: MediaQuery.of(context).size.width),
        const SizedBox(height: 10),
        ListView.builder(
          itemCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Stack(
              alignment: Alignment.center,
              children: [
                CustomWidget.roundcorner(
                    height: 180, width: MediaQuery.of(context).size.width),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CustomWidget.circular(height: 50, width: 50),
                          SizedBox(width: 10),
                          Column(
                            children: [
                              CustomWidget.roundcorner(height: 16, width: 75),
                              CustomWidget.roundcorner(height: 19, width: 78),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          CustomWidget.roundcorner(height: 19, width: 93),
                          SizedBox(width: 10),
                          CustomWidget.roundcorner(height: 13, width: 17),
                        ],
                      ),
                      CustomWidget.roundcorner(height: 71, width: 398),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }
/* Review  End */

/* Shimilar category Start */
  Widget shimilarCelebrityData() {
    return Consumer<Detilsprovider>(
      builder: (context, detailsProvider, child) {
        if (detailsProvider.professionLoding) {
          return similarCelebrityShimemr();
        } else {
          if (detailsProvider.reletedArtistModel.status == 200 &&
              (detailsProvider.reletedArtistModel.result?.length ?? 0) > 0) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      color: white,
                      text: 'similar',
                      multilanguage: true,
                      fontsize: Dimens.textlargeBig,
                      fontwaight: FontWeight.w600,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoriesScreen(
                                    id: widget.id ?? "",
                                  )),
                        );
                      },
                      child: MyText(
                        color: colorAccent,
                        text: 'see',
                        multilanguage: true,
                        fontsize: Dimens.textMedium,
                        fontwaight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: AlignedGridView.count(
                    crossAxisCount: 1,
                    itemCount:
                        detailsProvider.reletedArtistModel.result?.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                    id: detailsProvider.reletedArtistModel
                                            .result?[index].id
                                            .toString() ??
                                        ""),
                              ))
                              .then(
                                (value) => getAPi(),
                              );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyNetworkImage(
                                imgWidth: 120,
                                imgHeight: 140,
                                imageUrl: detailsProvider.reletedArtistModel
                                        .result?[index].image ??
                                    "",
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    MyText(
                                      text: detailsProvider.reletedArtistModel
                                              .result?[index].fullName ??
                                          "",
                                      color: white,
                                      maxline: 1,
                                      overflow: TextOverflow.ellipsis,
                                      fontwaight: FontWeight.w600,
                                      fontsize: Dimens.textTitle,
                                    ),
                                    const SizedBox(height: 3),
                                    MyText(
                                      text: detailsProvider.reletedArtistModel
                                              .result?[index].profession ??
                                          "",
                                      color: white,
                                      textalign: TextAlign.start,
                                      maxline: 3,
                                      overflow: TextOverflow.ellipsis,
                                      fontwaight: FontWeight.w300,
                                      fontsize: Dimens.textMedium,
                                    ),
                                    const SizedBox(height: 3),
                                    MyText(
                                      text:
                                          "${Constant.currencySymbol} ${detailsProvider.reletedArtistModel.result?[index].fees.toString() ?? ""}",
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
                  ),
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

  Widget similarCelebrityShimemr() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 285,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomWidget.roundcorner(height: 22, width: 100),
              CustomWidget.roundcorner(height: 22, width: 60),
            ],
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
/* Shimilar category End */

/* book Request Start */
  Widget requestForBook() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: BottomAppBar(
        shadowColor: white,
        elevation: 30,
        color: colorPrimaryDark,
        padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: 317,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [primaryGradient, colorAccent],
                          tileMode: TileMode.mirror),
                    ),
                    child: TextButton(
                        onPressed: () {
                          Constant.userId == null
                              ? Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ))
                              : AdHelper.rewardedAd(
                                  context,
                                  () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => RequestFor(
                                        id: widget.id ?? "",
                                      ),
                                    ));
                                  },
                                );
                        },
                        child: MyText(
                          text:
                              "Book a personal video ${Constant.currencySymbol} ${detailsProvider.detailModel.result?[0].fees.toString() ?? "0"}",
                          color: white,
                          fontsize: Dimens.textMedium,
                          fontwaight: FontWeight.w600,
                        )),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    Constant.userId == null
                        ? Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Login(),
                          ))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Message(
                                toUserName: detailsProvider
                                        .detailModel.result?[0].fullName ??
                                    "",
                                toChatId: detailsProvider
                                        .detailModel.result?[0].firebaseId ??
                                    "",
                                profileImg: detailsProvider
                                        .detailModel.result?[0].image ??
                                    "",
                                bioData: detailsProvider
                                        .detailModel.result?[0].bio ??
                                    "",
                              ),
                            ));
                  },
                  child: Container(
                    width: 66,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: transparent,
                        border: Border.all(
                            width: 1, color: white, style: BorderStyle.solid)),
                    child: const Icon(
                      Icons.chat,
                      color: white,
                      size: 18,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
