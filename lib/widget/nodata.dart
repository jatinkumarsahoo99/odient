import 'package:dtcameo/utils/color.dart';
import 'package:flutter/material.dart';

import '../widget/myimage.dart';

class NoData extends StatelessWidget {
  const NoData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.8,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: transparent,
        borderRadius: BorderRadius.circular(12),
        shape: BoxShape.rectangle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyImage(
            height: 200,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.contain,
            imagePath: "nodata.png",
          ),
        ],
      ),
    );
  }
}
