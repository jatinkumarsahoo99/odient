import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtcameo/chatmodel/chatmessagemodel.dart';
import 'package:dtcameo/chatmodel/chatusermodel.dart';
import 'package:dtcameo/provider/chatprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/firebaseconstant.dart';
import 'package:dtcameo/utils/shareperf.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mynetworkimmage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Message extends StatefulWidget {
  final String? toUserName, toChatId, profileImg, bioData, number;
  const Message(
      {super.key,
      required this.toUserName,
      required this.toChatId,
      required this.profileImg,
      required this.bioData,
      this.number});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  SharePre sharePref = SharePre();
  /* store message and create blank list */
  List<QueryDocumentSnapshot>? listMessage = [];
  /* one chatusermodel and two different instance */
  ChatUserModel? toUserData;
  ChatUserModel? currentUserData;
  int _limit = 15;
  int limitIncrement = 15;
  String? groupChatId = "", currentUserId;

  File? imageFile;
  bool isLoading = false;
  String imageUrl = "";

  late ChatProvider chatProvider;
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getUserData();
    });
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future getUserData() async {
    chatProvider.setLoading(true);
    /* Touser id check  */
    var userDetails = await FirebaseFirestore.instance
        .collection(FirestoreConstants
            .pathUserCollection) /* All user details collection */
        .doc(widget.toChatId) /* user chat id */
        .get();

    toUserData = ChatUserModel.fromDocument(userDetails);
    printLog("Rec= toUser message name : ${toUserData?.name}");
    printLog("Rec= toUser message id : ${toUserData?.userid}");

    /* IsCheck Current userid */
    currentUserId = await sharePref.read('firebaseid');
    printLog("Current UserId Firebaseid :======== $currentUserId");
    var currentUserDetails = await FirebaseFirestore.instance
        .collection(FirestoreConstants.pathUserCollection)
        .doc(currentUserId)
        .get();

    currentUserData = ChatUserModel.fromDocument(currentUserDetails);
    printLog("Send User message name : ${currentUserData?.name}");
    checkUserID();
  }

  _scrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        _limit <= (listMessage?.length ?? 0)) {
      if (mounted) {
        setState(() {
          _limit += limitIncrement;
          printLog("Your new limet inscress ==$_limit");
        });
      }
    }
  }

  Future checkUserID() async {
    printLog("Current userid===== : $currentUserId");
    printLog("Current touserid===== : ${widget.toChatId}");

    if (currentUserId!.compareTo(widget.toChatId ?? "") > 0) {
      groupChatId = '$currentUserId-${widget.toChatId}';
    } else {
      groupChatId = '${widget.toChatId}-$currentUserId';
    }
    printLog("Group_Id ==== $groupChatId");
/* Add Chate in FirebaseFireStore */
    chatProvider.addFieldsInFirestore(
      FirestoreConstants.pathMessageCollection,
      groupChatId ?? "",
      currentUserId ?? "",
      widget.toChatId ?? "",
    );

    /* Update the user message */
    await chatProvider.updateDataFirestore(
      FirestoreConstants.pathUserCollection,
      currentUserId ?? "",
      {FirestoreConstants.chattingWith: widget.toChatId},
    ).whenComplete(() async {
      await chatProvider.setLoading(false);
    });

    Future.delayed(Duration.zero).then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: colorPrimaryDark,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: colorPrimaryDark,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding:
                const EdgeInsetsDirectional.only(start: 0, bottom: 0, end: 20),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => onBackPress(),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: white,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: MyNetworkImage(
                    imageUrl: widget.profileImg ?? "",
                    fit: BoxFit.cover,
                    imgHeight: 44,
                    imgWidth: 44,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: MyText(
                    color: white,
                    text: widget.toUserName ?? "",
                    fontsize: Dimens.textTitle,
                    fontwaight: FontWeight.w600,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.start,
                    fontstyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(width: 15),
                InkWell(
                  onTap: () async {
                    // String number = widget.number.toString();
                    // await FlutterPhoneDirectCaller.callNumber(number);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: const Icon(
                    Icons.videocam_rounded,
                    color: white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 15),
                InkWell(
                  onTap: () async {
                    String number = widget.number.toString();
                    await FlutterPhoneDirectCaller.callNumber(number);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: const Icon(
                    Icons.call,
                    color: white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 15),
                InkWell(
                    borderRadius: BorderRadius.circular(8),
                    child: const Icon(
                      Icons.more_vert_rounded,
                      size: 20,
                      color: white,
                    )),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: _buildMessageShow(),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: white,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: _messageController,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        suffixIcon: Wrap(
                          children: [
                            IconButton(
                                onPressed: () {
                                  getImage();
                                },
                                icon: const Icon(
                                  Icons.attach_file,
                                  color: colorPrimaryDark,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.emoji_emotions,
                                  color: colorPrimaryDark,
                                )),
                          ],
                        ),
                        hintText: "Write a message....",
                        hintStyle: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: Dimens.textBigSmall,
                            color: colorPrimaryDark,
                            fontWeight: FontWeight.w400)),
                  )),
                  IconButton(
                      onPressed: () {
                        messageSendButton(_messageController.text.toString(),
                            TypeMessage.text);
                      },
                      icon: const Icon(
                        Icons.send,
                        size: 40,
                        color: red,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onBackPress() async {
    chatProvider.updateDataFirestore(
      FirestoreConstants.pathUserCollection,
      currentUserId ?? "",
      {FirestoreConstants.chattingWith: null},
    );

    Navigator.pop(context);

    return Future.value(true);
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage?[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage?[index - 1].get(FirestoreConstants.idFrom) !=
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile();
      }
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        messageSendButton(imageUrl, TypeMessage.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
      Utils().showToast(e.message ?? e.toString());
    }
  }

/* Show Message Start */
  Widget _buildMessageShow() {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        if (chatProvider.loading) {
          return Utils.pageLoader();
        } else {
          return SizedBox(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChatStream(groupChatId ?? "", _limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: MyText(
                      color: red,
                      text: "somethingwenttowrong",
                      multilanguage: true,
                      fontsize: Dimens.textlargeBig,
                      fontwaight: FontWeight.w600,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  /* Creating a blnk list top side */
                  listMessage = snapshot.data?.docs;
                  if ((listMessage?.length ?? 0) > 0) {
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      shrinkWrap: true,
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      physics: const AlwaysScrollableScrollPhysics(),
                      reverse: true,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                          constraints: const BoxConstraints(minHeight: 0),
                          child: _buildItem(index, snapshot.data?.docs[index]),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: MyText(
                        text: "No message here yet...",
                        color: colorPrimaryDark,
                        fontstyle: FontStyle.normal,
                        textalign: TextAlign.center,
                        fontsize: Dimens.textTitle,
                        fontwaight: FontWeight.w500,
                      ),
                    );
                  }
                } else {
                  return Utils.pageLoader();
                }
              },
            ),
          );
        }
      },
    );
  }

