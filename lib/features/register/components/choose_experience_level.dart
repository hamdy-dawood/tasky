import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';
import 'package:tasky_app/core/widgets/text_field_with_tap.dart';
import 'package:tasky_app/features/register/cubit.dart';
import 'package:tasky_app/features/register/states.dart';

class ChooseExperienceLevel extends StatelessWidget {
  const ChooseExperienceLevel({super.key, required this.cubit});

  final UserRegisterCubit cubit;

  @override
  Widget build(context) {
    return BlocBuilder<UserRegisterCubit, UserRegisterStates>(
      builder: (context, state) {
        return CustomTextFieldWithTap(
          hint: cubit.experienceLevel != ""
              ? cubit.experienceLevel
              : "Choose experience Level",
          hintColor: ColorManager.grey4,
          onTap: () async {
            showModalBottomSheet(
              context: context,
              backgroundColor: ColorManager.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15.r),
                  topLeft: Radius.circular(15.r),
                ),
              ),
              builder: (context) {
                return BlocBuilder<UserRegisterCubit, UserRegisterStates>(
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.all(0.041.sw),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cubit.experienceLevelName.length,
                        itemBuilder: (context, index) {
                          return ItemContainerWidget(
                            onTap: () {
                              cubit.updateExperienceLevel(
                                level: cubit.experienceLevelName[index],
                              );
                              MagicRouter.navigatePop();
                            },
                            title: cubit.experienceLevelName[index],
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class ItemContainerWidget extends StatelessWidget {
  const ItemContainerWidget({
    super.key,
    required this.onTap,
    required this.title,
  });

  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(85.r),
      child: Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(
          horizontal: 0.08.sw,
          vertical: 0.015.sh,
        ),
        margin: EdgeInsets.only(bottom: 18.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(85.r),
          border: Border.all(
            color: ColorManager.grey2,
            width: 0.0012.sh,
          ),
        ),
        child: Center(
          child: FittedBox(
            child: CustomText(
              text: title,
              color: ColorManager.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
