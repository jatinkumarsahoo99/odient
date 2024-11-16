import 'package:dtcameo/pages/detailspage.dart';
import 'package:dtcameo/provider/followlistprovider.dart';
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

class Following extends StatefulWidget {
  const Following({super.key});

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  final ScrollController _scrollController = ScrollController();
  late FollowListProvider followListProvider;

  @override
  void initState() {
    followListProvider =
        Provider.of<FollowListProvider>(context, listen: false);
    _scrollController.addListener(_nestedScrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getApi(0);
    });

    super.initState();
  }

/* scroller controller code and add listner */
  _nestedScrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (followListProvider.isMorePage ?? false)) {
      await followListProvider.setLoadMore(true);
      getApi(followListProvider.currentPage ?? 0);
    }
  }

  Future<void> getApi(int? pageNo) async {
    printLog("_fetchSectionDetails nextPage  ========> $pageNo");
    printLog(
        "_fetchSectionDetails isMorePage  ======> ${followListProvider.isMorePage}");
    printLog(
        "_fetchSectionDetails currentPage ======> ${followListProvider.currentPage}");
    printLog(
        "_fetchSectionDetails totalPage   ======> ${followListProvider.totalPage}");
    followListProvider.setLoding(true);
    await followListProvider.getFollowList(
        Constant.userId ?? "", (pageNo ?? 0) + 1);
    printLog(
        "rentDataList length ==> ${followListProvider.followList?.length}");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    followListProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      appBar: AppBar(
        backgroundColor: colorPrimaryDark,
        iconTheme: const IconThemeData(color: white),
        centerTitle: true,
        title: MyText(
          text: "following",
          color: white,
          multilanguage: true,
          fontsize: Dimens.textBig,
          fontwaight: FontWeight.w600,
        ),
      ),
      body: followList(),
    );
  }

  Widget followList() {
    return Consumer<FollowListProvider>(
      builder: (context, followListProvider, child) {
        if (followListProvider.loaded) {
          return followShimmer();
        } else {
          if (followListProvider.followList != null &&
              (followListProvider.followList?.length ?? 0) > 0) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  AlignedGridView.count(
                    crossAxisCount: 1,
                    itemCount: followListProvider.followList?.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        focusColor: transparent,
                        hoverColor: transparent,
                        highlightColor: transparent,
                        splashColor: transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                id: followListProvider.followList?[index].id
                                        .toString() ??
                                    "",
                                professionId: followListProvider
                                        .followList?[index].professionId
                                        .toString() ??
                                    "",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: MyNetworkImage(
                                  imgWidth: 50,
                                  imgHeight: 50,
                                  imageUrl: followListProvider
                                          .followList?[index].image ??
                                      "",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      text: followListProvider
                                              .followList?[index].fullName ??
                                          "",
                                      color: white,
                                      fontwaight: FontWeight.w600,
                                      fontsize: Dimens.textTitle,
                                    ),
                                    MyText(
                                      color: white,
                                      text: followListProvider
                                              .followList?[index].profession ??
                                          "",
                                      fontsize: Dimens.textMedium,
                                      fontwaight: FontWeight.w200,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                children: [
                                  MyText(
                                    color: white,
                                    text: 'followers',
                                    fontsize: Dimens.textMedium,
                                    multilanguage: true,
                                    fontwaight: FontWeight.w200,
                                  ),
                                  MyText(
                                    fontsize: Dimens.textMedium,
                                    color: colorAccent,
                                    text: Utils.kmbGenerator(followListProvider
                                            .followList?[index].followers ??
                                        0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  /* Pagination loader */
                  Consumer<FollowListProvider>(
                    builder: (context, sectionViewAllProvider, child) {
                      if (sectionViewAllProvider.loadMore) {
                        return SizedBox(height: 50, child: Utils.pageLoader());
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
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

  Widget followShimmer() {
    return AlignedGridView.count(
        crossAxisCount: 1,
        itemCount: 10,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorPrimary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: const CustomWidget.circular(height: 50, width: 50),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomWidget.roundrectborder(height: 8, width: 100),
                      CustomWidget.roundrectborder(height: 8, width: 100),
                    ],
                  ),
                  const Spacer(flex: 1),
                  const Column(
                    children: [
                      CustomWidget.roundrectborder(height: 8, width: 50),
                      CustomWidget.roundrectborder(height: 8, width: 50),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
