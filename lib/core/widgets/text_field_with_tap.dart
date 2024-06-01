import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/theming/colors.dart';

class CustomTextFieldWithTap extends StatelessWidget {
  const CustomTextFieldWithTap({
    super.key,
    required this.hint,
    required this.onTap,
    required this.hintColor,
  });
  final String hint;
  final VoidCallback onTap;
  final Color hintColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: hintColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              fontFamily: "Regular",
            ),
        suffixIcon: SizedBox(
          height: 0.02.sh,
          child: Icon(
            Icons.arrow_drop_down_outlined,
            color: ColorManager.grey2,
            size: 20.sp,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 0.001.sh,
            color: ColorManager.grey3,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 0.001.sh,
            color: ColorManager.grey3,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 0.001.sh,
            color: ColorManager.mainColor,
          ),
        ),
      ),
    );
  }
}
