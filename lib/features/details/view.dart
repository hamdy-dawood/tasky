import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/networking/urls_strings.dart';
import 'package:tasky_app/core/theming/assets.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';
import 'package:tasky_app/core/widgets/dialog.dart';
import 'package:tasky_app/core/widgets/emit_failed_item.dart';
import 'package:tasky_app/core/widgets/emit_loading_item.dart';
import 'package:tasky_app/core/widgets/emit_network_item.dart';
import 'package:tasky_app/core/widgets/svg_icons.dart';
import 'package:tasky_app/features/add_task/view.dart';
import 'package:tasky_app/features/remove_ad/view.dart';

import 'cubit.dart';
import 'states.dart';
import 'widgets/custom_container.dart';
import 'widgets/end_date.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({
    super.key,
    required this.id,
    required this.user,
    this.fromScanner = false,
  });

  final String id, user;
  final bool fromScanner;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailsCubit()..getTask(id: id),
      child: _DetailsBody(
        id: id,
        user: user,
        fromScanner: fromScanner,
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody(
      {required this.id, required this.user, required this.fromScanner});

  final String id, user;
  final bool fromScanner;

  @override
  Widget build(BuildContext context) {
    final cubit = DetailsCubit.get(context);

    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgIcon(
            icon: AssetsStrings.arrowLeft,
            color: ColorManager.black,
            height: 25.h,
          ),
        ),
        title: CustomText(
          text: "Task Details",
          color: ColorManager.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
        actions: [
          !fromScanner
              ? PopupMenuButton<MenuItem>(
                  elevation: 0.5,
                  color: ColorManager.white,
                  position: PopupMenuPosition.under,
                  icon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: SvgIcon(
                      icon: AssetsStrings.dots,
                      color: ColorManager.black,
                      height: 25.h,
                    ),
                  ),
                  onSelected: (item) => onSelected(
                    context: context,
                    item: item,
                    id: id,
                    user: user,
                    editImageTextUploaded: "${cubit.task!.image}",
                    editTitle: "${cubit.task!.title}",
                    editDesc: "${cubit.task!.desc}",
                    editPriority: "${cubit.task!.priority}",
                    status: "${cubit.task!.status}",
                  ),
                  itemBuilder: (context) =>
                      MenuItems.items.map(buildItem).toList(),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: BlocBuilder<DetailsCubit, DetailsStates>(
          builder: (context, state) {
            if (state is DetailsLoadingState) {
              return const EmitLoadingItem();
            } else if (state is DetailsNetworkErrorState) {
              return const EmitNetworkItem();
            } else if (state is DetailsFailedState) {
              return EmitFailedItem(text: state.msg);
            }
            return ListView(
              children: [
                Image.network(
                  "${UrlsStrings.baseImagesUrl}${cubit.task!.image}",
                  height: 0.25.sh,
                  fit: BoxFit.scaleDown,
                ),
                SizedBox(height: 20.h),
                Text(
                  "${cubit.task!.title}",
                  style: TextStyle(
                    color: ColorManager.black,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "${cubit.task!.desc}",
                  style: TextStyle(
                    color: ColorManager.black2,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20.h),
                EndDateWidget(date: "${cubit.task!.createdAt}"),
                SizedBox(height: 10.h),
                CustomContainer(
                  text: "${cubit.task!.status}",
                ),
                SizedBox(height: 10.h),
                CustomContainer(
                  withIcon: true,
                  text: "${cubit.task!.priority} Priority",
                ),
                SizedBox(height: 30.h),
                Center(
                  child: QrImageView(
                    data: id,
                    size: 0.5.sh,
                  ),
                ),
              ],
            );
          },
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
