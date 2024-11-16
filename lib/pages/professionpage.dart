import 'package:dtcameo/pages/detailspage.dart';
import 'package:dtcameo/provider/professionprovider.dart';
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

class ProfessionPage extends StatefulWidget {
  final String? professionId,title;
  const ProfessionPage({super.key, required this.professionId,required this.title});

  @override
  State<ProfessionPage> createState() => _ProfessionPageState();
}

class _ProfessionPageState extends State<ProfessionPage> {
  final ScrollController _scrollController = ScrollController();
  ProfessionProvider professionProvider = ProfessionProvider();

  @override
  void initState() {
    professionProvider =
        Provider.of<ProfessionProvider>(context, listen: false);
    _scrollController.addListener(_scrollListener);
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
        (professionProvider.currentPage ?? 0) <
            (professionProvider.totalPage ?? 0)) {
      printLog("-----?? api call page 2 ");
      professionProvider.setLoadMore(true);
      _fetchData(professionProvider.currentPage ?? 0);
    }
  }

  Future<void> _fetchData(int? nextPage) async {
    // printLog("viewType  =======> ${widget.type}");
    printLog("morePage  =======> ${professionProvider.isMorePage}");
    printLog("currentPage =====> ${professionProvider.currentPage}");
    printLog("totalPage   =====> ${professionProvider.totalPage}");
    professionProvider.setLoding(true);
    await professionProvider.getProfession(widget.professionId ?? "");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    professionProvider.clearProvider();
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
        title: MyText(
          text: widget.title ?? "",
          fontsize: Dimens.textlargeBig,
          fontwaight: FontWeight.w600,
          color: white,
        ),
      ),
      body: professionData(),
    );
  }

  /* Featured Data Start  */
  Widget professionData() {
    return Consumer<ProfessionProvider>(
      builder: (context, professionProvider, child) {
        if (professionProvider.loaded) {
          return professionShimmer();
        } else {
          if (professionProvider.professionList != null &&
              (professionProvider.professionList?.length ?? 0) > 0) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  AlignedGridView.count(
                    crossAxisCount: 3,
                    itemCount: professionProvider.professionList?.length,
                    shrinkWrap: true,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                id: professionProvider.professionList?[index].id
                                        .toString() ??
                                    "",
                                professionId: professionProvider
                                        .professionList?[index].professionId
                                        .toString() ??
                                    "",
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: const [
                                    BoxShadow(color: colorAccent, blurRadius: 4)
                                  ]),
                              child: MyNetworkImage(
                                imgHeight: 150,
                                imgWidth: MediaQuery.of(context).size.width,
                                imageUrl: professionProvider
                                        .professionList?[index].image ??
                                    "",
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(height: 5),
                            MyText(
                              text: professionProvider
                                      .professionList?[index].fullName ??
                                  "",
                              color: white,
                              fontwaight: FontWeight.w700,
                              fontsize: Dimens.textTitle,
                            ),
                            const SizedBox(height: 5),
                            MyText(
                              text: professionProvider
                                      .professionList?[index].profession ??
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
                                  "${Constant.currencySymbol} ${professionProvider.professionList?[index].fees.toString() ?? ""}",
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
                  Consumer<ProfessionProvider>(
                    builder: (context, sectionViewAllProvider, child) {
                      if (sectionViewAllProvider.loadMore) {
                        return professionShimmer();
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

  Widget professionShimmer() {
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
