import 'package:dtcameo/pages/message.dart';
import 'package:dtcameo/pages/uploadvideo.dart';
import 'package:dtcameo/pages/videoplayer.dart';
import 'package:dtcameo/pages/videorequestlist.dart';
import 'package:dtcameo/provider/rquestprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/shareperf.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/nodata.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class VideoRequestPage extends StatefulWidget {
  const VideoRequestPage({super.key});

  @override
  State<VideoRequestPage> createState() => _VideoRequestPageState();
}

class _VideoRequestPageState extends State<VideoRequestPage> {
  String? name, profileImage, bioData, firebaseID, number;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  SharePre sharePre = SharePre();
  late RequestProvider requestProvider;

  @override
  void initState() {
    requestProvider = Provider.of<RequestProvider>(context, listen: false);
    _scrollController.addListener(_scrollListener);
    getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData("0", 0);
    });
    super.initState();
  }

  getData() async {
    name = await sharePre.read("username");
    profileImage = await sharePre.read("image");
    bioData = await sharePre.read("bio");
    firebaseID = await sharePre.read("firebaseid");
    number = await sharePre.read("mobilenumber");
  }

/* scroller controller code and add listner */
  _scrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (requestProvider.isMorePage ?? false)) {
      await requestProvider.setLoadMore(true);
      if (requestProvider.layoutType == Constant.draftType) {
        _fetchData("0", requestProvider.currentPage ?? 0);
      } else if (requestProvider.layoutType == Constant.pendingType) {
        _fetchData("1", requestProvider.currentPage ?? 0);
      } else if (requestProvider.layoutType == Constant.successType) {
        _fetchData("2", requestProvider.currentPage ?? 0);
      } else {
        _fetchData("3", requestProvider.currentPage ?? 0);
      }
    }
  }

  _fetchData(type, pageNo) async {
    requestProvider.setLoding(true);
    await requestProvider.getAristVideoReuest(
        Constant.userId ?? "", type, (pageNo ?? 0) + 1);
  }

  @override
  void dispose() {
    requestProvider.clearProvider();
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
            text: "videorequestlist",
            color: white,
            multilanguage: true,
            fontsize: Dimens.textBig,
            fontwaight: FontWeight.w600,
          ),
          actions: [
            IconButton(
              onPressed: () {
                _refreshIndicatorKey.currentState?.show();
                if (requestProvider.layoutType == Constant.draftType) {
                  _fetchData("0", 0);
                } else if (requestProvider.layoutType == Constant.pendingType) {
                  _fetchData("1", 0);
                } else if (requestProvider.layoutType == Constant.successType) {
                  _fetchData("2", 0);
                } else {
                  _fetchData("3", 0);
                }
              },
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        body: Column(
          children: [
            _buildTab(),
            Expanded(
                child: RefreshIndicator(
              key: _refreshIndicatorKey,
              backgroundColor: colorAccent,
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              color: white,
              onRefresh: () async {
                if (requestProvider.layoutType == Constant.draftType) {
                  await requestProvider.clearContent();
                  _fetchData("0", 0);
                } else if (requestProvider.layoutType == Constant.pendingType) {
                  await requestProvider.clearContent();
                  _fetchData("1", 0);
                } else if (requestProvider.layoutType == Constant.successType) {
                  await requestProvider.clearContent();
                  _fetchData("2", 0);
                } else {
                  await requestProvider.clearContent();
                  _fetchData("3", 0);
                }
              },
              child: _buildTypeData(),
            )),
          ],
        ));
  }

  Widget _buildTab() {
    return Consumer<RequestProvider>(
      builder: (context, requestProvider, child) {
        return Container(
          width: MediaQuery.sizeOf(context).width,
          height: 60,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  focusColor: transparent,
                  splashColor: transparent,
                  highlightColor: transparent,
                  hoverColor: transparent,
                  onTap: () async {
                    await requestProvider.setLayoutType(Constant.draftType);
                    await requestProvider.clearContent();
                    _fetchData("0", 0);
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 40,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: requestProvider.layoutType == Constant.draftType
                            ? colorAccent
                            : transparent,
                        borderRadius: BorderRadius.circular(20)),
                    child: MyText(
                      text: 'draft',
                      multilanguage: true,
                      maxline: 2,
                      fontsize: Dimens.textTitle,
                      fontwaight: FontWeight.w500,
                      color: white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  focusColor: transparent,
                  splashColor: transparent,
                  highlightColor: transparent,
                  hoverColor: transparent,
                  onTap: () async {
                    await requestProvider.setLayoutType(Constant.pendingType);
                    await requestProvider.clearContent();
                    _fetchData("1", 0);
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 40,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color:
                            requestProvider.layoutType == Constant.pendingType
                                ? colorAccent
                                : transparent,
                        borderRadius: BorderRadius.circular(20)),
                    child: MyText(
                      text: 'pending',
                      multilanguage: true,
                      maxline: 2,
                      fontsize: Dimens.textTitle,
                      fontwaight: FontWeight.w500,
                      color: white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  focusColor: transparent,
                  splashColor: transparent,
                  highlightColor: transparent,
                  hoverColor: transparent,
                  onTap: () async {
                    await requestProvider.setLayoutType(Constant.successType);
                    await requestProvider.clearContent();
                    _fetchData("2", 0);
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 40,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color:
                            requestProvider.layoutType == Constant.successType
                                ? colorAccent
                                : transparent,
                        borderRadius: BorderRadius.circular(20)),
                    child: MyText(
                      text: 'success',
                      multilanguage: true,
                      maxline: 2,
                      fontsize: Dimens.textTitle,
                      fontwaight: FontWeight.w500,
                      color: white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  focusColor: transparent,
                  splashColor: transparent,
                  highlightColor: transparent,
                  hoverColor: transparent,
                  onTap: () async {
                    await requestProvider.setLayoutType(Constant.rejectedType);
                    await requestProvider.clearContent();
                    _fetchData("3", 0);
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 40,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color:
                            requestProvider.layoutType == Constant.rejectedType
                                ? colorAccent
                                : transparent,
                        borderRadius: BorderRadius.circular(20)),
                    child: MyText(
                      text: 'rejected',
                      multilanguage: true,
                      maxline: 2,
                      fontsize: Dimens.textTitle,
                      fontwaight: FontWeight.w500,
                      color: white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypeData() {
    return Consumer<RequestProvider>(
      builder: (context, requestProvider, child) {
        if (requestProvider.layoutType == Constant.draftType) {
          return draftRequest();
        } else if (requestProvider.layoutType == Constant.pendingType) {
          return pendingRequest();
        } else if (requestProvider.layoutType == Constant.successType) {
          return successRequest();
        } else {
          return rejectedData();
        }
      },
    );
  }

  Widget draftRequest() {
    return Consumer<RequestProvider>(
      builder: (context, requestProvider, child) {
        if (requestProvider.loaded && !requestProvider.loadMore) {
          return shimmer();
        } else {
          if (requestProvider.requestLsit != null &&
              (requestProvider.requestLsit?.length ?? 0) > 0) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  AlignedGridView.count(
                    crossAxisCount: 1,
                    padding: const EdgeInsets.all(15),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    itemCount: requestProvider.requestLsit?.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VideoRequestList(
                                  requestId: requestProvider
                                          .requestLsit?[index].id
                                          .toString() ??
                                      "")));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.sizeOf(context).width,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        MyText(
                                          text:
                                              "#${requestProvider.requestLsit?[index].id.toString() ?? ""}",
                                          color: yellow,
                                          fontsize: Dimens.textMedium,
                                          fontwaight: FontWeight.w500,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: MyText(
                                            text: requestProvider
                                                    .requestLsit?[index]
                                                    .fullName ??
                                                "",
                                            color: white,
                                            maxline: 2,
                                            overflow: TextOverflow.ellipsis,
                                            fontsize: Dimens.textMedium,
                                            fontwaight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        MyText(
                                          text: "topic",
                                          multilanguage: true,
                                          color: white,
                                          fontsize: Dimens.textMedium,
                                          fontwaight: FontWeight.w500,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: MyText(
                                            text: requestProvider
                                                    .requestLsit?[index]
                                                    .categoryName
                                                    .toString() ??
                                                "",
                                            color: colorAccent,
                                            fontsize: Dimens.textMedium,
                                            fontwaight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      Utils().showProgress(context);
                                      await requestProvider.uploadVideoStatus(
                                          requestProvider
                                                  .artistVideoRequestModel
                                                  .result?[index]
                                                  .id
                                                  .toString() ??
                                              "",
                                          Constant.rejectedType);
                                      if (requestProvider
                                              .uploadVideoModel.status ==
                                          200) {
                                        Utils.hideProgress();
                                        Utils.showSnackbar(
                                            context,
                                            "success",
                                            requestProvider
                                                    .uploadVideoModel.message ??
                                                "",
                                            false);
                                        await requestProvider.clearContent();
                                        _fetchData("0", 0);
                                      } else {
                                        Utils.hideProgress();
                                        Utils.showSnackbar(
                                            context,
                                            "fail",
                                            requestProvider
                                                    .uploadVideoModel.message ??
                                                "",
                                            false);
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 5, 15, 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: colorAccent),
                                      child: MyText(
                                        text: 'rejected',
                                        multilanguage: true,
                                        color: white,
                                        fontsize: Dimens.textMedium,
                                        fontwaight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () async {
                                      Utils().showProgress(context);
                                      await requestProvider.uploadVideoStatus(
                                          requestProvider
                                                  .artistVideoRequestModel
                                                  .result?[index]
                                                  .id
                                                  .toString() ??
                                              "",
                                          Constant.pendingType);

                                      if (requestProvider
                                              .uploadVideoModel.status ==
                                          200) {
                                        Utils.hideProgress();
                                        Utils.showSnackbar(
                                            context,
                                            "success",
                                            requestProvider
                                                    .uploadVideoModel.message ??
                                                "",
                                            false);
                                        await requestProvider.clearContent();
                                        _fetchData("0", 0);
                                      } else {
                                        Utils.hideProgress();
                                        Utils.showSnackbar(
                                            context,
                                            "fail",
                                            requestProvider
                                                    .uploadVideoModel.message ??
                                                "",
                                            false);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 5, 15, 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: colorAccent,
                                      ),
                                      child: MyText(
                                        text: 'approve',
                                        multilanguage: true,
                                        color: white,
                                        fontsize: Dimens.textMedium,
                                        fontwaight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  if (requestProvider.loadMore)
                    shimmer()
                  else
                    const SizedBox.shrink()
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

  Widget pendingRequest() {
    return Consumer<RequestProvider>(
      builder: (context, requestProvider, child) {
        if (requestProvider.loaded && !requestProvider.loadMore) {
          return shimmer();
        } else {
          if (requestProvider.requestLsit != null &&
              (requestProvider.requestLsit?.length ?? 0) > 0) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  AlignedGridView.count(
                    crossAxisCount: 1,
                    shrinkWrap: true,
                    padding:
                        const EdgeInsets.only(top: 15, left: 15.0, right: 15),
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    itemCount: requestProvider.requestLsit?.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VideoRequestList(
                                  requestId: requestProvider
                                          .requestLsit?[index].id
                                          .toString() ??
                                      "")));
                        },
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        MyText(
                                          text:
                                              "#${requestProvider.requestLsit?[index].id.toString() ?? ""}",
                                          color: yellow,
                                          fontsize: Dimens.textMedium,
                                          fontwaight: FontWeight.w500,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: MyText(
                                            text: requestProvider
                                                    .requestLsit?[index]
                                                    .fullName ??
                                                "",
                                            color: white,
                                            maxline: 2,
                                            overflow: TextOverflow.ellipsis,
                                            fontsize: Dimens.textMedium,
                                            fontwaight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        MyText(
                                          text: "topic",
                                          multilanguage: true,
                                          color: white,
                                          fontsize: Dimens.textMedium,
                                          fontwaight: FontWeight.w400,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: MyText(
                                            text: requestProvider
                                                    .requestLsit?[index]
                                                    .categoryName
                                                    .toString() ??
                                                "",
                                            color: colorAccent,
                                            fontsize: Dimens.textMedium,
                                            fontwaight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border:
                                          Border.all(width: 1, color: white),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => Message(
                                            bioData: requestProvider
                                                .requestLsit?[index].userBio,
                                            profileImg: requestProvider
                                                .requestLsit?[index].userImage,
                                            toChatId: requestProvider
                                                .requestLsit?[index]
                                                .userFirebaseId,
                                            toUserName: requestProvider
                                                .requestLsit?[index].userName,
                                            number: requestProvider
                                                .requestLsit?[index]
                                                .userMobileNumber,
                                          ),
                                        ));
                                      },
                                      child: const Icon(
                                        Icons.chat,
                                        size: 16,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.center,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: colorAccent),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => UploadVideo(
                                            requestId: requestProvider
                                                    .requestLsit?[index].id
                                                    .toString() ??
                                                "",
                                          ),
                                        ));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          MyText(
                                            text: 'upload',
                                            multilanguage: true,
                                            color: white,
                                            fontsize: Dimens.textSmall,
                                            fontwaight: FontWeight.w500,
                                          ),
                                          const SizedBox(width: 5),
                                          const CircleAvatar(
                                            radius: 10,
                                            backgroundColor: white,
                                            child: Icon(
                                              Icons.upload,
                                              size: 15,
                                              color: colorAccent,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  if (requestProvider.loadMore)
                    shimmer()
                  else
                    const SizedBox.shrink()
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

  Widget successRequest() {
    return Consumer<RequestProvider>(
      builder: (context, requestProvider, child) {
        if (requestProvider.loaded && !requestProvider.loadMore) {
          return shimmer();
        } else {
          if (requestProvider.requestLsit != null &&
              (requestProvider.requestLsit?.length ?? 0) > 0) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  AlignedGridView.count(
                    crossAxisCount: 1,
                    shrinkWrap: true,
                    padding:
                        const EdgeInsets.only(top: 15, left: 15.0, right: 15),
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    itemCount: requestProvider.requestLsit?.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VideoRequestList(
                                  requestId: requestProvider
                                          .requestLsit?[index].id
                                          .toString() ??
                                      "")));
                        },
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      MyText(
                                        text:
                                            "#${requestProvider.requestLsit?[index].id.toString() ?? ""}",
                                        color: yellow,
                                        fontsize: Dimens.textMedium,
                                        fontwaight: FontWeight.w500,
                                      ),
                                      const SizedBox(width: 6),
                                      MyText(
                                        text: requestProvider
                                                .requestLsit?[index].fullName ??
                                            "",
                                        color: white,
                                        maxline: 2,
                                        overflow: TextOverflow.ellipsis,
                                        fontsize: Dimens.textMedium,
                                        fontwaight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      MyText(
                                        text: "topic",
                                        multilanguage: true,
                                        color: white,
                                        fontsize: Dimens.textMedium,
                                        fontwaight: FontWeight.w400,
                                      ),
                                      const SizedBox(width: 8),
                                      MyText(
                                        text: requestProvider
                                                .requestLsit?[index]
                                                .categoryName
                                                .toString() ??
                                            "",
                                        color: colorAccent,
                                        fontsize: Dimens.textMedium,
                                        fontwaight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border:
                                          Border.all(width: 1, color: white),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => Message(
                                            bioData: requestProvider
                                                .requestLsit?[index].userBio,
                                            profileImg: requestProvider
                                                .requestLsit?[index].userImage,
                                            toChatId: requestProvider
                                                .requestLsit?[index]
                                                .userFirebaseId,
                                            toUserName: requestProvider
                                                .requestLsit?[index].userName,
                                            number: requestProvider
                                                .requestLsit?[index]
                                                .userMobileNumber,
                                          ),
                                        ));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          MyText(
                                            text: 'chat',
                                            multilanguage: true,
                                            color: white,
                                            fontsize: Dimens.textSmall,
                                            fontwaight: FontWeight.w600,
                                          ),
                                          const SizedBox(width: 5),
                                          const Icon(
                                            Icons.chat,
                                            size: 16,
                                            color: white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.center,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: white,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => VideoPlayer(
                                            initialIndex: index,
                                          ),
                                        ));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          MyText(
                                            text: 'playvideo',
                                            multilanguage: true,
                                            color: colorAccent,
                                            fontsize: Dimens.textMedium,
                                            fontwaight: FontWeight.w500,
                                          ),
                                          const SizedBox(width: 5),
                                          const CircleAvatar(
                                            radius: 10,
                                            backgroundColor: colorAccent,
                                            child: Icon(
                                              Icons.play_arrow,
                                              size: 17,
                                              color: white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  if (requestProvider.loadMore)
                    shimmer()
                  else
                    const SizedBox.shrink()
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

  Widget rejectedData() {
    return Consumer<RequestProvider>(
      builder: (context, requestProvider, child) {
        if (requestProvider.loaded && !requestProvider.loadMore) {
          return shimmer();
        } else {
          if (requestProvider.artistVideoRequestModel.status == 200 &&
              requestProvider.requestLsit != null &&
              (requestProvider.requestLsit?.length ?? 0) > 0) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  AlignedGridView.count(
                    crossAxisCount: 1,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(15),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: requestProvider.requestLsit?.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VideoRequestList(
                                  requestId: requestProvider
                                          .requestLsit?[index].id
                                          .toString() ??
                                      "")));
                        },
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: colorPrimary,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    text:
                                        "#${requestProvider.requestLsit?[index].id.toString() ?? ""}",
                                    color: yellow,
                                    fontsize: Dimens.textMedium,
                                    fontwaight: FontWeight.w500,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      MyText(
                                        text: "topic",
                                        multilanguage: true,
                                        color: white,
                                        fontsize: Dimens.textMedium,
                                        fontwaight: FontWeight.w400,
                                      ),
                                      const SizedBox(width: 8),
                                      MyText(
                                        text: requestProvider
                                                .requestLsit?[index]
                                                .categoryName
                                                .toString() ??
                                            "",
                                        color: colorAccent,
                                        fontsize: Dimens.textMedium,
                                        fontwaight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              MyText(
                                text: requestProvider
                                        .requestLsit?[index].fullName
                                        .toString() ??
                                    "",
                                color: white,
                                fontsize: Dimens.textTitle,
                                fontwaight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  if (requestProvider.loadMore)
                    shimmer()
                  else
                    const SizedBox.shrink()
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
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomWidget.roundrectborder(
                  height: 90, width: MediaQuery.sizeOf(context).width),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomWidget.roundcorner(height: 8, width: 100),
                        SizedBox(height: 15),
                        CustomWidget.roundcorner(height: 8, width: 150),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
