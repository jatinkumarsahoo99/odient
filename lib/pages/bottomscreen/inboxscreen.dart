import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtcameo/chatmodel/chatusermodel.dart';
import 'package:dtcameo/chatmodel/conversionmodel.dart';
import 'package:dtcameo/chatmodel/lastmessagemodel.dart';
import 'package:dtcameo/pages/message.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/firebaseconstant.dart';
import 'package:dtcameo/utils/shareperf.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mynetworkimmage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/nodata.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  List<ChatUserModel>? myChatList = [];
  SharePre sharePref = SharePre();
  String currentUserFId = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserData();
    });
    super.initState();
  }

  getUserData() async {
    currentUserFId = await sharePref.read("firebaseid");
    printLog("Cureent user id : $currentUserFId");
    Future.delayed(Duration.zero).then(
      (value) {
        if (!mounted) return;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      appBar: AppBar(
        backgroundColor: colorPrimaryDark,
        iconTheme: const IconThemeData(color: white),
        title: MyText(
            text: "msg",
            multilanguage: true,
            fontstyle: FontStyle.normal,
            fontsize: Dimens.textBig,
            color: white,
            fontwaight: FontWeight.w700),
      ),
      body: SizedBox(child: messageDashboard()),
    );
  }

  Widget messageDashboard() {
    return FutureBuilder<List<ConversionModel>>(
      future: _fetch(),
      builder: (BuildContext context,
          AsyncSnapshot<List<ConversionModel>> snapshot) {
        if (snapshot.hasError) {
          return const NoData();
        }
        if (snapshot.hasData) {
          if ((snapshot.data?.length ?? 0) > 0) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              padding: const EdgeInsets.only(left: 4, top: 3),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _buildItem(
                    position: index,
                    chatUserList: snapshot.data,
                    context: context);
              },
            );
          } else {
            return const NoData();
          }
        } else {
          return messageShimmer();
        }
      },
    );
  }

  Widget _buildItem(
      {required int position,
      required List<ConversionModel>? chatUserList,
      required BuildContext context}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Message(
                  toUserName:
                      chatUserList?[position].chatUserModel?.name.toString(),
                  toChatId:
                      chatUserList?[position].chatUserModel?.userid.toString(),
                  profileImg: chatUserList?[position]
                      .chatUserModel
                      ?.photoUrl
                      .toString(),
                  bioData: chatUserList?[position]
                      .chatUserModel
                      ?.biodata
                      .toString()),
            ));
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: colorPrimaryDark,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: MyNetworkImage(
                  imageUrl:
                      chatUserList?[position].chatUserModel?.photoUrl ?? "",
                  imgHeight: 60,
                  imgWidth: 60,
                  fit: BoxFit.fill),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    color: colorAccent,
                    text: chatUserList?[position].chatUserModel?.name ?? "",
                    fontsize: Dimens.textTitle,
                    fontwaight: FontWeight.w700,
                    fontstyle: FontStyle.normal,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.done_all,
                        size: 18,
                        color: (chatUserList?[position].lastMessage?.read ??
                                    false) ==
                                true
                            ? grey
                            : colorAccent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MyText(
                          color: colorAccent,
                          text: chatUserList?[position].lastMessage?.content ??
                              "",
                          fontsize: Dimens.textBigSmall,
                          fontwaight: FontWeight.w400,
                          fontstyle: FontStyle.normal,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            MyText(
              color: ((chatUserList?[position].lastMessage?.read ?? false) ==
                      false)
                  ? red
                  : grey,
              text: DateFormat('hh:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(int.fromEnvironment(
                      chatUserList?[position].lastMessage?.timestamp ?? ""))),
              fontsize: Dimens.textSmall,
              fontwaight: FontWeight.w400,
              fontstyle: FontStyle.normal,
            ),
          ],
        ),
      ),
    );
  }

  Future<List<ConversionModel>> _fetch() async {
    var messageIds = <String>[];
    var userIds = <String>[];

    // Fetching All Messages.
    var messageSnapshot = await FirebaseFirestore.instance
        .collection(FirestoreConstants.pathMessageCollection)
        .where(FirestoreConstants.users, arrayContains: currentUserFId)
        .get();
    if (messageSnapshot.docs.isNotEmpty) {
      for (int i = 0; i < messageSnapshot.docs.length; i++) {
        messageIds.add(messageSnapshot.docs[i].id.toString());
        printLog("messageIds length ========> ${messageIds.length}");
      }
    }

/* last message show */
    List<LastMessage> lastMessageList = [];
    /* get last message documents */
    for (int i = 0; i < messageIds.length; i++) {
      var messagesDoc = await FirebaseFirestore.instance
          .collection(FirestoreConstants.pathMessageCollection)
          .doc(messageIds[i])
          .get();

      if ((messagesDoc.data()?.length ?? 0) > 0) {
        printLog("====================== Users fetched ======================");
        if (messagesDoc[FirestoreConstants.users] != null) {
          printLog(
              "users ==========> ${messagesDoc[FirestoreConstants.users]}");
          if (messagesDoc[FirestoreConstants.users][0].toString() != "" ||
              messagesDoc[FirestoreConstants.users][1].toString() != "") {
            printLog("currentUserFId ==========> $currentUserFId");
            if (messagesDoc[FirestoreConstants.users][0].toString() ==
                    currentUserFId ||
                messagesDoc[FirestoreConstants.users][1].toString() ==
                    currentUserFId) {
              /* Store user id */
              userIds.add(messagesDoc[FirestoreConstants.users][0].toString());
              userIds.add(messagesDoc[FirestoreConstants.users][1].toString());
              printLog("userIds length ========> ${userIds.length}");

              /* LastMessage */
              if (messagesDoc
                      .data()
                      ?.containsKey(FirestoreConstants.lastMessage) ??
                  false) {
                LastMessage lastMessageModel = LastMessage.fromMap(
                    messagesDoc[FirestoreConstants.lastMessage]);
                lastMessageList.add(lastMessageModel);
                printLog(
                    "lastMessageModel content ==========> ${lastMessageModel.content}");
                printLog(
                    "lastMessageList length ==========> ${lastMessageList.length}");
              }
            }
          }
        }
      }
    }
    /* create blank user list */
    List<ChatUserModel> userList = [];
    /* Get Users Data */
    for (int i = 0; i < userIds.length; i++) {
      if (userIds[i].toString() != currentUserFId) {
        var usersDetails = await FirebaseFirestore.instance
            .collection(FirestoreConstants.pathUserCollection)
            .doc(userIds[i].toString())
            .get();
        ChatUserModel chatUserModel = ChatUserModel.fromDocument(usersDetails);
        printLog("chatUserModel mUser name ==========> ${chatUserModel.name}");
        userList.add(chatUserModel);
        printLog("userList length ==========> ${userList.length}");
      }
    }
    printLog("userList Size ====> ${userList.length}");
    printLog("lastMessageList Size ====> ${lastMessageList.length}");

    /* Combine Users & LastMessage */
    List<ConversionModel> conversionList = [];
    for (var i = 0; i < userList.length; i++) {
      ConversionModel conversionModel = ConversionModel();
      conversionModel.chatUserModel = userList[i];
      conversionModel.lastMessage = lastMessageList[i];
      conversionList.add(conversionModel);
    }
    printLog("conversionList length ==========> ${conversionList.length}");
    return conversionList;
  }

  Widget messageShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 20,
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Stack(
          alignment: Alignment.center,
          children: [
            CustomWidget.roundrectborder(
                height: 65, width: MediaQuery.of(context).size.width),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CustomWidget.circular(height: 50, width: 50),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        CustomWidget.roundcorner(height: 5, width: 200),
                        CustomWidget.roundcorner(height: 5, width: 200),
                      ],
                    ),
                  ),
                  Spacer(flex: 1),
                  CustomWidget.roundcorner(height: 20, width: 50),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
