import 'package:dtcameo/provider/notificationprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mynetworkimmage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/nodata.dart';
import 'package:dtcameo/widget/customwidget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late NotificationProvider notificationProvider;

  @override
  void initState() {
    notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getApi();
    });
  }

  Future<void> getApi() async {
    notificationProvider.setLoding(true);
    await notificationProvider.getNotification(Constant.userId ?? "");
    await notificationProvider.getProfile(Constant.userId ?? "");
  }

  @override
  void dispose() {
    notificationProvider.clearProvider();
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
          text: "notif",
          multilanguage: true,
          fontsize: Dimens.textlargeBig,
          color: white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            notificationData(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget notificationData() {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        if (notificationProvider.loaded) {
          return notificatonShimmer();
        } else {
          if (notificationProvider.notificationModel.status == 200 &&
              (notificationProvider.notificationModel.result?.length ?? 0) >
                  0) {
            return ListView.builder(
              itemCount: notificationProvider.notificationModel.result?.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      color: white,
                      text: Utils.dateTimeShow(notificationProvider
                              .notificationModel.result?[index].createdAt ??
                          ""),
                      fontsize: Dimens.textTitle,
                      fontwaight: FontWeight.bold,
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        await notificationProvider.readNotification(
                            Constant.userId ?? "",
                            notificationProvider.notificationModel.result?[0].id
                                    .toString() ??
                                "");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: MyNetworkImage(
                              imgWidth: 50,
                              imgHeight: 50,
                              imageUrl: notificationProvider
                                      .notificationModel.result?[0].image ??
                                  "",
                              fit: BoxFit.fill,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  MyText(
                                    text: notificationProvider.notificationModel
                                            .result?[index].title ??
                                        "",
                                    color: white,
                                    fontwaight: FontWeight.w600,
                                    fontsize: Dimens.textTitle,
                                  ),
                                  const SizedBox(width: 5),
                                  MyText(
                                    text: 'secondary',
                                    color: white,
                                    multilanguage: true,
                                    fontwaight: FontWeight.w300,
                                    fontsize: Dimens.textTitle,
                                  ),
                                ],
                              ),
                              MyText(
                                color: white,
                                text: Utils.timeShow(notificationProvider
                                        .notificationModel
                                        .result?[index]
                                        .createdAt ??
                                    ""),
                                fontsize: Dimens.textMedium,
                                fontwaight: FontWeight.w200,
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: MyNetworkImage(
                              imgWidth: 50,
                              imgHeight: 50,
                              imageUrl: notificationProvider
                                      .profileModel.result?[0].image ??
                                  "",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
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

  Widget notificatonShimmer() {
    return ListView.builder(
      itemCount: 15,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomWidget.circular(
              height: 50,
              width: 50,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomWidget.roundcorner(
                  height: 17,
                  width: 150,
                ),
                CustomWidget.roundcorner(
                  height: 12,
                  width: 50,
                )
              ],
            ),
            CustomWidget.circular(
              height: 50,
              width: 50,
            )
          ],
        );
      },
    );
  }
}
