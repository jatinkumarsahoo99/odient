import 'package:dtcameo/pages/detailspage.dart';
import 'package:dtcameo/provider/categoryprovider.dart';
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

class CategoriesScreen extends StatefulWidget {
  final String? id;
  const CategoriesScreen({super.key, required this.id});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late CategoryProvider categoryProvider;
  final _scrollController = ScrollController();

  @override
  void initState() {
    categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    _scrollController.addListener(_nestedScrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAPi(0);
    });
    super.initState();
  }

  _nestedScrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (categoryProvider.isMorePage ?? false)) {
      await categoryProvider.setLoadMore(true);
      getAPi(categoryProvider.currentPage ?? 0);
    }
  }

  Future<void> getAPi(int? pageno) async {
    printLog("_fetchSectionDetails nextPage  ========> $pageno");
    printLog(
        "_fetchSectionDetails isMorePage  ======> ${categoryProvider.isMorePage}");
    printLog(
        "_fetchSectionDetails currentPage ======> ${categoryProvider.currentPage}");
    printLog(
        "_fetchSectionDetails totalPage   ======> ${categoryProvider.totalPage}");
    categoryProvider.setLoding(true);
    await categoryProvider.getProfession(widget.id ?? "", (pageno ?? 0) + 1);
    printLog(
        "rentDataList length ==> ${categoryProvider.reletedArtistList?.length}");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    categoryProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorPrimaryDark,
        appBar: AppBar(
          leading: Utils.backButton(context),
          backgroundColor: colorPrimaryDark,
          iconTheme: const IconThemeData(color: white),
        ),
        body: shimilarCategoryData());
  }

  Widget shimilarCategoryData() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        if (categoryProvider.loaded) {
          return fetauredShimmer();
        }
        if (categoryProvider.reletedArtistList != null &&
            (categoryProvider.reletedArtistList?.length ?? 0) > 0) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                AlignedGridView.count(
                  crossAxisCount: 3,
                  itemCount: categoryProvider.reletedArtistList?.length,
                  shrinkWrap: true,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  padding: const EdgeInsets.all(10),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsPage(
                              id: categoryProvider.reletedArtistList?[index].id
                                      .toString() ??
                                  "",
                              professionId: categoryProvider
                                      .reletedArtistList?[index].professionId
                                      .toString() ??
                                  "",
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyNetworkImage(
                            imgHeight: 150,
                            imgWidth: MediaQuery.of(context).size.width,
                            imageUrl: categoryProvider
                                    .reletedArtistList?[index].image ??
                                "",
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 5),
                          MyText(
                            text: categoryProvider
                                    .reletedArtistList?[index].fullName ??
                                "",
                            color: white,
                            fontwaight: FontWeight.w700,
                            fontsize: Dimens.textTitle,
                          ),
                          const SizedBox(height: 5),
                          MyText(
                            text: categoryProvider
                                    .reletedArtistList?[index].profession ??
                                "",
                            color: white,
                            maxline: 2,
                            overflow: TextOverflow.ellipsis,
                            fontwaight: FontWeight.w300,
                            fontsize: Dimens.textSmall,
                          ),
                          const SizedBox(height: 5),
                          MyText(
                            text:
                                "${Constant.currencySymbol} ${categoryProvider.reletedArtistList?[index].fees.toString() ?? ""}",
                            color: white,
                            fontwaight: FontWeight.w700,
                            fontsize: Dimens.textSmall,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                /* Pagination loader */
                Consumer<CategoryProvider>(
                  builder: (context, sectionViewAllProvider, child) {
                    if (sectionViewAllProvider.loadMore) {
                      return fetauredShimmer();
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
      },
    );
  }

  Widget fetauredShimmer() {
    return AlignedGridView.count(
      crossAxisCount: 3,
      itemCount: 10,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
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
}
