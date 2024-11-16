import 'package:dtcameo/provider/reviewprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mynetworkimmage.dart';
import 'package:dtcameo/widget/nodata.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../widget/mytext.dart';

class ReviewScreen extends StatefulWidget {
  final String? id;
  const ReviewScreen({super.key, required this.id});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  ReviewProvider reviewProvider = ReviewProvider();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    _scrollController.addListener(_nestedScrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAPi(0);
    });
    super.initState();
  }

  /* scroller controller code and add listner */
  _nestedScrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (reviewProvider.isMorePage ?? false)) {
      await reviewProvider.setLoadMore(true);
      getAPi(reviewProvider.currentPage ?? 0);
    }
  }

  Future<void> getAPi(int? pageno) async {
    printLog("_fetchSectionDetails nextPage  ========> $pageno");
    printLog(
        "_fetchSectionDetails isMorePage  ======> ${reviewProvider.isMorePage}");
    printLog(
        "_fetchSectionDetails currentPage ======> ${reviewProvider.currentPage}");
    printLog(
        "_fetchSectionDetails totalPage   ======> ${reviewProvider.totalPage}");
    reviewProvider.setLoding(true);
    await reviewProvider.getReview(widget.id ?? "", (pageno ?? 0) + 1);
    printLog("reviewList length ==> ${reviewProvider.reviewList?.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      appBar: AppBar(
        backgroundColor: colorPrimaryDark,
        iconTheme: const IconThemeData(color: white),
        leading: Utils.backButton(context),
        title: MyText(
          text: "review",
          multilanguage: true,
          fontsize: Dimens.textTitle,
          fontwaight: FontWeight.w600,
          color: white,
        ),
      ),
      body: reviewList(),
    );
  }

  Widget reviewList() {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
        if (reviewProvider.loaded) {
          return reviewShimmer();
        } else {
          if (reviewProvider.reviewList != null &&
              (reviewProvider.reviewList?.length ?? 0) > 0) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    color: white,
                    text: 'all',
                    multilanguage: true,
                    fontsize: Dimens.textlargeBig,
                    fontwaight: FontWeight.bold,
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                      itemCount: reviewProvider.reviewList?.length,
                      shrinkWrap: true,
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
                                        imageUrl: reviewProvider
                                                .reviewList?[index].userImage ??
                                            "",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          color: white,
                                          text: reviewProvider
                                                  .reviewList?[index].name ??
                                              "",
                                          fontsize: Dimens.textMedium,
                                          fontwaight: FontWeight.w600,
                                        ),
                                        MyText(
                                          color: white,
                                          text: Utils.dateTimeShow(
                                              reviewProvider.reviewList?[index]
                                                      .createdAt ??
                                                  ""),
                                          fontsize: Dimens.textSmall,
                                          fontwaight: FontWeight.w400,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      itemSize: 20,
                                      initialRating: 5,
                                      updateOnDrag: true,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      glowColor: yellow,
                                      itemBuilder: (context, reviw) => Icon(
                                        Icons.star_rounded,
                                        color: reviw <
                                                (reviewProvider
                                                        .reviewList?[index]
                                                        .rating ??
                                                    0)
                                            ? yellow
                                            : grey,
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                    const SizedBox(width: 10),
                                    MyText(
                                      color: white,
                                      text: reviewProvider
                                              .reviewList?[index].rating
                                              .toString() ??
                                          "",
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                MyText(
                                  color: white,
                                  text: reviewProvider
                                          .reviewList?[index].description ??
                                      "",
                                  fontsize: Dimens.textBigSmall,
                                  maxline: 4,
                                  fontwaight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  /* Pagination loader */
                  Consumer<ReviewProvider>(
                    builder: (context, reviewProvider, child) {
                      if (reviewProvider.loadMore) {
                        return reviewShimmer();
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          } else {
            return const NoData();
          }
        }
      },
    );
  }

  Widget reviewShimmer() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomWidget.roundcorner(
              height: 32, width: MediaQuery.of(context).size.width * 0.4),
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
      ),
    );
  }
}
