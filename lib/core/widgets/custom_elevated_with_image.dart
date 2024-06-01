import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';
import 'package:tasky_app/core/widgets/svg_icons.dart';

class CustomElevatedWithImage extends StatelessWidget {
  final String text, image;
  final Color btnColor, iconColor, fontColor;
  final double hSize, wSize, fontSize, borderRadius;
  final VoidCallback press;
  final FontWeight fontWeight;
  final bool haveIcon;

  const CustomElevatedWithImage({
    super.key,
    required this.text,
    required this.image,
    required this.press,
    required this.btnColor,
    required this.iconColor,
    required this.fontColor,
    this.hSize = 0.0689,
    this.wSize = 1,
    this.fontSize = 14,
    this.borderRadius = 12,
    this.fontWeight = FontWeight.w400,
    this.haveIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        backgroundColor: btnColor,
        elevation: 0,
        fixedSize: Size(wSize.sw, hSize.sh),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: CustomText(
                text: text,
                color: ColorManager.white,
                fontSize: fontSize.sp,
                fontWeight: fontWeight,
              ),
            ),
          ),
          haveIcon
              ? Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: SvgIcon(
                    icon: image,
                    color: iconColor,
                    height: 25.h,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
