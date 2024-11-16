import 'package:dtcameo/chatmodel/model/paymentoptionmodel.dart';
import 'package:dtcameo/chatmodel/model/successmodel.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class PaymentOptionProvider extends ChangeNotifier {
  PaymentOptionModel paymentOptionModel = PaymentOptionModel();
  SuccessModel successModel = SuccessModel();
  bool loaded = false;
  String? currentPayment = "", finalAmount = "";

  Future<void> getPaymentOption() async {
    loaded = true;
    paymentOptionModel = await ApiService().paymentOptionResponse();
    loaded = false;

    notifyListeners();
  }

  Future<void> getAddTransacation(String userid, String packageid, String price,
      String transactionid, String description) async {
    loaded = true;

    successModel = await ApiService().addTransactionResponse(
        userid, packageid, price, transactionid, description);
    printLog(
        "Your add transaction status is ${successModel.status.toString()}");
    printLog(
        "Your add transaction Message is ${successModel.message.toString()}");

    loaded = false;
    notifyListeners();
  }

  Future<void> getUserTransacation(
      String toUserId,
      String requestId,
      String fees,
      String transactionid,
      String description,
      String status) async {
    loaded = true;

    successModel = await ApiService().addUserTransactionResponse(
        toUserId, requestId, fees, transactionid, description, status);
    printLog(
        "Your add transaction status is ${successModel.status.toString()}");
    printLog(
        "Your add transaction Message is ${successModel.message.toString()}");

    loaded = false;
    notifyListeners();
  }

  setFinalAmount(String? amount) {
    finalAmount = amount;
    printLog("setFinalAmount finalAmount :==> $finalAmount");

    notifyListeners();
  }

  setCurrentPayment(String? payment) {
    currentPayment = payment;

    notifyListeners();
  }

  clearProvider() {
    currentPayment = "";
    finalAmount = "";
    paymentOptionModel = PaymentOptionModel();
    successModel = SuccessModel();
    loaded = false;
  }
}
