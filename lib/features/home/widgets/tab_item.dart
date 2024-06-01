import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';

class TabItem extends StatelessWidget {
  const TabItem({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
    this.fontWeight = FontWeight.w400,
    this.borderRadius = 26,
    this.otherPadding = false,
  });

  final String text;
  final Color color, textColor;
  final FontWeight fontWeight;
  final double borderRadius;
  final bool otherPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: otherPadding
          ? EdgeInsets.symmetric(vertical: 5.w, horizontal: 8.w)
          : EdgeInsets.symmetric(
              vertical: 10.h,
              horizontal: 15.h,
            ),
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.r),
        color: color,
      ),
      child: CustomText(
        text: text,
        color: textColor,
        fontSize: 14.sp,
        fontWeight: fontWeight,
      ),
    );
  }
}
