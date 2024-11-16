import 'package:dtcameo/pages/detailspage.dart';
import 'package:dtcameo/pages/login.dart';
import 'package:dtcameo/provider/latestvideoprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mynetworkimmage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/nodata.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:dtcameo/widget/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class VideoPlayer extends StatefulWidget {
  final int? initialIndex;
  const VideoPlayer({super.key, this.initialIndex});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  final TextEditingController _commentController = TextEditingController();
  PageController? _pageController;
  int currentIndex = 0;
  LatestVideoProvider latestVideoProvider = LatestVideoProvider();
  @override
  void initState() {
    latestVideoProvider =
        Provider.of<LatestVideoProvider>(context, listen: false);
    currentIndex = widget.initialIndex ?? 0;
    _pageController =
        PageController(initialPage: currentIndex, viewportFraction: 1);
    getApi();
    super.initState();
  }

  getApi() async {
    await latestVideoProvider.getLatestVideo(1);
  }

  Future _fetchAllShort() async {
    printLog("isMorePage  =======> ${latestVideoProvider.isMorePage}");
    printLog("currentPage =======> ${latestVideoProvider.currentPage}");
    printLog("totalPage   =======> ${latestVideoProvider.totalPage}");
    int nextPage = (latestVideoProvider.currentPage ?? 0) + 1;
    printLog("nextPage   ========> $nextPage");
    if ((latestVideoProvider.currentPage ?? 0) <=
            (latestVideoProvider.totalPage ?? 0) &&
        nextPage <= (latestVideoProvider.totalPage ?? 0)) {
      await latestVideoProvider.getLatestVideo(nextPage);
    }
    printLog(
        "shortVideoList length ==> ${latestVideoProvider.latestVideoList?.length}");
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
      // appBar: AppBar(
      //   backgroundColor: colorPrimaryDark,
      //   iconTheme: const IconThemeData(color: colorAccent),
      //   leading: Utils.backButton(context),
      // ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: colorPrimaryDark,
        child: _buildShort(),
      ),
    );
  }

