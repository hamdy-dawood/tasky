import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';

mainDialog(
    {required BuildContext context,
    required VoidCallback yesPress,
    required String title,
    required String buttonText,
    subTitle}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: CustomText(
          text: title,
          color: ColorManager.black,
          fontSize: 25.sp,
          fontWeight: FontWeight.w500,
        ),
        content: CustomText(
          text: subTitle,
          color: ColorManager.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.normal,
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: CustomText(
                text: "cancel",
                color: ColorManager.mainColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          TextButton(
            onPressed: yesPress,
            style: TextButton.styleFrom(
              foregroundColor: ColorManager.white,
              backgroundColor: ColorManager.mainColor,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: CustomText(
                text: buttonText,
                color: ColorManager.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    },
  );
}
