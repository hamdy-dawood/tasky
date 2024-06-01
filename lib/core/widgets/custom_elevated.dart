import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';

class CustomElevated extends StatelessWidget {
  final String text;
  final Color textColor, btnColor;
  final double hSize, wSize, fontSize, borderRadius;
  final VoidCallback press;
  final FontWeight fontWeight;

  const CustomElevated({
    super.key,
    required this.text,
    required this.press,
    this.textColor = Colors.white,
    required this.btnColor,
    this.hSize = 0.0689,
    this.wSize = 1,
    this.fontSize = 18,
    this.borderRadius = 12,
    this.fontWeight = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        backgroundColor: btnColor,
        fixedSize: Size(wSize.sw, hSize.sh),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: CustomText(
          text: text,
          color: textColor,
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
