import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/theming/colors.dart';

import 'custom_text.dart';

class EmitNetworkItem extends StatelessWidget {
  const EmitNetworkItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomText(
        text: "Error Network",
        color: ColorManager.black,
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
