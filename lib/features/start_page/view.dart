import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/theming/assets.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_elevated_with_image.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';
import 'package:tasky_app/features/login/view.dart';

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: ListView(
        children: [
          Image.asset(
            AssetsStrings.authImage,
            height: 0.6.sh,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              children: [
                Center(
                  child: CustomText(
                    text: "Task Management & \nTo-Do List",
                    color: ColorManager.black,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CustomText(
                      text:
                          "This productive tool is designed to help you better manage your task project-wise conveniently!",
                      color: ColorManager.grey,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      maxLines: 6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 20.h,
            ),
            child: CustomElevatedWithImage(
              text: "Let’s Start",
              press: () {
                MagicRouter.navigateTo(page: const LoginView());
              },
              btnColor: ColorManager.mainColor,
              image: AssetsStrings.arrowRight,
              iconColor: ColorManager.white,
              fontColor: ColorManager.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
