import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/firebaseconstant.dart';
import 'package:dtcameo/utils/utils.dart';

class ChatUserModel {
  String biodata;
  String chattingWith;
  String createdAt;
  String pushToken;
  String email;
  String name;
  String photoUrl;
  String userid;
  String userName;

  ChatUserModel(
      {required this.biodata,
      required this.chattingWith,
      required this.createdAt,
      required this.pushToken,
      required this.email,
      required this.name,
      required this.photoUrl,
      required this.userid,
      required this.userName});

  Map<String, String> toJson() {
    return {
      FirestoreConstants.bioData: biodata,
      FirestoreConstants.chattingWith: chattingWith,
      FirestoreConstants.createdAt: createdAt,
      FirestoreConstants.deviceToken: pushToken,
      FirestoreConstants.email: email,
      FirestoreConstants.name: name,
      FirestoreConstants.profileurl: photoUrl,
      FirestoreConstants.userid: userid,
      FirestoreConstants.username: userName,
    };
  }

  factory ChatUserModel.fromDocument(DocumentSnapshot doc) {
    String biodata = "";
    String chattingWith = "";
    String createdAt = "";
    String pushToken = "";
    String email = "";
    String name = "";
    String photoUrl = "";
    String userid = "";
    String userName = "";
    printLog("doc ====> ${doc.id}");
    try {
      biodata = doc[FirestoreConstants.bioData] ?? "";
    } catch (e) {
      printLog("biodata Exception ====> $e");
      biodata = "";
    }
    try {
      chattingWith = doc[FirestoreConstants.chattingWith] ?? "";
    } catch (e) {
      printLog("chattingWith Exception ====> $e");
      chattingWith = "";
    }
    try {
      pushToken = doc[FirestoreConstants.deviceToken] ?? "";
    } catch (e) {
      printLog("pushToken Exception ====> $e");
      pushToken = "";
    }
    try {
      createdAt = doc[FirestoreConstants.createdAt] ?? "";
    } catch (e) {
      printLog("createdAt Exception ====> $e");
      createdAt = "";
    }
    try {
      email = doc[FirestoreConstants.email] ?? "";
    } catch (e) {
      printLog("email Exception ====> $e");
      email = "";
    }
    try {
      name = doc[FirestoreConstants.name] ?? "";
    } catch (e) {
      printLog("name Exception ====> $e");
      name = "";
    }
    try {
      photoUrl = doc[FirestoreConstants.profileurl] ?? "";
    } catch (e) {
      printLog("photoUrl Exception ====> $e");
      photoUrl = Constant.userPlaceholder;
    }
    try {
      userid = doc[FirestoreConstants.userid] ?? "";
    } catch (e) {
      printLog("userid Exception ====> $e");
      userid = "";
    }
    try {
      userName = doc[FirestoreConstants.username] ?? "";
    } catch (e) {
      printLog("userName Exception ====> $e");
      userName = "";
    }
    return ChatUserModel(
      biodata: biodata,
      chattingWith: chattingWith,
      createdAt: createdAt,
      pushToken: pushToken,
      email: email,
      name: name,
      photoUrl: photoUrl,
      userid: userid,
      userName: userName,
    );
  }
}
