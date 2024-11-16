import 'package:dtcameo/pages/detailspage.dart';
import 'package:dtcameo/pages/message.dart';
import 'package:dtcameo/provider/orderprovider.dart';
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

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  final ScrollController _scrollController = ScrollController();

  OrderProvider orderProvider = OrderProvider();

  @override
  void initState() {
    orderProvider = Provider.of<OrderProvider>(context, listen: false);
    _scrollController.addListener(_nestedScroller);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getApi(0);
    });
    super.initState();
  }

  _nestedScroller() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (orderProvider.currentPage ?? 0) < (orderProvider.totalPage ?? 0)) {
      orderProvider.setLodMore(true);
      getApi(orderProvider.currentPage ?? 0);
    }
  }

  Future<void> getApi(int? pageNo) async {
    orderProvider.setLoding(true);
    await orderProvider.getUserVideoList((pageNo ?? 0) + 1);
  }

  @override
  void dispose() {
    orderProvider.clearProvider();
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
        centerTitle: false,
        title: MyText(
          text: "allorders",
          multilanguage: true,
          fontsize: Dimens.textTitle,
          fontwaight: FontWeight.w600,
          color: white,
        ),
      ),
      body: SafeArea(
        child: buildOrder(),
      ),
    );
  }

  Widget buildOrder() {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        if (orderProvider.orederLoding) {
          return shimmer();
        } else {
          if (orderProvider.orderList != null &&
              (orderProvider.orderList?.length ?? 0) > 0) {
            return SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: Column(
                children: [
                  AlignedGridView.count(
                    crossAxisCount: 2,
                    itemCount: orderProvider.orderList?.length,
                    shrinkWrap: true,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                      id: orderProvider
                                              .orderList?[index].toUserId
                                              .toString() ??
                                          ""),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              child: MyNetworkImage(
                                imgWidth: 191,
                                imgHeight: 165,
                                imageUrl: orderProvider
                                        .orderList?[index].artistImage ??
                                    "",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => DetailsPage(
                                          id: orderProvider
                                                  .orderList?[index].toUserId
                                                  .toString() ??
                                              ""),
                                    ));
                                  },
                                  child: MyText(
                                    text: orderProvider
                                            .orderList?[index].artistName ??
                                        "",
                                    fontsize: Dimens.textTitle,
                                    fontwaight: FontWeight.w600,
                                    color: white,
                                  ),
                                ),
                              ),
                              MyText(
                                text:
                                    "#${orderProvider.orderList?[index].id.toString() ?? ""}",
                                fontsize: Dimens.textMedium,
                                fontwaight: FontWeight.w400,
                                color: yellow,
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          MyText(
                            text:
                                orderProvider.orderList?[index].categoryName ??
                                    "",
                            fontsize: Dimens.textMedium,
                            fontwaight: FontWeight.w600,
                            color: colorAccent,
                          ),
                          const SizedBox(height: 3),
                          orderProvider.orderList?[index].videoFor == 0
                              ? MyText(
                                  text:
                                      "MySelf : ${orderProvider.orderList?[index].fullName ?? ""}",
                                  fontsize: Dimens.textMedium,
                                  maxline: 2,
                                  overflow: TextOverflow.ellipsis,
                                  fontwaight: FontWeight.w400,
                                  color: white,
                                )
                              : MyText(
                                  text:
                                      "Some one Else : ${orderProvider.orderList?[index].fullName ?? ""}",
                                  fontsize: Dimens.textMedium,
                                  maxline: 2,
                                  overflow: TextOverflow.ellipsis,
                                  fontwaight: FontWeight.w400,
                                  color: white,
                                ),
                          const SizedBox(height: 3),
                          MyText(
                            text:
                                "${Constant.currencySymbol} ${orderProvider.orderList?[index].fees.toString() ?? ""}",
                            fontsize: Dimens.textMedium,
                            fontwaight: FontWeight.w700,
                            color: orange,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 35,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: (orderProvider
                                                    .orderList?[index].status ??
                                                0) ==
                                            0
                                        ? orange
                                        : (orderProvider.orderList?[index]
                                                        .status ??
                                                    0) ==
                                                1
                                            ? lightGrey
                                            : colorAccent,
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: MyText(
                                      text: (orderProvider.orderList?[index]
                                                      .status ??
                                                  0) ==
                                              0
                                          ? "draft"
                                          : (orderProvider.orderList?[index]
                                                          .status ??
                                                      0) ==
                                                  1
                                              ? "pending"
                                              : "success",
                                      multilanguage: true,
                                      fontstyle: FontStyle.normal,
                                      fontsize: Dimens.textTitle,
                                      fontwaight: FontWeight.w700,
                                      color: white,
                                    ),
                                  ),
                                ),
                              ),
                              (orderProvider.orderList?[index].status ?? 0) == 2
                                  ? Container(
                                      height: 35,
                                      width: 63,
                                      decoration: const BoxDecoration(
                                        color: white,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_downward,
                                        color: colorAccent,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => Message(
                                              toUserName: orderProvider
                                                      .orderList?[index]
                                                      .artistName ??
                                                  "",
                                              toChatId: orderProvider
                                                      .orderList?[index]
                                                      .artistFirebaseId ??
                                                  "",
                                              profileImg: orderProvider
                                                  .orderList?[index]
                                                  .artistImage,
                                              bioData: orderProvider
                                                      .orderList?[index]
                                                      .artistBio ??
                                                  ""),
                                        ));
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 63,
                                        decoration: const BoxDecoration(
                                          color: white,
                                        ),
                                        child: const Icon(
                                          Icons.chat,
                                          color: colorAccent,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  /* Pagination */
                  Consumer<OrderProvider>(
                    builder: (context, orderProvider, child) {
                      if (orderProvider.loadMore) {
                        return shimmer();
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

  Widget shimmer() {
    return AlignedGridView.count(
      crossAxisCount: 2,
      itemCount: 15,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const Stack(
          children: [
            CustomWidget.rectangular(height: 300, width: 191),
            CustomWidget.rectangular(height: 160, width: 191),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 170, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  CustomWidget.roundcorner(height: 18, width: 100),
                  SizedBox(height: 1),
                  CustomWidget.roundcorner(height: 17, width: 100),
                  SizedBox(height: 1),
                  CustomWidget.roundcorner(height: 17, width: 150),
                  SizedBox(height: 1),
                  Row(
                    children: [
                      Expanded(
                          child:
                              CustomWidget.rectangular(height: 35, width: 126)),
                      CustomWidget.rectangular(height: 35, width: 63),
                    ],
                  ),
                  SizedBox(height: 3),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
