import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/networking/urls_strings.dart';
import 'package:tasky_app/core/theming/assets.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';
import 'package:tasky_app/core/widgets/dialog.dart';
import 'package:tasky_app/core/widgets/svg_icons.dart';
import 'package:tasky_app/features/add_task/view.dart';
import 'package:tasky_app/features/details/cubit.dart';
import 'package:tasky_app/features/details/view.dart';
import 'package:tasky_app/features/remove_ad/view.dart';

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
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.w,
                          horizontal: 8.w,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: status.toLowerCase() == "waiting"
                              ? ColorManager.orange2
                              : status.toLowerCase() == "inprogress"
                                  ? ColorManager.secColor
                                  : status.toLowerCase() == "finished"
                                      ? ColorManager.blue2
                                      : ColorManager.orange2,
                        ),
                        child: CustomText(
                          text: status,
                          color: status.toLowerCase() == "waiting"
                              ? ColorManager.orange
                              : status.toLowerCase() == "inprogress"
                                  ? ColorManager.mainColor
                                  : status.toLowerCase() == "finished"
                                      ? ColorManager.blue
                                      : ColorManager.orange,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
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
            PopupMenuButton<MenuItem>(
              elevation: 0.5,
              color: ColorManager.white,
              position: PopupMenuPosition.over,
              icon: SvgIcon(
                icon: AssetsStrings.dots,
                color: ColorManager.black,
                height: 25.h,
              ),
              onSelected: (item) => onSelected(
                context: context,
                item: item,
                id: id,
                user: user,
                editImageTextUploaded: image,
                editTitle: title,
                editDesc: description,
                editPriority: priority,
                status: status,
              ),
              itemBuilder: (context) => MenuItems.items.map(buildItem).toList(),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
        value: item,
        child: CustomText(
          text: item.text,
          color: item.color,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
      );

  void onSelected({
    required BuildContext context,
    required MenuItem item,
    required String id,
    required String user,
    required String editImageTextUploaded,
    required String editTitle,
    required String editDesc,
    required String editPriority,
    required String status,
  }) {
    if (item == MenuItems.itemEdit) {
      MagicRouter.navigateTo(
        page: AddTaskView(
          fromEdit: true,
          id: id,
          user: user,
          editImageTextUploaded: editImageTextUploaded,
          editTitle: editTitle,
          editDesc: editDesc,
          editPriority: editPriority,
          status: status,
        ),
      );
    } else if (item == MenuItems.itemDelete) {
      mainDialog(
        context: context,
        title: "Delete",
        subTitle: "Are you sure want to Delete $editTitle?",
        buttonText: 'Delete',
        yesPress: () {
          MagicRouter.navigateTo(
            page: RemoveAdView(
              id: id,
            ),
          );
        },
      );
    }
  }
}
