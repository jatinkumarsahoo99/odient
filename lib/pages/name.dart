import 'package:dtcameo/pages/newrequest.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:flutter/material.dart';

class Name extends StatefulWidget {
  const Name({super.key});

  @override
  State<Name> createState() => _NameState();
}

class _NameState extends State<Name> {
  final TextEditingController _nameController = TextEditingController();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 25),
            MyText(
                color: white,
                text: 'whatisyourname',
                multilanguage: true,
                fontsize: Dimens.textTitle,
                fontwaight: FontWeight.w400),
            const SizedBox(height: 15),
            TextFormField(
              controller: _nameController,
              style: Utils.googleFontStyle(
                  4, 15, FontStyle.normal, white, FontWeight.w600),
              decoration: InputDecoration(
                hintText: "Name",
                hintStyle: Utils.googleFontStyle(
                    4, 15, FontStyle.normal, white, FontWeight.w600),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        width: 1, color: grey, style: BorderStyle.solid)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        width: 1, color: grey, style: BorderStyle.solid)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        width: 1, color: grey, style: BorderStyle.solid)),
              ),
            ),
            const SizedBox(height: 130),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NewRequest(),
                ));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: colorAccent,
                  minimumSize: Size(MediaQuery.of(context).size.width, 42)),
              child: MyText(
                  color: white,
                  text: 'save',
                  multilanguage: true,
                  fontsize: Dimens.textTitle,
                  fontwaight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
