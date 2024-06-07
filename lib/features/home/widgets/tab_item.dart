import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';
import 'package:tasky_app/features/home/cubit.dart';
import 'package:tasky_app/features/home/states.dart';

class TabItem extends StatelessWidget {
  const TabItem({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.w400,
    this.borderRadius = 26,
    this.otherPadding = false,
    required this.index,
    required this.cubit,
  });

  final HomeCubit cubit;
  final String text;
  final FontWeight fontWeight;
  final double borderRadius;
  final bool otherPadding;
  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            cubit.selectedItem = 0;
            cubit.selectedItemName = "";
            cubit.products.clear();
            cubit.isMainLoad = true;
            cubit.currentPage = 1;
            cubit.onSelectedItem(
              index: index,
              name: text == "All" ? "" : text.toLowerCase(),
            );

            cubit.getProducts(
              status: text == "All" ? "" : text.toLowerCase(),
            );
          },
          child: Container(
            padding: otherPadding
                ? EdgeInsets.symmetric(vertical: 5.w, horizontal: 8.w)
                : EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 15.h,
                  ),
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius.r),
              color: cubit.selectedItem == index
                  ? ColorManager.mainColor
                  : ColorManager.secColor,
            ),
            child: CustomText(
              text: text,
              color: cubit.selectedItem == index
                  ? ColorManager.white
                  : ColorManager.grey8,
              fontSize: 14.sp,
              fontWeight: fontWeight,
            ),
          ),
        );
      },
    );
  }
}