/* Simple Short */
  Widget _buildShort() {
    return Consumer<LatestVideoProvider>(
      builder: (context, latestVideoProvider, child) {
        if (latestVideoProvider.latestVideoLoding) {
          return videoShimmer();
        } else {
          if (latestVideoProvider.latestVideoModel.status == 200) {
            if (latestVideoProvider.latestVideoList != null &&
                (latestVideoProvider.latestVideoList?.length ?? 0) > 0) {
              return _buildShortPageView(latestVideoProvider);
            } else {
              return const NoData();
            }
          } else {
            return const NoData();
          }
        }
      },
    );
  }

  Widget _buildShortPageView(LatestVideoProvider latestVideoProvider) {
    return PageView.builder(
      controller: _pageController,
      itemCount: latestVideoProvider.latestVideoList?.length ?? 0,
      scrollDirection: Axis.vertical,
      allowImplicitScrolling: true,
      /* Reels Pagination Content */
      onPageChanged: (value) async {
        if (value > 0 && (value % 2) == 0) {
          _fetchAllShort();
          currentIndex = value;
        }
        printLog("Your current index is $currentIndex");
        printLog("onPageChanged value ======> $value");
        printLog(
            "totalComment==>${latestVideoProvider.latestVideoList?[value].totalComment.toString() ?? ""}");
      },
      itemBuilder: (context, index) {
        printLog(
            "reels userId==>${latestVideoProvider.latestVideoList?[index].userId.toString() ?? ""}");
        printLog("userId==>${Constant.userId}");
        return Stack(
          // alignment: Alignment.bottomCenter,
          children: [
            /* Reels Video */
            VideoScreen(
              pagePos: index,
              thumbnailImg:
                  latestVideoProvider.latestVideoList?[index].image ?? "",
              videoId:
                  latestVideoProvider.latestVideoList?[index].id.toString() ??
                      "",
              videoUrl:
                  latestVideoProvider.latestVideoList?[index].videoUrl ?? "",
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
                child: Utils.backButton(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Expanded(child: SizedBox.shrink()),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () async {
                                if (Constant.userId == null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    ),
                                  );
                                } else {
                                  await latestVideoProvider.setLikeDislike(
                                      index,
                                      latestVideoProvider
                                              .latestVideoList?[index].id
                                              .toString() ??
                                          "");
                                }
                              },
                              icon: Icon(
                                (latestVideoProvider.latestVideoList?[index]
                                                .isUserLike ??
                                            0) ==
                                        1
                                    ? Icons.favorite
                                    : Icons.favorite_border_outlined,
                                size: 20,
                                color: (latestVideoProvider
                                                .latestVideoList?[index]
                                                .isUserLike ??
                                            0) ==
                                        1
                                    ? red
                                    : white,
                              )),
                          MyText(
                            text: Utils.kmbGenerator(latestVideoProvider
                                    .latestVideoList?[index].totalLike ??
                                0),
                            fontsize: Dimens.textTitle,
                            color: white,
                          ),
                          IconButton(
                              onPressed: () async {
                                await latestVideoProvider.getComment(
                                    latestVideoProvider
                                            .latestVideoList?[index].id
                                            .toString() ??
                                        "");

                                showComment(index);
                              },
                              icon: const Icon(
                                Icons.comment,
                                size: 20,
                                color: white,
                              )),
                          MyText(
                            text: Utils.kmbGenerator(latestVideoProvider
                                    .latestVideoList?[index].totalComment ??
                                0),
                            fontsize: Dimens.textTitle,
                            color: white,
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.more_vert_rounded,
                                size: 20,
                                color: white,
                              )),
                        ],
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailsPage(
                            id: latestVideoProvider
                                    .latestVideoList?[index].userId
                                    .toString() ??
                                ""),
                      ));
                    },
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: MyNetworkImage(
                              imgHeight: 50,
                              imgWidth: 50,
                              imageUrl: latestVideoProvider
                                      .latestVideoList?[index].userImage ??
                                  "",
                              fit: BoxFit.fill),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              text: latestVideoProvider
                                      .latestVideoList?[index].name
                                      .toString() ??
                                  "",
                              fontsize: Dimens.textTitle,
                              color: white,
                              fontwaight: FontWeight.w600,
                            ),
                            MyText(
                              text: latestVideoProvider
                                      .latestVideoList?[index].tags
                                      .toString() ??
                                  "",
                              fontsize: Dimens.textSmall,
                              color: white,
                              fontwaight: FontWeight.w400,
                            ),
                          ],
                        ),
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
                            if (Constant.userId == null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            } else {
                              await videoProvider.setComment(
                                  index,
                                  videoProvider.latestVideoList?[index].id
                                          .toString() ??
                                      "",
                                  _commentController.text.toString());
                            }

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

  // deleteAlertDialog(int index) {
  //   AlertDialog alertDialog = AlertDialog(
  //     title: const Column(
  //       children: [
  //         MyText(
  //           color: colorAccent,
  //           text: 'Comment',
  //           fontsize: 20,
  //           fontwaight: FontWeight.w500,
  //           maxline: 1,
  //         ),
  //         Divider(
  //           thickness: 2,
  //           height: 20,
  //           color: failureBG,
  //         )
  //       ],
  //     ),
  //     shadowColor: colorPrimaryDark,
  //     elevation: 10,
  //     backgroundColor: colorPrimaryDark,
  //     content: MyText(
  //       color: colorAccent,
  //       text: 'Are you sure delete the comment..!',
  //       fontsize: Dimens.textTitle,
  //       fontwaight: FontWeight.w500,
  //       maxline: 2,
  //       overflow: TextOverflow.ellipsis,
  //     ),
  //     actions: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Consumer<LatestVideoProvider>(
  //             builder: (context, videoProvider, child) {
  //               if (videoProvider.commentLoding) {
  //                 return const CircularProgressIndicator();
  //               } else {
  //                 if (videoProvider.successModel.status == 200) {
  //                   return ElevatedButton.icon(
  //                       onPressed: () async {
  //                         await videoProvider.deleteComment(
  //                             videoProvider.commentList?[index].id.toString() ??
  //                                 "",
  //                             Constant.userId ?? "");
  //                         Navigator.of(context).pop();
  //                         getApi(0);
  //                         await videoProvider.getCommentView(
  //                             videoProvider.commentList?[index].postId
  //                                     .toString() ??
  //                                 "",
  //                             0);
  //                       },
  //                       style: ButtonStyle(
  //                           backgroundColor: MaterialStateColor.resolveWith(
  //                               (states) => failureBG)),
  //                       icon: const Icon(
  //                         Icons.delete,
  //                         color: colorAccent,
  //                         size: 20,
  //                       ),
  //                       label: MyText(
  //                         color: colorAccent,
  //                         text: "Delete",
  //                         fontsize: 20,
  //                         fontwaight: FontWeight.w500,
  //                       ));
  //                 } else {
  //                   return const SizedBox.shrink();
  //                 }
  //               }
  //             },
  //           ),
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               style: ButtonStyle(
  //                   backgroundColor: MaterialStateColor.resolveWith(
  //                       (states) => colorAccent)),
  //               child: MyText(
  //                 color: colorPrimaryDark,
  //                 text: "Cancle",
  //                 fontsize: 20,
  //                 fontwaight: FontWeight.w500,
  //               ))
  //         ],
  //       ),
  //     ],
  //   );
  //   showDialog(
  //     context: context,
  //     builder: (context) => alertDialog,
  //   );
  // }

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

/* Video Shimmer Start */
  Widget videoShimmer() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CustomWidget.rectangular(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Row(
              children: [
                Expanded(child: SizedBox.shrink()),
                Column(
                  children: [
                    CustomWidget.roundcorner(height: 20, width: 30),
                    SizedBox(height: 3),
                    CustomWidget.roundcorner(height: 20, width: 30),
                    SizedBox(height: 10),
                    CustomWidget.roundcorner(height: 20, width: 30),
                    SizedBox(height: 3),
                    CustomWidget.roundcorner(height: 20, width: 30),
                    SizedBox(height: 3),
                    CustomWidget.circular(height: 50, width: 50),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                const CustomWidget.roundcorner(height: 20, width: 30),
                const SizedBox(width: 3),
                const CustomWidget.roundcorner(height: 20, width: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomWidget.roundcorner(
                      height: 20, width: MediaQuery.sizeOf(context).width),
                ),
                const SizedBox(width: 3),
                const CustomWidget.roundcorner(height: 20, width: 30),
              ],
            ),
            const SizedBox(height: 15),
          ],
        )
      ],
    );
  }
  /* End */
}