/* Send message left and right side start */
  Widget _buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      if (!document[FirestoreConstants.read] &&
          document[FirestoreConstants.idTo] == currentUserId) {
        chatProvider.updateMessageRead(document, groupChatId ?? "");
        chatProvider.updateLastMessageStatus(groupChatId ?? "");
      }
      ChatMessageModel messageModel = ChatMessageModel.fromDocument(document);
      if (messageModel.idFrom == currentUserId) {
        /* Message Show in Right Side */
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            messageModel.type == TypeMessage.text
                ? Container(
                    margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20 : 10,
                      right: 10,
                      top: 3,
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: colorPrimaryDark,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        MyText(
                          color: white,
                          text: messageModel.content,
                          fontsize: Dimens.textTitle,
                          fontwaight: FontWeight.w600,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.done_all,
                              size: 20,
                              color: (messageModel.read) == false
                                  ? white
                                  : colorAccent,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            MyText(
                              color: white,
                              text: DateFormat("hh:mm a").format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(messageModel.timestamp))),
                              fontsize: Dimens.textSmall,
                              fontwaight: FontWeight.w600,
                              textalign: TextAlign.end,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : messageModel.type == TypeMessage.image
                    ? Container(
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 20 : 10,
                            right: 10),
                        child: InkWell(
                          onTap: () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //   builder: (context) => FullScreenImage(
                            //       imageUrl: messageModel.content),
                            // ));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  messageModel.content,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return sendImageShimmer();
                                  },
                                  errorBuilder: (context, object, stackTrace) {
                                    return Material(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: Image.asset(
                                        'images/img_not_available.jpeg',
                                        width: 250,
                                        height: 300,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                  width: 250,
                                  height: 300,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.done_all,
                                    size: 20,
                                    color: (messageModel.read) == false
                                        ? grey
                                        : colorAccent,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  MyText(
                                    color: colorPrimaryDark,
                                    text: DateFormat("hh:mm a").format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(messageModel.timestamp))),
                                    fontsize: Dimens.textSmall,
                                    fontwaight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    // Sticker
                    : Container(
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 20 : 10,
                            right: 10),
                        child: Image.asset(
                          'images/${messageModel.content}.gif',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
          ],
        );
      } else {
        /* Left side message show toUser send */
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                isLastMessageLeft(index)
                    ? Material(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(18),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.network(
                          widget.profileImg ?? "",
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: colorPrimaryDark,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle,
                              size: 35,
                              color: grey,
                            );
                          },
                          width: 35,
                          height: 35,
                          fit: BoxFit.fill,
                        ),
                      )
                    : Container(width: 35),
                const SizedBox(
                  width: 3,
                ),
                messageModel.type == TypeMessage.text
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MyText(
                              color: colorPrimaryDark,
                              text: messageModel.content,
                              fontsize: Dimens.textTitle,
                              fontwaight: FontWeight.w600,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.done_all,
                                  size: 20,
                                  color: (messageModel.read) == false
                                      ? grey
                                      : colorAccent,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                MyText(
                                  color: colorPrimaryDark,
                                  text: DateFormat("hh:mm a").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(messageModel.timestamp))),
                                  fontsize: Dimens.textSmall,
                                  fontwaight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : messageModel.type == TypeMessage.image
                        ? InkWell(
                            // onTap: () {
                            //   Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => FullScreenImage(
                            //         imageUrl: messageModel.content),
                            //   ));
                            // },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    messageModel.content,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return sendImageShimmer();
                                    },
                                    errorBuilder:
                                        (context, object, stackTrace) {
                                      return Material(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                        child: Image.asset(
                                          'images/img_not_available.jpeg',
                                          width: 250,
                                          height: 300,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                    width: 250,
                                    height: 300,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.done_all,
                                      size: 20,
                                      color: (messageModel.read) == false
                                          ? grey
                                          : colorAccent,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    MyText(
                                      color: colorPrimaryDark,
                                      text: DateFormat("hh:mm a").format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(
                                                  messageModel.timestamp))),
                                      fontsize: Dimens.textSmall,
                                      fontwaight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 20 : 10,
                                right: 10),
                            child: Image.asset(
                              'images/${messageModel.content}.gif',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
              ],
            ),
          ],
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

/* Message Send Button */
  Future<void> messageSendButton(String content, int type) async {
    if (content.trim().isNotEmpty) {
      _messageController.clear();
      /* Message sent code */
      await chatProvider.sendMessage(
          content,
          type,
          groupChatId ?? "",
          currentUserId ?? "",
          widget.toChatId ?? "",
          DateTime.now().millisecondsSinceEpoch.toString());
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    } else {
      Utils.showSnackbar(context, "info", "nothingmessage", true);
    }
  }

/* Shimmer  */
  Widget sendImageShimmer() {
    return Container(
      height: 300,
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: const CustomWidget.roundcorner(
        height: 300,
        width: 250,
      ),
    );
  }
}
