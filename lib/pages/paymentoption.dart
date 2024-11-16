import 'package:dtcameo/pages/bottombar.dart';
import 'package:dtcameo/provider/paymentoptionprovider.dart';
import 'package:dtcameo/provider/profileprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/shareperf.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/nodata.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:uuid/uuid.dart';

class PaymentOption extends StatefulWidget {
  final String? price, packageid, description;
  const PaymentOption({
    super.key,
    required this.price,
    required this.description,
    required this.packageid,
  });
  @override
  State<PaymentOption> createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> {
  String? username, useremail, userMobilenumber, paymentId;
  bool isPaymentDone = false;
  PaymentOptionProvider paymentOptionProvider = PaymentOptionProvider();

  @override
  void initState() {
    paymentOptionProvider =
        Provider.of<PaymentOptionProvider>(context, listen: false);
    getData();
    getApi();
    super.initState();
  }

  Future<void> getApi() async {
    await paymentOptionProvider.getPaymentOption();
    await paymentOptionProvider.setFinalAmount(widget.price);

    /* PaymentID */
    paymentId = Utils.generateRandomOrderID();
    printLog('paymentId =====================> $paymentId');
  }

  Future<void> getData() async {
    Constant.userId = await SharePre().read("userid");
    username = await SharePre().read("username");
    useremail = await SharePre().read("useremail");
    userMobilenumber = await SharePre().read("mobilenumber");
    Constant.currency = await SharePre().read("currency");
    printLog("Your Courrency code is : ${Constant.currency}");
    printLog("Your utils user name is ==: ${username.toString()}");
    printLog("Your utils user Email is =: ${useremail.toString()}");
    printLog("Your utils user Mobilenuumber is =: $userMobilenumber");
  }

  Future<void> getPaymentTran() async {
    final profileProvider =
        Provider.of<Profileprovider>(context, listen: false);

    Utils().showProgress(context);

    await paymentOptionProvider.getAddTransacation(
      Constant.userId ?? "",
      widget.packageid ?? "",
      widget.price ?? "",
      paymentId ?? "",
      widget.description ?? "",
    );
    if (!paymentOptionProvider.loaded) {
      Utils.hideProgress();

      if (paymentOptionProvider.successModel.status == 200) {
        isPaymentDone = true;
        if (!mounted) return;
        await profileProvider.getProfile(context, Constant.userId ?? "");
        // await videoDetailsProvider.updatePrimiumPurchase();
        // await showDetailsProvider.updatePrimiumPurchase();
        // await channelSectionProvider.updatePrimiumPurchase();
        // await videoDetailsProvider.updateRentPurchase();
        // await showDetailsProvider.updateRentPurchase();

        if (!mounted) return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const BottomBar(),
        ));
      } else {
        isPaymentDone = false;
        if (!mounted) return;
        Utils.showSnackbar(context, "info",
            paymentOptionProvider.successModel.message ?? "", false);
      }
    }
  }

  @override
  void dispose() {
    paymentOptionProvider.clearProvider();
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
      ),
      body: Consumer<PaymentOptionProvider>(
        builder: (context, paymentOptionProvider, child) {
          if (paymentOptionProvider.loaded) {
            return paymentShimmer();
          } else {
            if (paymentOptionProvider.paymentOptionModel.status == 200 &&
                (paymentOptionProvider.paymentOptionModel.result != null)) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: "paymentoption",
                      multilanguage: true,
                      fontsize: Dimens.textExtraBig,
                      color: white,
                      fontwaight: FontWeight.w700,
                      fontstyle: FontStyle.normal,
                    ),
                    const SizedBox(height: 20),

                    /* Inapppurchage Android */
                    paymentOptionProvider.paymentOptionModel.result
                                ?.inapppurchageAndroid !=
                            null
                        ? paymentOptionProvider.paymentOptionModel.result
                                    ?.inapppurchageAndroid?.visibility ==
                                "1"
                            ? _buildPGButton("Inapppurchage Android",
                                onClick: () async {
                                await paymentOptionProvider
                                    .setCurrentPayment("inapppurchageAndroid");
                                openPayment(pgName: "inapppurchageAndroid");
                              })
                            : const SizedBox.shrink()
                        : const SizedBox.shrink(),

                    /* Paypal */
                    paymentOptionProvider.paymentOptionModel.result?.paypal !=
                            null
                        ? paymentOptionProvider.paymentOptionModel.result
                                    ?.paypal?.visibility ==
                                "1"
                            ? _buildPGButton("Paypal", onClick: () async {
                                await paymentOptionProvider
                                    .setCurrentPayment("paypal");
                                openPayment(pgName: "paypal");
                              })
                            : const SizedBox.shrink()
                        : const SizedBox.shrink(),
                    paymentOptionProvider.paymentOptionModel.result?.razorpay !=
                            null
                        ? paymentOptionProvider.paymentOptionModel.result
                                    ?.razorpay?.visibility ==
                                "1"
                            ? _buildPGButton("Razorpay", onClick: () async {
                                await paymentOptionProvider
                                    .setCurrentPayment("razorpay");
                                openPayment(pgName: "razorpay");
                              })
                            : const SizedBox.shrink()
                        : const SizedBox.shrink(),
                    /* flutterwave */
                    paymentOptionProvider
                                .paymentOptionModel.result?.flutterwave !=
                            null
                        ? paymentOptionProvider.paymentOptionModel.result
                                    ?.flutterwave?.visibility ==
                                "1"
                            ? _buildPGButton("Flutterwave", onClick: () async {
                                await paymentOptionProvider
                                    .setCurrentPayment("flutterwave");
                                openPayment(pgName: "flutterwave");
                              })
                            : const SizedBox.shrink()
                        : const SizedBox.shrink(),

                    /* PayUMoney */
                    paymentOptionProvider
                                .paymentOptionModel.result?.payumoney !=
                            null
                        ? paymentOptionProvider.paymentOptionModel.result
                                    ?.payumoney?.visibility ==
                                "1"
                            ? _buildPGButton("PayUMoney", onClick: () async {
                                await paymentOptionProvider
                                    .setCurrentPayment("payumoney");
                                openPayment(pgName: "payumoney");
                              })
                            : const SizedBox.shrink()
                        : const SizedBox.shrink(),

                    /* Paytm */
                    paymentOptionProvider.paymentOptionModel.result?.paytm !=
                            null
                        ? paymentOptionProvider.paymentOptionModel.result?.paytm
                                    ?.visibility ==
                                "1"
                            ? _buildPGButton("Paytm", onClick: () async {
                                await paymentOptionProvider
                                    .setCurrentPayment("paytm");
                                openPayment(pgName: "paytm");
                              })
                            : const SizedBox.shrink()
                        : const SizedBox.shrink(),

                    /* Stripe */
                    paymentOptionProvider.paymentOptionModel.result?.stripe !=
                            null
                        ? paymentOptionProvider.paymentOptionModel.result
                                    ?.stripe?.visibility ==
                                "1"
                            ? _buildPGButton("Stripe", onClick: () async {
                                await paymentOptionProvider
                                    .setCurrentPayment("stripe");
                                openPayment(pgName: "stripe");
                              })
                            : const SizedBox.shrink()
                        : const SizedBox.shrink(),
                    /* Inapppurchage IOS */
                    paymentOptionProvider
                                .paymentOptionModel.result?.inapppurchageIos !=
                            null
                        ? paymentOptionProvider.paymentOptionModel.result
                                    ?.inapppurchageIos?.visibility ==
                                "1"
                            ? _buildPGButton("Inapppurchage Ios",
                                onClick: () async {
                                await paymentOptionProvider
                                    .setCurrentPayment("inapppurchageIos");
                                openPayment(pgName: "inapppurchageIos");
                              })
                            : const SizedBox.shrink()
                        : const SizedBox.shrink(),
                  ],
                ),
              );
            } else {
              return const NoData();
            }
          }
        },
      ),
    );
  }

  Widget _buildPGButton(String pgName, {required Function() onClick}) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      color: colorAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onClick,
        child: Container(
          // constraints: const BoxConstraints(minHeight: 85),
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          child: MyText(
            color: white,
            text: pgName,
            multilanguage: false,
            fontsize: Dimens.textlargeBig,
            maxline: 2,
            overflow: TextOverflow.ellipsis,
            fontwaight: FontWeight.w600,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }

  openPayment({required String pgName}) async {
    printLog("finalAmount =============> ${paymentOptionProvider.finalAmount}");
    if (paymentOptionProvider.finalAmount != "0") {
      if (pgName == "paypal") {
        _paypalInit();
      } else if (pgName == "inapppurchageAndroid") {
        // _initInAppPurchase();
      } else if (pgName == "razorpay") {
        _initializeRazorpay();
      } else if (pgName == "flutterwave") {
        _flutterwaveInit();
      } else if (pgName == "payumoney") {
        // _payUInit();
      } else if (pgName == "paytm") {
        // _paytmInit();
      } else if (pgName == "stripe") {
        // _stripeInit();
      } else if (pgName == "paystack") {
        // _paystackInit();
      } else if (pgName == "inapppurchageIos") {
        // _initInstamojo();
      } else if (pgName == "cash") {
        if (!mounted) return;
        Utils.showSnackbar(context, "info", "cash_payment_msg", true);
      }
    } else {
      // addTransaction(widget.itemId, widget.itemTitle,
      //     paymentOptionProvider.finalAmount, paymentId, widget.currency);

      getPaymentTran();
    }
  }

  bool checkKeysAndContinue({
    required String isLive,
    required bool isBothKeyReq,
    required String liveKey1,
    required String liveKey2,
    required String testKey1,
    required String testKey2,
  }) {
    if (isLive == "1") {
      if (isBothKeyReq) {
        if (liveKey1 == "" || liveKey2 == "") {
          Utils.showSnackbar(context, "", "payment_not_processed", true);
          printLog("is live1 is not pass");
          return false;
        }
      } else {
        if (liveKey1 == "") {
          Utils.showSnackbar(context, "", "payment_not_processed", true);
          printLog("is live2 is not pass");

          return false;
        }
      }
      return true;
    } else {
      if (isBothKeyReq) {
        if (testKey1 == "" || testKey2 == "") {
          Utils.showSnackbar(context, "", "payment_not_processed", true);
          printLog("is testkey1 is not pass");
          return false;
        }
      } else {
        if (testKey1 == "") {
          Utils.showSnackbar(context, "", "payment_not_processed", true);
          printLog("is testkey2 is not pass==========");

          return false;
        }
      }
      return true;
    }
  }

  paymentShimmer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomWidget.roundcorner(
            height: 30,
            width: 150,
          ),
          ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CustomWidget.roundcorner(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30),
                    child: CustomWidget.roundcorner(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 1,
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  /* ********* Razorpay START ********* */
  void _initializeRazorpay() {
    if (paymentOptionProvider.paymentOptionModel.result?.razorpay != null) {
      /* Check Keys */
      printLog(
          "Razorpay Check key pass is ${paymentOptionProvider.paymentOptionModel.result?.razorpay?.key1 ?? ""}");

      bool isContinue = checkKeysAndContinue(
        isLive: (paymentOptionProvider
                .paymentOptionModel.result?.razorpay?.isLive ??
            ""),
        isBothKeyReq: false,
        liveKey1:
            (paymentOptionProvider.paymentOptionModel.result?.razorpay?.key1 ??
                ""),
        liveKey2: "",
        testKey1:
            (paymentOptionProvider.paymentOptionModel.result?.razorpay?.key1 ??
                ""),
        testKey2: "",
      );
      if (!isContinue) return;
      /* Check Keys */
      Razorpay razorpay = Razorpay();
      var options = {
        'key':
            // "rzp_test_E7TfP2p9bA9q75",
            (paymentOptionProvider
                        .paymentOptionModel.result?.razorpay?.isLive ==
                    "1")
                ? (paymentOptionProvider
                        .paymentOptionModel.result?.razorpay?.key1 ??
                    "")
                : (paymentOptionProvider
                        .paymentOptionModel.result?.razorpay?.key1 ??
                    ""),
        'currency': Constant.currency,
        'amount': (double.parse(paymentOptionProvider.finalAmount ?? "") * 100),
        'name': widget.description,
        'description': widget.description,
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'prefill': {'contact': userMobilenumber, 'email': useremail},
        'external': {
          'wallets': ['paytm']
        }
      };
      printLog("Razorpay Payment Key is $options");
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
      try {
        razorpay.open(options);
      } catch (e) {
        printLog('Razorpay Error :=========> $e');
      }
    } else {
      printLog('Razorpay Error :=========> ');
      Utils.showSnackbar(context, "", "payment_not_processed", true);
    }
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) async {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */

    Utils.showSnackbar(context, "fail", "payment_fail", true);
    await paymentOptionProvider.setCurrentPayment("");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    paymentId = response.paymentId.toString();
    printLog("paymentId ========> $paymentId");
    Utils.showSnackbar(context, "success", "payment_success", true);

    getPaymentTran();

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const BottomMenu(),
    //     ));
    printLog("Success==============");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    printLog("============ External Wallet Selected ============");
  }

  /* ********* Razorpay END ********* */

  /* ********* FlutterWave Start ******* */

  _flutterwaveInit() async {
    if (paymentOptionProvider.paymentOptionModel.result?.flutterwave != null) {
      /* Check Keys */
      printLog(
          "Flutter wave Check key pass is ${paymentOptionProvider.paymentOptionModel.result?.flutterwave?.key1 ?? ""}");
      bool isContinue = checkKeysAndContinue(
        isLive: (paymentOptionProvider
                .paymentOptionModel.result?.flutterwave?.isLive ??
            ""),
        isBothKeyReq: false,
        liveKey1: (paymentOptionProvider
                .paymentOptionModel.result?.flutterwave?.key1 ??
            ""),
        liveKey2: "",
        testKey1: (paymentOptionProvider
                .paymentOptionModel.result?.flutterwave?.key1 ??
            ""),
        testKey2: "",
      );
      if (!isContinue) return;
      /* Check Keys */

      final Customer customer = Customer(
          email: useremail ?? "",
          name: username ?? "",
          phoneNumber: userMobilenumber ?? "");

      final Flutterwave flutterwave = Flutterwave(
        context: context,
        publicKey:
            // "FLWPUBK_TEST-e791024b3585ae0839d3c79506d953d1-X",
            (paymentOptionProvider.paymentOptionModel.result?.flutterwave?.isLive ==
                    "1")
                ? (paymentOptionProvider
                        .paymentOptionModel.result?.flutterwave?.key1 ??
                    "")
                : (paymentOptionProvider
                        .paymentOptionModel.result?.flutterwave?.key1 ??
                    ""),
        currency: Constant.currency,
        redirectUrl: 'https://www.divinetechs.com',
        txRef: const Uuid().v1(),
        amount: widget.price.toString().trim(),
        customer: customer,
        paymentOptions: "card, payattitude, barter, bank transfer, ussd",
        customization: Customization(title: widget.description),
        isTestMode: paymentOptionProvider
                .paymentOptionModel.result?.flutterwave?.isLive !=
            "1",
      );
      ChargeResponse? response = await flutterwave.charge();
      printLog("Flutterwave response =====> ${response.toJson()}");
      if ((response.status == "success" ||
              response.status == "successful" ||
              (response.status ?? "").contains("success")) &&
          response.success == true) {
        paymentId = response.transactionId.toString();
        printLog("paymentId ========> $paymentId");

        if (!mounted) return;
        Utils.showSnackbar(context, "success", "payment_success", true);
        getPaymentTran();

        // if (widget.payType == "Package") {
        //   addTransaction(widget.itemId, widget.itemTitle,
        //       paymentOptionProvider.finalAmount, paymentId, widget.currency);
        // } else if (widget.payType == "Rent") {
        //   addRentTransaction(widget.itemId, paymentOptionProvider.finalAmount,
        //       widget.typeId, widget.videoType);
        // }
      } else if (response.status == "cancel" &&
          response.status == "cancelled") {
        if (!mounted) return;
        Utils.showSnackbar(context, "info", "payment_cancel", true);
      } else {
        if (!mounted) return;

        Utils.showSnackbar(context, "fail", "payment_fail", true);
      }
    } else {
      if (!mounted) return;

      Utils.showSnackbar(context, "fail", "payment_fail", true);
      printLog("Error Flutter wave");
    }
  }

  /* ********* FlutterWave End ******* */

/* ************PayPal Start ************ */

  Future<void> _paypalInit() async {
    if (paymentOptionProvider.paymentOptionModel.result?.paypal != null) {
      printLog(
          "Your paypal secret key1 is : ${paymentOptionProvider.paymentOptionModel.result?.paypal?.key1 ?? ""}");
      printLog(
          "Your paypal secret key2 is : ${paymentOptionProvider.paymentOptionModel.result?.paypal?.key2 ?? ""}");

      /* Check Keys */

      bool isContinue = checkKeysAndContinue(
          isLive:
              paymentOptionProvider.paymentOptionModel.result?.paypal?.isLive ??
                  "",
          isBothKeyReq: true,
          liveKey1:
              paymentOptionProvider.paymentOptionModel.result?.paypal?.key1 ??
                  "",
          liveKey2:
              paymentOptionProvider.paymentOptionModel.result?.paypal?.key1 ??
                  "",
          testKey1:
              paymentOptionProvider.paymentOptionModel.result?.paypal?.key1 ??
                  "",
          testKey2:
              paymentOptionProvider.paymentOptionModel.result?.paypal?.key1 ??
                  "");
      if (!isContinue) return;
      /* End Key */
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => UsePaypal(
              sandboxMode: (paymentOptionProvider
                              .paymentOptionModel.result?.paypal?.isLive ??
                          "") ==
                      "1"
                  ? false
                  : true,
              clientId: (paymentOptionProvider
                          .paymentOptionModel.result?.paypal?.isLive ==
                      "1")
                  ? (paymentOptionProvider
                          .paymentOptionModel.result?.paypal?.key1 ??
                      "")
                  : (paymentOptionProvider
                          .paymentOptionModel.result?.paypal?.key1 ??
                      ""),
              secretKey: (paymentOptionProvider
                          .paymentOptionModel.result?.paypal?.isLive ==
                      "1")
                  ? (paymentOptionProvider
                          .paymentOptionModel.result?.paypal?.key2 ??
                      "")
                  : (paymentOptionProvider
                          .paymentOptionModel.result?.paypal?.key2 ??
                      ""),
              returnURL: "return.example.com",
              cancelURL: "cancel.example.com",
              transactions: [
                {
                  "amount": {
                    "total": '${paymentOptionProvider.finalAmount}',
                    "currency": Constant.currency,
                    "details": {
                      "subtotal": '${paymentOptionProvider.finalAmount}',
                      "shipping": '0',
                      "shipping_discount": 0
                    }
                  },
                  "description": widget.description,
                  "item_list": {
                    "items": [
                      {
                        "name": widget.description,
                        "quantity": 1,
                        "price": '${paymentOptionProvider.finalAmount}',
                        "currency": Constant.currency
                      },
                    ],
                    // shipping address is not required though
                    "shipping_address": {
                      "recipient_name": username ?? "",
                      "line1": "Travis County",
                      "line2": "",
                      "city": "Austin",
                      "country_code": "US",
                      "postal_code": "73301",
                      "phone": userMobilenumber,
                      "state": "Texas"
                    },
                  }
                }
              ],
              note: "Contact us for any questions on your order.",
              onSuccess: (params) async {
                printLog("onSuccess: $params : $paymentId");

                printLog("============================");
                getPaymentTran();

                // if (widget.payType == "Package") {
                //   addTransaction(
                //       widget.itemId,
                //       widget.itemTitle,
                //       paymentOptionProvider.finalAmount,
                //       params["paymentId"],
                //       widget.currency);
                // } else if (widget.payType == "Rent") {
                //   addRentTransaction(widget.itemId, paymentOptionProvider.finalAmount,
                //       widget.typeId, widget.videoType);
                // }
              },
              onError: (error) {
                printLog("======== Error Message ====================");

                printLog("onError: $error");
                Utils.showSnackbar(context, "fail", error.toString(), false);
              },
              onCancel: (params) {
                printLog('cancelled: $params');
                Utils.showSnackbar(context, "fail", params.toString(), false);
              }),
        ),
      );
    } else {
      Utils.showSnackbar(context, "fail", "payment_fail", true);
      printLog("Error Flutter wave");
    }
  }

/* ************ PayPal End ************* */
}
