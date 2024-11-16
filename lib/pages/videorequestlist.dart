import 'package:dtcameo/chatmodel/model/questionrequestmodel.dart';
import 'package:dtcameo/provider/rquestprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/nodata.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoRequestList extends StatefulWidget {
  final String requestId;
  const VideoRequestList({super.key, required this.requestId});

  @override
  State<VideoRequestList> createState() => _VideoRequestListState();
}

class _VideoRequestListState extends State<VideoRequestList> {
  RequestProvider requestProvider = RequestProvider();
  @override
  void initState() {
    requestProvider = Provider.of<RequestProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getApi();
    });
  }

  Future<void> getApi() async {
    requestProvider.setLoding(true);
    await requestProvider.getQuestionData(widget.requestId);
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
          text: "#${widget.requestId.toString()}",
          color: white,
          fontsize: Dimens.textBig,
          fontwaight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          children: [
            questionShow(),
          ],
        ),
      ),
    );
  }

  Widget questionShow() {
    return Consumer<RequestProvider>(
      builder: (context, requestProvider, child) {
        if (requestProvider.loaded) {
          return shimmerQuestion();
        } else {
          if (requestProvider.questionRequestModel.status == 200 &&
              (requestProvider.questionRequestModel.result?.length ?? 0) > 0) {
            return ListView.builder(
              itemCount: requestProvider.questionRequestModel.result?.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: "from",
                      multilanguage: true,
                      maxline: 2,
                      fontsize: Dimens.textBig,
                      color: grey,
                      fontwaight: FontWeight.w500,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 48,
                      width: MediaQuery.sizeOf(context).width,
                      padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: colorPrimary,
                          boxShadow: const [
                            BoxShadow(
                                color: colorAccent,
                                blurRadius: 4,
                                blurStyle: BlurStyle.outer)
                          ],
                          borderRadius: BorderRadius.circular(34)),
                      child: MyText(
                        text: requestProvider
                                .questionRequestModel.result?[index].userName ??
                            "",
                        maxline: 2,
                        fontsize: Dimens.textTitle,
                        color: grey,
                        fontwaight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyText(
                      text: "topic1",
                      multilanguage: true,
                      maxline: 2,
                      fontsize: Dimens.textBig,
                      color: grey,
                      fontwaight: FontWeight.w500,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 48,
                      width: MediaQuery.sizeOf(context).width,
                      padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: colorPrimary,
                          boxShadow: const [
                            BoxShadow(
                                color: colorAccent,
                                blurRadius: 4,
                                blurStyle: BlurStyle.outer)
                          ],
                          borderRadius: BorderRadius.circular(34)),
                      child: MyText(
                        text: requestProvider.questionRequestModel
                                .result?[index].categoryName ??
                            "",
                        maxline: 2,
                        fontsize: Dimens.textTitle,
                        color: grey,
                        fontwaight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyText(
                      text: "whoisthisvideofor",
                      multilanguage: true,
                      maxline: 2,
                      fontsize: Dimens.textBig,
                      color: grey,
                      fontwaight: FontWeight.w500,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 48,
                      width: MediaQuery.sizeOf(context).width,
                      padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: colorPrimary,
                          boxShadow: const [
                            BoxShadow(
                                color: colorAccent,
                                blurRadius: 4,
                                blurStyle: BlurStyle.outer)
                          ],
                          borderRadius: BorderRadius.circular(34)),
                      child: MyText(
                        text: requestProvider
                                .questionRequestModel.result?[index].fullName ??
                            "",
                        maxline: 2,
                        fontsize: Dimens.textTitle,
                        color: grey,
                        fontwaight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(
                      height: 30,
                      thickness: 2,
                      color: grey,
                    ),
                    questionShowDataShow(requestProvider
                        .questionRequestModel.result?[index].questiondata),
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

  Widget questionShowDataShow(List<Questiondatum>? questionList) {
    return Consumer<RequestProvider>(
      builder: (context, requestProvider, child) {
        if ((questionList?.length ?? 0) > 0) {
          return ListView.builder(
            itemCount: questionList?.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: questionList?[index].question ?? "",
                    maxline: 2,
                    fontsize: Dimens.textBig,
                    color: grey,
                    fontwaight: FontWeight.w500,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 48,
                    width: MediaQuery.sizeOf(context).width,
                    padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: colorPrimary,
                        boxShadow: const [
                          BoxShadow(
                              color: colorAccent,
                              blurRadius: 4,
                              blurStyle: BlurStyle.outer)
                        ],
                        borderRadius: BorderRadius.circular(34)),
                    child: MyText(
                      text: questionList?[index].answer ?? "",
                      maxline: 2,
                      fontsize: Dimens.textTitle,
                      color: grey,
                      fontwaight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget shimmerQuestion() {
    return ListView.builder(
      itemCount: 8,
      shrinkWrap: true,
      // padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomWidget.roundcorner(height: 20, width: 150),
            const SizedBox(height: 10),
            CustomWidget.roundcorner(
                height: 40, width: MediaQuery.sizeOf(context).width),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
