import 'package:dtcameo/pages/detailspage.dart';
import 'package:dtcameo/pages/login.dart';
import 'package:dtcameo/pages/videoplayer.dart';
import 'package:dtcameo/provider/latestvideoprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mynetworkimmage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/nodata.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  late LatestVideoProvider latestVideoProvider;
  final _scrollController = ScrollController();
  final TextEditingController _commentController = TextEditingController();
  @override
  void initState() {
    latestVideoProvider =
        Provider.of<LatestVideoProvider>(context, listen: false);
    _scrollController.addListener(_nestedScrollListener);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSectionDetails(0);
    });
  }

  _nestedScrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (latestVideoProvider.isMorePage ?? false)) {
      await latestVideoProvider.setLodMore(true);
      _fetchSectionDetails(latestVideoProvider.currentPage ?? 0);
    }
  }

  Future<void> _fetchSectionDetails(int? nextPage) async {
    printLog("_fetchSectionDetails nextPage  ========> $nextPage");
    printLog(
        "_fetchSectionDetails isMorePage  ======> ${latestVideoProvider.isMorePage}");
    printLog(
        "_fetchSectionDetails currentPage ======> ${latestVideoProvider.currentPage}");
    printLog(
        "_fetchSectionDetails totalPage   ======> ${latestVideoProvider.totalPage}");

    latestVideoProvider.setLoding(true);
    await latestVideoProvider.getLatestVideo((nextPage ?? 0) + 1);
    await latestVideoProvider.getProfile(context, Constant.userId ?? "");
    printLog(
        "latestVideoList length ==> ${latestVideoProvider.latestVideoList?.length}");
  }

  @override
  void dispose() {
    latestVideoProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            profileData(),
            feedDataShow(),
          ],
        ),
      ),
    );
  }

/* Profile data show */
  Widget profileData() {
    return Consumer<LatestVideoProvider>(
      builder: (context, profileProvider, child) {
        if (profileProvider.profileLoding) {
          return profileShimmer();
        } else {
          if (profileProvider.profileModel.status == 200 &&
              (profileProvider.profileModel.result?.length ?? 0) > 0) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    color: colorPrimaryDark,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: MyNetworkImage(
                          imgWidth: 80,
                          imgHeight: 80,
                          imageUrl:
                              profileProvider.profileModel.result?[0].image ??
                                  "",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyText(
                            text: profileProvider
                                    .profileModel.result?[0].fullName ??
                                "",
                            fontsize: Dimens.textlargeBig,
                            fontwaight: FontWeight.w800,
                            color: white,
                          ),
                          const SizedBox(width: 8),
                          MyText(
                            text:
                                "${profileProvider.profileModel.result?[0].followers ?? "0"} Followers",
                            fontsize: Dimens.textTitle,
                            fontwaight: FontWeight.w500,
                            color: white,
                          ),
                        ],
                      ),
                    ],
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

  Widget profileShimmer() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomWidget.rectangular(
            height: 200, width: MediaQuery.sizeOf(context).width),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomWidget.roundcorner(height: 20, width: 130),
                  SizedBox(height: 4),
                  CustomWidget.roundcorner(height: 15, width: 100)
                ],
              ),
              CustomWidget.circular(height: 50, width: 50)
            ],
          ),
        ),
      ],
    );
  }

/* End */

