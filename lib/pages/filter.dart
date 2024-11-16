import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:flutter/material.dart';

class Filters extends StatefulWidget {
  const Filters({super.key});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  final Map<String, bool> _sortVlaue = {
    "Recommended": false,
    "Price : Low to High": false,
    "Price : High to Low": false,
    "Newest": false,
    "Alphabetical": false,
  };

  final Map<String, bool> _priceVlaue = {
    "\$0 - \$50": false,
    "\$100 - \$200": false,
    "\$200 - \$300": false,
    "\$300 - \$400": false,
    "\$500": false,
  };
  final Map<String, bool> _categoriesVlaue = {
    "Mix": false,
    "Musician": false,
    "Actor/Actress": false,
    "Comedian": false,
    "TV Star": false,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      appBar: AppBar(
        backgroundColor: colorPrimaryDark,
        iconTheme: const IconThemeData(color: white),
        title: MyText(
          text: "filter",
          multilanguage: true,
          color: white,
          fontsize: Dimens.textlargeBig,
          fontwaight: FontWeight.w600,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: colorPrimary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(36), topRight: Radius.circular(36))),
        child: filterData(),
      ),
    );
  }

  Widget filterData() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: "sort",
            multilanguage: true,
            color: grey,
            fontstyle: FontStyle.normal,
            fontsize: Dimens.textTitle,
            fontwaight: FontWeight.w400,
          ),
          sortBy(),
          const Divider(
            thickness: 1,
            color: grey,
            height: 20,
          ),
          MyText(
            text: "price",
            multilanguage: true,
            color: grey,
            fontstyle: FontStyle.normal,
            fontsize: Dimens.textTitle,
            fontwaight: FontWeight.w400,
          ),
          priceData(),
          const Divider(
            thickness: 1,
            color: grey,
            height: 20,
          ),
          MyText(
            text: "categories",
            multilanguage: true,
            color: grey,
            fontstyle: FontStyle.normal,
            fontsize: Dimens.textTitle,
            fontwaight: FontWeight.w400,
          ),
          categoryData(),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: transparent,
                        side: const BorderSide(
                            width: 1, color: grey, style: BorderStyle.solid),
                        minimumSize: const Size(160, 48)),
                    onPressed: () {},
                    child: MyText(
                      text: "clear",
                      multilanguage: true,
                      color: grey,
                      fontsize: Dimens.textTitle,
                      fontwaight: FontWeight.w400,
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colorAccent,
                        minimumSize: const Size(160, 48)),
                    onPressed: () {},
                    child: MyText(
                      text: "apply",
                      multilanguage: true,
                      color: white,
                      fontsize: Dimens.textTitle,
                      fontwaight: FontWeight.w600,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sortBy() {
    return Column(
      children: _sortVlaue.keys.map((String key) {
        return CheckboxListTile(
          activeColor: colorAccent,
          value: _sortVlaue[key],
          title: MyText(
            text: key,
            fontsize: Dimens.textTitle,
            color: white,
          ),
          onChanged: (value) {
            setState(() {
              _sortVlaue[key] = value!;
            });
          },
        );
      }).toList(),
    );
  }

  Widget priceData() {
    return Column(
      children: _priceVlaue.keys.map((String key) {
        return CheckboxListTile(
          activeColor: colorAccent,
          value: _priceVlaue[key],
          title: MyText(
            text: key,
            fontsize: Dimens.textTitle,
            color: white,
          ),
          onChanged: (value) {
            setState(() {
              _priceVlaue[key] = value!;
            });
          },
        );
      }).toList(),
    );
  }

  Widget categoryData() {
    return Column(
      children: _categoriesVlaue.keys.map((String key) {
        return CheckboxListTile(
          activeColor: colorAccent,
          value: _categoriesVlaue[key],
          title: MyText(
            text: key,
            fontsize: Dimens.textTitle,
            color: white,
          ),
          onChanged: (value) {
            setState(() {
              _categoriesVlaue[key] = value!;
            });
          },
        );
      }).toList(),
    );
  }
}
