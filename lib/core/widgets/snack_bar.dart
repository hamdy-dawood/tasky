import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/theming/colors.dart';

import 'custom_text.dart';

showMessage({
  required String message,
  int maxLines = 5,
  required Color color,
}) {
  ScaffoldMessenger.of(MagicRouter.currentContext).clearSnackBars();
  ScaffoldMessenger.of(MagicRouter.currentContext).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: ColorManager.white,
      elevation: 2.0,
      content: Row(
        children: [
          Container(
            height: 40.h,
            width: 5.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
          SizedBox(width: 18.w),
          Expanded(
            child: CustomText(
              text: message,
              color: ColorManager.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
              maxLines: maxLines,
            ),
          ),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(MagicRouter.currentContext).clearSnackBars();
            },
            child: Icon(
              Icons.close,
              color: ColorManager.black,
            ),
          ),
        ],
      ),
    ),
  );
}