/* Video Data Show Start */
  Widget feedDataShow() {
    return SafeArea(
      child: Consumer<LatestVideoProvider>(
        builder: (context, latestVideoProvider, child) {
          if (latestVideoProvider.latestVideoLoding &&
              !latestVideoProvider.loadMore) {
            return feedShimmer();
          } else {
            if (latestVideoProvider.latestVideoList != null &&
                (latestVideoProvider.latestVideoList?.length ?? 0) > 0) {
              return MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: AlignedGridView.count(
                  crossAxisCount: 1,
                  itemCount: latestVideoProvider.latestVideoList?.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  dragStartBehavior: DragStartBehavior.down,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                      decoration: BoxDecoration(
                        color: colorPrimaryDark,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                    id: latestVideoProvider
                                            .latestVideoList?[index].userId
                                            .toString() ??
                                        "",
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                  child: MyNetworkImage(
                                    imgWidth: 50,
                                    imgHeight: 50,
                                    imageUrl: latestVideoProvider
                                            .latestVideoList?[index]
                                            .userImage ??
                                        "",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      text: latestVideoProvider
                                              .latestVideoList?[index].name ??
                                          "",
                                      fontsize: Dimens.textTitle,
                                      fontwaight: FontWeight.w800,
                                      color: white,
                                    ),
                                    MyText(
                                      text: Utils.dateTimeShow(
                                          latestVideoProvider
                                                  .latestVideoList?[index]
                                                  .createdAt ??
                                              ""),
                                      fontsize: Dimens.textSmall,
                                      fontwaight: FontWeight.w400,
                                      color: grey,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          MyText(
                            text: latestVideoProvider
                                    .latestVideoList?[index].tags ??
                                "",
                            fontsize: Dimens.textBigSmall,
                            fontwaight: FontWeight.w400,
                            color: colorAccent,
                          ),
                          MyText(
                            text: latestVideoProvider
                                    .latestVideoList?[index].title ??
                                "",
                            fontsize: Dimens.textBigSmall,
                            maxline: 2,
                            overflow: TextOverflow.ellipsis,
                            fontwaight: FontWeight.w400,
                            color: white,
                          ),
                          const SizedBox(height: 15),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => VideoPlayer(
                                                initialIndex: index,
                                              )))
                                      .then(
                                        (value) => _fetchSectionDetails(0),
                                      );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: MyNetworkImage(
                                    imgWidth: MediaQuery.of(context).size.width,
                                    imgHeight: 212,
                                    imageUrl: latestVideoProvider
                                            .latestVideoList?[index].image ??
                                        "",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => VideoPlayer(
                                        initialIndex: index,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                      color: colorAccent,
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.favorite,
                                      color: colorAccent, size: 20),
                                  const SizedBox(height: 5),
                                  MyText(
                                    text: Utils.kmbGenerator(latestVideoProvider
                                            .latestVideoList?[index]
                                            .totalLike ??
                                        0),
                                    fontsize: Dimens.textBigSmall,
                                    maxline: 2,
                                    overflow: TextOverflow.ellipsis,
                                    fontwaight: FontWeight.w400,
                                    color: white,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 15),
                              InkWell(
                                onTap: () async {
                                  await latestVideoProvider.getComment(
                                      latestVideoProvider
                                              .latestVideoList?[index].id
                                              .toString() ??
                                          "");
                                  showComment(index);
                                },
                                child: Column(
                                  children: [
                                    const Icon(Icons.comment_rounded,
                                        color: white, size: 20),
                                    const SizedBox(height: 5),
                                    MyText(
                                      text: Utils.kmbGenerator(
                                          latestVideoProvider
                                                  .latestVideoList?[index]
                                                  .totalComment ??
                                              0),
                                      fontsize: Dimens.textBigSmall,
                                      maxline: 2,
                                      overflow: TextOverflow.ellipsis,
                                      fontwaight: FontWeight.w400,
                                      color: white,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                children: [
                                  const Icon(Icons.visibility_outlined,
                                      color: white, size: 20),
                                  const SizedBox(height: 5),
                                  MyText(
                                    text: NumberFormat.compact().format(
                                        latestVideoProvider
                                            .latestVideoList?[index].totalView),
                                    fontsize: Dimens.textBigSmall,
                                    maxline: 2,
                                    overflow: TextOverflow.ellipsis,
                                    fontwaight: FontWeight.w400,
                                    color: white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return const NoData();
            }
          }
        },
      ),
    );
  }

/* Shimmer Start */
  Widget feedShimmer() {
    return AlignedGridView.count(
      crossAxisCount: 1,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: 20,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CustomWidget.circular(height: 50, width: 50),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomWidget.roundcorner(height: 20, width: 150),
                    CustomWidget.roundcorner(height: 18, width: 100)
                  ],
                ),
                Spacer(flex: 1),
                CustomWidget.roundcorner(height: 18, width: 50)
              ],
            ),
            const CustomWidget.roundcorner(height: 20, width: 150),
            const CustomWidget.roundcorner(height: 18, width: 100),
            CustomWidget.roundcorner(
                height: 150, width: MediaQuery.sizeOf(context).width),
            const Row(
              children: [
                CustomWidget.roundcorner(height: 20, width: 50),
                SizedBox(width: 10),
                CustomWidget.roundcorner(height: 20, width: 50),
              ],
            ),
          ],
        );
      },
    );
  }

/* End */
/* Comment Show is Start */
  showComment(int index) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: MediaQuery.of(context).size.height * .7,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: MyText(
                    text: "comments",
                    multilanguage: true,
                    fontsize: Dimens.textExtraBig,
                    fontwaight: FontWeight.w800,
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Colors.black,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _showCommentBottom(),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: "Enter the comment",
                          ),
                        ),
                      ),
                      Consumer<LatestVideoProvider>(
                          builder: (context, videoProvider, child) {
                        return IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () async {
                            // await videoProvider.notifyProvider();
                            if (Constant.userId != null) {
                              await videoProvider.setComment(
                                  index,
                                  videoProvider.latestVideoList?[index].id
                                          .toString() ??
                                      "",
                                  _commentController.text.toString());
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Login(),
                              ));
                            }
                            await videoProvider.getComment(
                              videoProvider.commentModel.result?[index].videoId
                                      .toString() ??
                                  "",
                            );
                            _commentController.clear();
                          },
                        );
                      }),
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

  Widget _showCommentBottom() {
    return Consumer<LatestVideoProvider>(
      builder: (context, videoProvider, child) {
        if (videoProvider.commentLoding) {
          return commentShimmer();
        } else {
          if (videoProvider.commentModel.result != null &&
              (videoProvider.commentModel.result?.length ?? 0) > 0) {
            return ListView.builder(
              itemCount: videoProvider.commentModel.result?.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  onLongPress: () {
                    // deleteAlertDialog(index);
                  },
                  leading: MyNetworkImage(
                    imageUrl:
                        videoProvider.commentModel.result?[index].userImage ??
                            "",
                    fit: BoxFit.fill,
                    imgHeight: 30,
                    imgWidth: 30,
                  ),
                  title: Wrap(
                    children: [
                      MyText(
                        color: colorPrimaryDark,
                        text: videoProvider.commentModel.result?[index].name
                                .toString() ??
                            "",
                        maxline: 1,
                        fontsize: Dimens.textTitle,
                        fontwaight: FontWeight.w600,
                        fontstyle: FontStyle.normal,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      MyText(
                        color: colorPrimaryDark,
                        text: Utils.dateTimeShow(videoProvider
                                .commentModel.result?[index].createdAt
                                .toString() ??
                            ""),
                        maxline: 1,
                        fontsize: Dimens.textTitle,
                        fontwaight: FontWeight.w600,
                        fontstyle: FontStyle.normal,
                      ),
                    ],
                  ),
                  subtitle: MyText(
                    color: colorPrimaryDark,
                    text: videoProvider.commentModel.result?[index].comment
                            .toString() ??
                        "",
                    maxline: 5,
                    overflow: TextOverflow.ellipsis,
                    fontsize: Dimens.textSmall,
                    fontstyle: FontStyle.normal,
                    fontwaight: FontWeight.w400,
                  ),
                );
              },
            );
          } else {
            return MyText(
              color: red,
              text: "No Commment",
              fontsize: Dimens.textExtraBig,
            );
          }
        }
      },
    );
  }

  Widget commentShimmer() {
    return AlignedGridView.count(
      crossAxisCount: 1,
      itemCount: 15,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return const Row(
          children: [
            CustomWidget.circular(height: 30, width: 30),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomWidget.roundcorner(height: 20, width: 150),
                SizedBox(height: 6),
                CustomWidget.roundcorner(height: 20, width: 200),
              ],
            ),
            Spacer(flex: 1),
            CustomWidget.roundcorner(height: 30, width: 40),
          ],
        );
      },
    );
  }

  /* End */
}
