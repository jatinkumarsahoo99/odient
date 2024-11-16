import 'package:dotted_border/dotted_border.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/myimage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NewRequest extends StatefulWidget {
  const NewRequest({super.key});

  @override
  State<NewRequest> createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      appBar: AppBar(
        leading: Utils.backButton(context),
        backgroundColor: colorPrimaryDark,
        iconTheme: const IconThemeData(color: white),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(15, 35, 15, 0),
        decoration: const BoxDecoration(
            color: colorPrimary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(36), topRight: Radius.circular(36))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(child: SizedBox.shrink()),
                  const SizedBox(
                    width: 50,
                    child: Divider(
                      thickness: 2,
                      color: grey,
                      height: 10,
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  MyText(
                      color: white,
                      text: 'cancel',
                      multilanguage: true,
                      fontsize: Dimens.textSmall,
                      fontwaight: FontWeight.w400),
                ],
              ),
              MyText(
                  color: white,
                  text: 'newrequest',
                  multilanguage: true,
                  fontsize: Dimens.textSmall,
                  fontwaight: FontWeight.w400),
              const SizedBox(height: 40),
              const MyImage(
                width: 70,
                height: 70,
                imagePath: "followimg.png",
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 15),
              MyText(
                  color: colorAccent,
                  text: 'Lucy Jodan',
                  fontsize: Dimens.textMedium,
                  fontwaight: FontWeight.w600),
              const SizedBox(height: 55),
              newrequestData(),
            ],
          ),
        ),
      ),
    );
  }

  Widget newrequestData() {
    return AlignedGridView.count(
      crossAxisCount: 1,
      itemCount: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(20),
                  dashPattern: const [5, 5],
                  padding: const EdgeInsets.all(15),
                  color: Colors.grey,
                  strokeWidth: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                          color: white,
                          text: 'Introduce Yourself',
                          fontsize: Dimens.textMedium,
                          fontwaight: FontWeight.w600),
                      MyText(
                          color: white,
                          text: 'You’re meeting your Hero, time to fan out ',
                          fontsize: Dimens.textSmall,
                          fontwaight: FontWeight.w400),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    height: 25,
                    width: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: grey),
                        color: colorAccent,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Icon(
                      Icons.add,
                      color: white,
                      size: 15,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}
