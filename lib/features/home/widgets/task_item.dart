import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/networking/urls_strings.dart';
import 'package:tasky_app/core/theming/assets.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';
import 'package:tasky_app/core/widgets/svg_icons.dart';
import 'package:tasky_app/features/details/view.dart';

import 'tab_item.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.id,
    required this.user,
    required this.image,
    required this.title,
    required this.status,
    required this.description,
    required this.priority,
    required this.date,
  });

  final String id, user, image, title, status, description, priority, date;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        MagicRouter.navigateTo(
          page: DetailsView(
            id: id,
            user: user,
          ),
        );
      },
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  "${UrlsStrings.baseImagesUrl}$image",
                ),
                radius: 35.r,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          text: title,
                          color: ColorManager.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TabItem(
                        text: status,
                        color: ColorManager.orange2,
                        textColor: ColorManager.orange,
                        fontWeight: FontWeight.w500,
                        borderRadius: 5,
                        otherPadding: true,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: CustomText(
                      text: description,
                      color: ColorManager.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgIcon(
                            icon: AssetsStrings.flag,
                            color: ColorManager.mainColor,
                            height: 22.h,
                          ),
                          SizedBox(width: 5.w),
                          CustomText(
                            text: priority,
                            color: ColorManager.mainColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      CustomText(
                        text: date.split("T")[0],
                        color: ColorManager.black2,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            SvgIcon(
              icon: AssetsStrings.dots,
              color: ColorManager.black,
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }
}
