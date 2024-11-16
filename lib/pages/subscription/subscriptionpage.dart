import 'package:dtcameo/pages/paymentoption.dart';
import 'package:dtcameo/provider/subscriptionprovider.dart';
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

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  SubscriptionProvider subscriptionProvider = SubscriptionProvider();

  @override
  void initState() {
    subscriptionProvider = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getApi();
    });
    super.initState();
  }

  Future<void> getApi() async {
    subscriptionProvider.setLoding(true);
    await subscriptionProvider.getPackages();
  }

  @override
  void dispose() {
    subscriptionProvider.clearProvider();
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
          color: white,
          text: 'subscription',
          multilanguage: true,
          fontsize: Dimens.textExtraBig,
          fontwaight: FontWeight.w600,
          fontstyle: FontStyle.normal,
        ),
      ),
      body: subscriptionData(),
    );
  }

  Widget subscriptionData() {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        if (subscriptionProvider.loaded) {
          return fShimmer();
        } else {
          if (subscriptionProvider.packageModel.status == 200 &&
              (subscriptionProvider.packageModel.result?.length ?? 0) > 0) {
            return AlignedGridView.count(
              crossAxisCount: 1,
              itemCount: subscriptionProvider.packageModel.result?.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentOption(
                              price: subscriptionProvider
                                      .packageModel.result?[index].price
                                      .toString() ??
                                  "",
                              description: subscriptionProvider
                                      .packageModel.result?[index].name ??
                                  "",
                              packageid: subscriptionProvider
                                      .packageModel.result?[index].id
                                      .toString() ??
                                  "",
                            )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      width: 350,
                      padding: const EdgeInsets.all(15),
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
                            imageUrl: subscriptionProvider
                                    .packageModel.result?[index].image ??
                                "",
                            fit: BoxFit.fill,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyText(
                                text: subscriptionProvider
                                        .packageModel.result?[index].name ??
                                    "",
                                fontsize: Dimens.textlargeBig,
                                fontwaight: FontWeight.w300,
                                color: white,
                              ),
                              MyText(
                                text:
                                    " ${subscriptionProvider.packageModel.result?[index].time ?? ""}  ${subscriptionProvider.packageModel.result?[index].type ?? ""}",
                                fontsize: Dimens.textBig,
                                fontwaight: FontWeight.w400,
                                color: white,
                              ),
                              MyText(
                                text:
                                    "${Constant.currencySymbol} ${subscriptionProvider.packageModel.result?[index].price ?? "0"}",
                                fontsize: Dimens.textExtraBig,
                                fontwaight: FontWeight.w800,
                                color: white,
                              ),
                            ],
                          )
                        ],
                      ),
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

  Widget fShimmer() {
    return AlignedGridView.count(
      crossAxisCount: 1,
      itemCount: 10,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Stack(
          alignment: Alignment.center,
          children: [
            CustomWidget.rectangular(
                height: 122, width: MediaQuery.sizeOf(context).width),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomWidget.roundcorner(height: 100, width: 120),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomWidget.roundcorner(height: 24, width: 69),
                    CustomWidget.roundcorner(height: 50, width: 130),
                  ],
                )
              ],
            )
          ],
        );
      },
    );
  }
}
