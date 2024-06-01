import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/theming/assets.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';
import 'package:tasky_app/core/widgets/snack_bar.dart';
import 'package:tasky_app/core/widgets/svg_icons.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.title,
    required this.body,
    this.withCody = false,
  });

  final String title, body;
  final bool withCody;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: ColorManager.grey7,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title.toUpperCase(),
                  color: ColorManager.grey5,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: body,
                  color: ColorManager.grey6,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
          withCody
              ? IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: body));
                    showMessage(
                      message: "Copied",
                      color: ColorManager.green,
                    );
                  },
                  icon: SvgIcon(
                    icon: AssetsStrings.copy,
                    color: ColorManager.mainColor,
                    height: 25.h,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
