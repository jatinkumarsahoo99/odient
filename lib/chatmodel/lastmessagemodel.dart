import 'package:dtcameo/utils/firebaseconstant.dart';
import 'package:dtcameo/utils/utils.dart';

class LastMessage {
  String name;
  String photo;
  String content;
  String idFrom;
  String idTo;
  bool read;
  String timestamp;
  int type;

  LastMessage(
      {required this.name,
      required this.photo,
      required this.content,
      required this.idFrom,
      required this.idTo,
      required this.read,
      required this.timestamp,
      required this.type});

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.name: name,
      FirestoreConstants.profileurl: photo,
      FirestoreConstants.content: content,
      FirestoreConstants.idFrom: idFrom,
      FirestoreConstants.idTo: idTo,
      FirestoreConstants.read: read,
      FirestoreConstants.timestamp: timestamp,
      FirestoreConstants.type: type,
    };
  }

  factory LastMessage.fromMap(Map<String, dynamic> doc) {
    String name = "";
    String photo = "";
    String content = "";
    String idFrom = "";
    String idTo = "";
    bool read;
    String timestamp = "";
    int type;
    try {
      name = doc[FirestoreConstants.name] ?? "";
    } catch (e) {
      printLog("name Exception ====> $e");
      name = "";
    }
    try {
      photo = doc[FirestoreConstants.profileurl] ?? "";
    } catch (e) {
      printLog("photo Exception ====> $e");
      photo = "";
    }
    try {
      content = doc[FirestoreConstants.content] ?? "";
    } catch (e) {
      printLog("content Exception ====> $e");
      content = "";
    }
    try {
      idFrom = doc[FirestoreConstants.idFrom] ?? "";
    } catch (e) {
      printLog("idFrom Exception ====> $e");
      idFrom = "";
    }
    try {
      idTo = doc[FirestoreConstants.idTo] ?? "";
    } catch (e) {
      printLog("idTo Exception ====> $e");
      idTo = "";
    }
    try {
      read = doc[FirestoreConstants.read] ?? "";
    } catch (e) {
      printLog("read Exception ====> $e");
      read = false;
    }
    try {
      timestamp = doc[FirestoreConstants.timestamp] ?? "";
    } catch (e) {
      printLog("timestamp Exception ====> $e");
      timestamp = "";
    }
    try {
      type = doc[FirestoreConstants.type] ?? "";
    } catch (e) {
      printLog("type Exception ====> $e");
      type = 0;
    }
    return LastMessage(
      name: name,
      photo: photo,
      content: content,
      idFrom: idFrom,
      idTo: idTo,
      read: read,
      timestamp: timestamp,
      type: type,
    );
  }
}
