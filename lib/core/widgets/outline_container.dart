
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';

class OutlinedContainer extends StatelessWidget {
  final VoidCallback onPress;
  final double hSize, wSize, fontSize;
  final String image, text;
  final Color borderBtnColor;
  final Color backgroundColor;
  final FontWeight fontWeight;

  const OutlinedContainer({
    super.key,
    required this.onPress,
    this.hSize = 0.0689,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.wSize = 1,
    required this.image,
    required this.text,
    required this.borderBtnColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPress,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        fixedSize: Size(wSize.sw, hSize.sh),
        side: BorderSide(
          width: 0.002.sh,
          color: borderBtnColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: SizedBox(
        height: 0.029.sh,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              image,
              height: 0.04.sh,
            ),
            SizedBox(
              width: 0.021.sw,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: CustomText(
                text: text,
                color: ColorManager.white,
                fontSize: fontSize.sp,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
