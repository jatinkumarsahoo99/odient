import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtcameo/widget/myimage.dart';
import 'package:flutter/material.dart';

class MyNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? imgHeight, imgWidth;
  final dynamic fit;

  const MyNetworkImage(
      {super.key,
      required this.imageUrl,
      required this.fit,
      this.imgHeight,
      this.imgWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: imgHeight,
      width: imgWidth,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
          ),
        ),
        placeholder: (context, url) {
          return MyImage(
            radius: 15,
            width: imgWidth!,
            height: imgHeight!,
            imagePath: "ic_placeholder.png",
            fit: BoxFit.cover,
          );
        },
        errorWidget: (context, url, error) {
          return MyImage(
            radius: 15,
            width: imgWidth!,
            height: imgHeight!,
            imagePath: "ic_placeholder.png",
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
