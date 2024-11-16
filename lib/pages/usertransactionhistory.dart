import 'package:dtcameo/provider/histroyprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/nodata.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class UserTransactionHistory extends StatefulWidget {
  const UserTransactionHistory({super.key});

  @override
  State<UserTransactionHistory> createState() => _UserTransactionHistoryState();
}

class _UserTransactionHistoryState extends State<UserTransactionHistory> {
  HistroyProvider histroyProvider = HistroyProvider();
  @override
  void initState() {
    histroyProvider = Provider.of<HistroyProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getApi();
    });
    super.initState();
  }

  Future<void> getApi() async {
    histroyProvider.setLoding(true);
    await histroyProvider.getUserTransaction(Constant.userId ?? "");
  }

  @override
  void dispose() {
    histroyProvider.clearProvider();
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
          text: 'usertransacationhistory',
          multilanguage: true,
          fontsize: Dimens.textlargeBig,
          color: white,
          fontwaight: FontWeight.w600,
        ),
      ),
      body: historyShow(),
    );
  }

  Widget historyShow() {
    return Consumer<HistroyProvider>(
      builder: (context, histroyProvider, child) {
        if (histroyProvider.subscripLoding) {
          return historyShimmer();
        } else {
          if (histroyProvider.userTranscationModel.status == 200 &&
              (histroyProvider.userTranscationModel.result?.length ?? 0) > 0) {
            return SingleChildScrollView(
              child: AlignedGridView.count(
                crossAxisCount: 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: histroyProvider.userTranscationModel.result?.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: colorPrimary,
                    ),
                    margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text:
                              "UserName : ${histroyProvider.userTranscationModel.result?[index].userName ?? ""}",
                          fontsize:Dimens.textBig,
                          fontwaight: FontWeight.w600,
                          color: white,
                        ),
                        const SizedBox(height: 8),
                        MyText(
                          text:
                              "Artist Name : ${histroyProvider.userTranscationModel.result?[index].artistName ?? ""}",
                          fontsize: Dimens.textTitle,
                          fontwaight: FontWeight.w600,
                          color: white,
                        ),
                        const SizedBox(height: 8),
                        MyText(
                          text:
                              "Price : ${histroyProvider.userTranscationModel.result?[index].fees ?? ""}",
                          fontsize: Dimens.textTitle,
                          fontwaight: FontWeight.w600,
                          color: white,
                        ),
                        const SizedBox(height: 8),
                        MyText(
                          text:
                              "Expiry Date : ${Utils.dateTimeShow(histroyProvider.userTranscationModel.result?[index].date.toString() ?? "")}",
                          fontsize: Dimens.textTitle,
                          fontwaight: FontWeight.w600,
                          color: white,
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
    );
  }

  Widget historyShimmer() {
    return ListView.builder(
      itemCount: 15,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: colorPrimary,
          ),
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomWidget.roundcorner(
                height: 8,
                width: 210,
              ),
              CustomWidget.roundcorner(
                height: 8,
                width: 210,
              ),
              CustomWidget.roundcorner(
                height: 8,
                width: 210,
              ),
              CustomWidget.roundcorner(
                height: 8,
                width: 210,
              ),
            ],
          ),
        );
      },
    );
  }
}
