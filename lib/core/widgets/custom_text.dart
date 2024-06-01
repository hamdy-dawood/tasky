import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    required this.color,
    required this.fontWeight,
    required this.fontSize,
    this.textDecoration = TextDecoration.none,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.textScaleFactor,
    this.height = 1.5,
  });

  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double fontSize;
  final TextDecoration textDecoration;
  final TextAlign textAlign;
  final int? maxLines;
  final double? height;
  final double? textScaleFactor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaleFactor: textScaleFactor,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            height: height,
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
            decoration: textDecoration,
          ),
    );
  }
}
