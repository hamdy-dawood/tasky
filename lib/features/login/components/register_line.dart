import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/features/register/view.dart';

class RegisterLineWidget extends StatelessWidget {
  const RegisterLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "Didn’t have any account? ",
        style: TextStyle(
          color: ColorManager.grey,
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(
            text: "Sign Up here",
            style: TextStyle(
              color: ColorManager.mainColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                MagicRouter.navigateTo(
                  page: const RegisterView(),
                );
              },
          ),
        ],
      ),
    );
  }
}
