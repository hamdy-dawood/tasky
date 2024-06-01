import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky_app/core/theming/assets.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';

class EndDateWidget extends StatelessWidget {
  const EndDateWidget({super.key, required this.date});
  final String date;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "End Date",
                  color: ColorManager.grey,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 5.h),
                CustomText(
                  text: date.split("T")[0],
                  color: ColorManager.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            AssetsStrings.calendar,
            height: 30.h,
          ),
        ],
      ),
    );
  }
}
