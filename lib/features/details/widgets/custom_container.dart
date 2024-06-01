import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky_app/core/theming/assets.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';
import 'package:tasky_app/core/widgets/svg_icons.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    this.withIcon = false,
    required this.text,
  });

  final bool withIcon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15.h,
        horizontal: 15.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: ColorManager.secColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                withIcon
                    ? Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: SvgIcon(
                          icon: AssetsStrings.flag,
                          color: ColorManager.mainColor,
                          height: 22.h,
                        ),
                      )
                    : const SizedBox.shrink(),
                CustomText(
                  text: text,
                  color: ColorManager.mainColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            AssetsStrings.arrowDown,
            height: 30.h,
          ),
        ],
      ),
    );
  }
}
