import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/theming/colors.dart';

import 'custom_text.dart';

class EmitFailedItem extends StatelessWidget {
  const EmitFailedItem({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomText(
        text: text,
        color: ColorManager.redPrimary,
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
    );
  }
}
