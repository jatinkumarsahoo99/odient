import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';

class MyText extends StatelessWidget {
  final String text;
  final double? fontsize;
  final bool? multilanguage;
  final int? maxline;
  final FontStyle? fontstyle;
  final TextAlign? textalign;
  final FontWeight? fontwaight;
  final Color? color;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final String? fontFamily;
  final TextDirection? textDirection;

  const MyText({
    super.key,
    this.color,
    required this.text,
    this.fontsize,
    this.multilanguage,
    this.maxline,
    this.overflow,
    this.textalign,
    this.fontwaight,
    this.letterSpacing,
    this.fontstyle,
    this.fontFamily,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return multilanguage == true || multilanguage != null
        ? LocaleText(text,
            textAlign: textalign,
            overflow: TextOverflow.ellipsis,
            textDirection: textDirection,
            maxLines: maxline,
            style: fontFamily == "JejuHallasan" || fontFamily == "Jejuhallasan"
                ? GoogleFonts.julee(
                    letterSpacing: letterSpacing,
                    fontSize: fontsize,
                    fontStyle: fontstyle,
                    color: color,
                    fontWeight: fontwaight)
                : GoogleFonts.outfit(
                    letterSpacing: letterSpacing,
                    fontSize: fontsize,
                    fontStyle: fontstyle,
                    color: color,
                    fontWeight: fontwaight))
        : Text(text,
            textAlign: textalign,
            overflow: TextOverflow.ellipsis,
            maxLines: maxline,
            style: fontFamily == "JejuHallasan" || fontFamily == "Jejuhallasan"
                ? GoogleFonts.julee(
                    fontSize: fontsize,
                    fontStyle: fontstyle,
                    color: color,
                    fontWeight: fontwaight)
                : GoogleFonts.outfit(
                    fontSize: fontsize,
                    fontStyle: fontstyle,
                    color: color,
                    fontWeight: fontwaight));
  }
}
