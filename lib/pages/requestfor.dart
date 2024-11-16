import 'package:dotted_line/dotted_line.dart';
import 'package:dtcameo/pages/subscription/paymentspage.dart';
import 'package:dtcameo/provider/videorequestprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/shareperf.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mynetworkimmage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestFor extends StatefulWidget {
  final String? id;
  const RequestFor({super.key, required this.id});

  @override
  State<RequestFor> createState() => _RequestForState();
}

class _RequestForState extends State<RequestFor> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _brithController = TextEditingController();
  final TextEditingController _toFristnameController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController mySelfController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? isSelectedButton = "0"; //0 For MySelf
  int activeStep = 1;
  int? _selectedValue;
  String? selectCelValue;
  int? _selectedRadio = 0;
  String? valueRadio;
  List<String> selectedOptions = [];
  String? checkValue;
  String? userName;
  late VideoRequestProvider videoRequestProvider;
  @override
  void initState() {
    videoRequestProvider =
        Provider.of<VideoRequestProvider>(context, listen: false);
    getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getApi();
    });
    super.initState();
  }

  Future<void> getApi() async {
    videoRequestProvider.setLoding(true);
    await videoRequestProvider.getCategory();
    await videoRequestProvider.getProfile(widget.id ?? "");
    await videoRequestProvider.getQuestion(_selectedValue.toString());
  }

  getData() async {
    userName = await SharePre().read("username");
    printLog("Request user name is : $userName");
    mySelfController.text = userName ?? "";
    printLog(
        "Request user name TextEditing controller is : ${mySelfController.text}");
  }

  @override
  void dispose() {
    videoRequestProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: colorPrimaryDark,
        appBar: AppBar(
          backgroundColor: colorPrimaryDark,
          iconTheme: const IconThemeData(color: white),
          leading: Utils.backButton(context),
          title: MyText(
            text: "videorequest",
            multilanguage: true,
            fontsize: Dimens.textlargeBig,
            fontwaight: FontWeight.w600,
            color: white,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.center, child: profileData()),
              const SizedBox(height: 10),
              stepsData(),
              const SizedBox(height: 20),
              typecategory(),
              const SizedBox(height: 10),
              textFiled(),
              const SizedBox(height: 20),
              requestQuestion(),
              const SizedBox(height: 20),
              continueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileData() {
    return Consumer<VideoRequestProvider>(
      builder: (context, videoRequestProvider, child) {
        if (videoRequestProvider.profileLoding) {
          return profileShimmer();
        } else {
          if (videoRequestProvider.profileModel.status == 200 &&
              (videoRequestProvider.profileModel.result?.length ?? 0) > 0) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: MyNetworkImage(
                      imgHeight: 100,
                      imgWidth: 100,
                      imageUrl:
                          videoRequestProvider.profileModel.result?[0].image ??
                              "",
                      fit: BoxFit.fill),
                ),
                const SizedBox(height: 10),
                MyText(
                  color: colorAccent,
                  text: videoRequestProvider.profileModel.result?[0].fullName ??
                      "",
                  fontsize: Dimens.textTitle,
                  fontwaight: FontWeight.w600,
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget profileShimmer() {
    return const Column(
      children: [
        CustomWidget.circular(height: 100, width: 100),
        SizedBox(height: 10),
        CustomWidget.roundcorner(height: 20, width: 150),
      ],
    );
  }

  Widget stepsData() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activeStep == 1 ? colorAccent : grey),
              child: MyText(
                text: "1",
                fontsize: Dimens.textTitle,
                color: white,
                fontwaight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            MyText(
              text: "writeyourrequest",
              multilanguage: true,
              fontsize: Dimens.textSmall,
              maxline: 2,
              overflow: TextOverflow.ellipsis,
              color: activeStep == 1 ? colorAccent : white,
              fontwaight: FontWeight.w600,
            )
          ],
        ),
        const Expanded(
          child: DottedLine(
              dashLength: 10,
              dashGapLength: 5,
              lineThickness: 1,
              dashColor: grey),
        ),
        Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 34,
              width: 34,
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: grey),
              child: MyText(
                text: "2",
                fontsize: Dimens.textTitle,
                color: white,
                fontwaight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            MyText(
              text: "makepayment",
              multilanguage: true,
              fontsize: Dimens.textSmall,
              maxline: 2,
              overflow: TextOverflow.ellipsis,
              color: white,
              fontwaight: FontWeight.w600,
            )
          ],
        )
      ],
    );
  }

  Widget typecategory() {
    return Consumer<VideoRequestProvider>(
      builder: (context, videoRequestProvider, child) {
        if (videoRequestProvider.loaded) {
          return categoryShimmer();
        } else {
          if (videoRequestProvider.categoryModel.status == 200 &&
              (videoRequestProvider.categoryModel.result?.length ?? 0) > 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  color: white,
                  text: 'step1',
                  multilanguage: true,
                  fontsize: Dimens.textTitle,
                  fontwaight: FontWeight.w500,
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField(
                  dropdownColor: colorPrimaryDark,
                  style: Utils.googleFontStyle(
                      4, 16, FontStyle.normal, white, FontWeight.w500),
                  decoration: InputDecoration(
                      hintText: "Type Select...",
                      hintStyle: Utils.googleFontStyle(
                          4, 16, FontStyle.normal, grey, FontWeight.w500),
                      prefixIcon: const Icon(
                        Icons.date_range,
                        color: white,
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              width: 1,
                              color: colorAccent,
                              style: BorderStyle.solid,
                              strokeAlign: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              width: 1,
                              color: colorAccent,
                              style: BorderStyle.solid,
                              strokeAlign: 1)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              width: 1,
                              color: colorAccent,
                              style: BorderStyle.solid,
                              strokeAlign: 1))),
                  value: _selectedValue,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedValue = newValue;
                      printLog("Your selected value is : $_selectedValue");
                    });
                  },
                  items: videoRequestProvider.categoryModel.result!
                      .map((category) {
                    return DropdownMenuItem(
                        value: category.id,
                        child: MyText(
                          text: category.name ?? "",
                          fontsize: Dimens.textTitle,
                          color: white,
                          fontwaight: FontWeight.w600,
                          maxline: 2,
                          overflow: TextOverflow.ellipsis,
                        ));
                  }).toList(),
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget categoryShimmer() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: CustomWidget.rectangular(
        height: 40,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }

  Widget textFiled() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        MyText(
          color: white,
          text: 'step2',
          multilanguage: true,
          fontsize: Dimens.textTitle,
          fontwaight: FontWeight.w500,
        ),
        const SizedBox(height: 15),
        btnVideo(),
        const SizedBox(height: 15),
        isSelectedButton == "1"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    color: white,
                    text: 'to',
                    multilanguage: true,
                    fontsize: Dimens.textMedium,
                    fontwaight: FontWeight.w500,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _toFristnameController,
                    style: Utils.googleFontStyle(
                        4, 14, FontStyle.normal, white, FontWeight.w600),
                    decoration: InputDecoration(
                        hintText: "Jenna",
                        hintStyle: Utils.googleFontStyle(
                            4, 14, FontStyle.normal, grey, FontWeight.w600),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: white,
                        ),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                width: 1,
                                color: colorAccent,
                                style: BorderStyle.solid,
                                strokeAlign: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                width: 1,
                                color: colorAccent,
                                style: BorderStyle.solid,
                                strokeAlign: 1)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                width: 1,
                                color: colorAccent,
                                style: BorderStyle.solid,
                                strokeAlign: 1))),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    color: white,
                    text: 'to',
                    multilanguage: true,
                    fontsize: Dimens.textMedium,
                    fontwaight: FontWeight.w500,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: mySelfController,
                    style: Utils.googleFontStyle(
                        4, 13, FontStyle.normal, white, FontWeight.w600),
                    decoration: InputDecoration(
                        hintText: "Jenna",
                        hintStyle: Utils.googleFontStyle(
                            4, 13, FontStyle.normal, grey, FontWeight.w600),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: white,
                        ),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                width: 1,
                                color: colorAccent,
                                style: BorderStyle.solid,
                                strokeAlign: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                width: 1,
                                color: colorAccent,
                                style: BorderStyle.solid,
                                strokeAlign: 1)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                width: 1,
                                color: colorAccent,
                                style: BorderStyle.solid,
                                strokeAlign: 1))),
                  ),
                ],
              ),
      ],
    );
  }

  Widget requestQuestion() {
    videoRequestProvider.getQuestion(_selectedValue.toString());

    return Consumer<VideoRequestProvider>(
      builder: (context, videoRequestProvider, child) {
        if (videoRequestProvider.questionModel.status == 200 &&
            (videoRequestProvider.questionModel.result?.length ?? 0) > 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                color: white,
                text: 'step3',
                multilanguage: true,
                fontsize: Dimens.textTitle,
                fontwaight: FontWeight.w500,
              ),
              const SizedBox(height: 15),
              ListView.builder(
                itemCount: videoRequestProvider.questionModel.result?.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var question =
                      videoRequestProvider.questionModel.result?[index];
                  var options = question?.options ?? [];
                  if (_selectedValue == _selectedValue) {
                    if ((question?.questionType ?? 0) == 1) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: question?.question ?? "",
                            color: white,
                            fontsize: Dimens.textMedium,
                            fontwaight: FontWeight.w500,
                            maxline: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _relationController,
                            style: Utils.googleFontStyle(4, 14,
                                FontStyle.normal, white, FontWeight.w600),
                            decoration: InputDecoration(
                                hintText: "Write here....",
                                hintStyle: Utils.googleFontStyle(4, 14,
                                    FontStyle.normal, grey, FontWeight.w400),
                                prefixIcon:
                                    const Icon(Icons.person, color: white),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: colorAccent,
                                        style: BorderStyle.solid,
                                        strokeAlign: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: colorAccent,
                                        style: BorderStyle.solid,
                                        strokeAlign: 1)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: colorAccent,
                                        style: BorderStyle.solid,
                                        strokeAlign: 1))),
                          ),
                        ],
                      );
                    } else if ((question?.questionType ?? 0) == 2) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: question?.question ?? "",
                            color: white,
                            fontsize: Dimens.textMedium,
                            fontwaight: FontWeight.w500,
                            maxline: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Column(
                            children: List<Widget>.generate(options.length,
                                (optionIndex) {
                              return Row(
                                children: [
                                  Radio<int>(
                                    activeColor: colorAccent,
                                    value: optionIndex,
                                    groupValue: _selectedRadio,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedRadio = value;
                                        valueRadio = options[value!];
                                        printLog(
                                            "Radio button selected value: $valueRadio");
                                      });
                                    },
                                  ),
                                  MyText(
                                    text: options[optionIndex],
                                    color: white,
                                    fontsize: Dimens.textMedium,
                                    fontwaight: FontWeight.w500,
                                    maxline: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              );
                            }),
                          )
                        ],
                      );
                    } else if ((question?.questionType ?? 0) == 3) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          MyText(
                            text: question?.question ?? "",
                            color: white,
                            fontsize: Dimens.textMedium,
                            fontwaight: FontWeight.w500,
                            maxline: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Column(
                            children: List<Widget>.generate(options.length,
                                (optionIndex) {
                              var option = options[optionIndex];
                              return Row(
                                children: [
                                  Checkbox(
                                    activeColor: white,
                                    checkColor: colorAccent,
                                    value: selectedOptions.contains(option),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedOptions.add(option);
                                          checkValue =
                                              selectedOptions.join(',');
                                        } else {
                                          selectedOptions.remove(option);
                                          checkValue =
                                              selectedOptions.join(',');
                                        }
                                        printLog(
                                            "Selected options: $selectedOptions");
                                        printLog(
                                            "Selected options But String Formate: $checkValue");
                                      });
                                    },
                                  ),
                                  MyText(
                                    text: options[optionIndex],
                                    color: white,
                                    fontsize: Dimens.textMedium,
                                    fontwaight: FontWeight.w500,
                                    maxline: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      );
                    } else if ((question?.questionType ?? 0) == 4) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          MyText(
                            text: question?.question ?? "",
                            color: white,
                            fontsize: Dimens.textMedium,
                            fontwaight: FontWeight.w500,
                            maxline: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField(
                            dropdownColor: colorPrimaryDark,
                            style: Utils.googleFontStyle(4, 16,
                                FontStyle.normal, white, FontWeight.w500),
                            decoration: InputDecoration(
                                hintText: "Celebrity Select...",
                                hintStyle: Utils.googleFontStyle(4, 16,
                                    FontStyle.normal, grey, FontWeight.w500),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: colorAccent,
                                        style: BorderStyle.solid,
                                        strokeAlign: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: colorAccent,
                                        style: BorderStyle.solid,
                                        strokeAlign: 1)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: colorAccent,
                                        style: BorderStyle.solid,
                                        strokeAlign: 1))),
                            value: selectCelValue,
                            items: question!.options!.map((optionIndex) {
                              return DropdownMenuItem(
                                  value: optionIndex,
                                  child: MyText(
                                    text: optionIndex,
                                    fontsize: Dimens.textMedium,
                                    color: white,
                                    fontwaight: FontWeight.w600,
                                  ));
                            }).toList(),
                            onChanged: (value) {
                              selectCelValue = value;
                              printLog(
                                  "Your Selected DropDown Button Value is : $selectCelValue");
                            },
                          )
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> videoRequestApi(String videoFor, String fullName,
      String toUserId, String categoryId, String fees, answers) async {
    try {
      await videoRequestProvider.getVideoRequest(
          videoFor, fullName, toUserId, categoryId, fees, answers);

      if (videoRequestProvider.successModel.status == 200) {
        printLog(videoRequestProvider.successModel.message ?? "");
        if (!mounted) return;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaymentPage(
            professionId: videoRequestProvider
                    .profileModel.result?[0].professionId
                    .toString() ??
                "",
            reuestId:
                videoRequestProvider.profileModel.result?[0].id.toString() ??
                    "",
            name: videoRequestProvider.profileModel.result?[0].fullName
                    .toString() ??
                "",
            id: widget.id ?? "",
            fees:
                videoRequestProvider.profileModel.result?[0].fees.toString() ??
                    "",
            image: videoRequestProvider.profileModel.result?[0].image ?? "",
          ),
        ));
      } else {
        printLog(videoRequestProvider.successModel.message ?? "");
      }
    } catch (e) {
      printLog(e.toString());
    }
  }

  Widget btnVideo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Container(
            height: 42,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(color: colorAccent, blurRadius: 4),
                ],
                borderRadius: BorderRadius.circular(20),
                color: isSelectedButton == "0" ? colorPrimary : colorAccent),
            child: TextButton(
                onPressed: () {
                  setState(() {
                    isSelectedButton = "1";
                  });
                  printLog(
                      "Your selected button some One Elese :$isSelectedButton");
                },
                child: MyText(
                  text: "else",
                  multilanguage: true,
                  fontsize: Dimens.textTitle,
                  fontwaight: FontWeight.w600,
                  color: white,
                )),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 42,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isSelectedButton == "0" ? colorAccent : colorPrimary,
            ),
            child: TextButton(
                onPressed: () {
                  setState(() {
                    isSelectedButton = "0";
                  });
                  printLog("Your selected button MySelf :$isSelectedButton");
                },
                child: MyText(
                  text: "self",
                  multilanguage: true,
                  fontsize: Dimens.textTitle,
                  fontwaight: FontWeight.w600,
                  color: white,
                )),
          ),
        ),
      ],
    );
  }

  Widget continueButton() {
    return Container(
      height: 42,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorAccent,
      ),
      child: TextButton(
          onPressed: () {
            // Prepare the details array
            List<Map<String, dynamic>> details = [];

            if (_selectedValue != null) {
              var filterData = videoRequestProvider.questionModel.result
                  ?.where(
                    (element) => element.categoryId == _selectedValue,
                  )
                  .toList();
              // Log the filtered questions
              printLog(
                  "Filtered Data: ${filterData?.map((q) => q.question).toList()}");

              if (filterData != null && filterData.isNotEmpty) {
                for (var question in filterData) {
                  String answer = '';

                  switch (question.questionType) {
                    case 1:
                      answer = _relationController.text.toString();
                      break;
                    case 2:
                      answer = valueRadio ?? '';
                      break;
                    case 3:
                      answer = selectedOptions.join(',');
                      break;
                    case 4:
                      answer = selectCelValue.toString();
                      break;
                    default:
                      break;
                  }

                  details.add({
                    'question': question.question ?? "",
                    'answer': answer,
                  });
                }
              } else {
                printLog("No questions available for the selected category.");
              }
              printLog("List Value: $details");

              if (_toFristnameController.text.isEmpty &&
                  isSelectedButton == "1") {
                Utils().showToast("Full name is Required...");
              } else {
                videoRequestApi(
                  isSelectedButton ?? "",
                  isSelectedButton == "0"
                      ? mySelfController.text
                      : _toFristnameController.text.toString(),
                  widget.id ?? "",
                  _selectedValue.toString(),
                  videoRequestProvider.profileModel.result?[0].fees
                          .toString() ??
                      "",
                  details,
                );
              }
            } else {
              Utils().showToast("Select the type is required....");
            }
          },
          child: MyText(
            text: "continue",
            multilanguage: true,
            fontsize: Dimens.textBig,
            fontwaight: FontWeight.w600,
            color: white,
          )),
    );
  }

  Future<void> dateTimeData(BuildContext context) async {
    final DateTime? dateTime = await showDatePicker(
        context: context,
        firstDate: DateTime(1990),
        lastDate: DateTime(2230),
        initialDate: DateTime.now());
    if (dateTime != null && dateTime != _selectedDate) {
      setState(() {
        _selectedDate = dateTime;
        _brithController.text =
            '${dateTime.day}/${dateTime.month}/${dateTime.year}';
        _dateController.text = '${dateTime.month}/${dateTime.day}';
        ageCount(dateTime);
      });
    }
  }

  void ageCount(DateTime brithDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - brithDate.year;
    int month1 = brithDate.month;
    int month2 = currentDate.month;
    if (month2 < month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = brithDate.day;
      int day2 = currentDate.day;
      if (day2 < day1) {
        age--;
      }
    }
    setState(() {
      _ageController.text = age.toString();
      printLog("Your age is ");
    });
  }
}
