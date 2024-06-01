import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:tasky_app/core/theming/colors.dart';

class PhoneNumberInput extends StatelessWidget {
  const PhoneNumberInput({
    super.key,
    required this.onInputChanged,
    this.validator,
    this.isLastInput = false,
    this.readOnly = false,
    this.hint = "phone",
    this.isoCode = "EG",
    this.autoValidate = AutovalidateMode.onUserInteraction,
    this.onTap,
  });
  final Function(PhoneNumber)? onInputChanged;
  final FutureOr<String?> Function(PhoneNumber?)? validator;
  final bool isLastInput, readOnly;
  final String hint;
  final String? isoCode;
  final AutovalidateMode autoValidate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      readOnly: readOnly,
      onTap: onTap,
      initialCountryCode: isoCode,
      onChanged: onInputChanged,
      validator: (value) {
        if (value!.number.isEmpty) {
          return "Enter Phone";
        }
        return null;
      },
      invalidNumberMessage: "Enter Correct Phone",
      autovalidateMode: autoValidate,
      dropdownIconPosition: IconPosition.trailing,
      style: TextStyle(
        color: ColorManager.black,
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        // fontFamily: "Regular",
      ),
      textInputAction:
          isLastInput ? TextInputAction.done : TextInputAction.next,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      dropdownIcon: Icon(
        Icons.arrow_drop_down,
        color: ColorManager.grey2,
      ),
      flagsButtonPadding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: InputDecoration(
        counterStyle: const TextStyle(fontSize: 0),
        enabled: true,
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
            borderSide: BorderSide(
              width: 0.002.sh,
              color: ColorManager.mainColor,
            ),
            borderRadius: BorderRadius.circular(12.r)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.001.sh,
              color: ColorManager.redPrimary,
            ),
            borderRadius: BorderRadius.circular(12.r)),
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: ColorManager.grey3,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              // fontFamily: "Regular",
            ),
      ),
    );
  }
}
