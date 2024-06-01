import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/helpers/cache_helper.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/theming/assets.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';
import 'package:tasky_app/core/widgets/emit_failed_item.dart';
import 'package:tasky_app/core/widgets/emit_loading_item.dart';
import 'package:tasky_app/core/widgets/emit_network_item.dart';
import 'package:tasky_app/core/widgets/svg_icons.dart';
import 'package:tasky_app/features/add_task/view.dart';
import 'package:tasky_app/features/home/widgets/tab_item.dart';
import 'package:tasky_app/features/login/view.dart';
import 'package:tasky_app/features/profile/view.dart';
import 'package:tasky_app/features/scan_qr/view.dart';

import 'cubit.dart';
import 'states.dart';
import 'widgets/task_item.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getProducts(),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final cubit = HomeCubit.get(context);

    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        title: CustomText(
          text: "Logo",
          color: ColorManager.black,
          fontSize: 26.sp,
          fontWeight: FontWeight.w700,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              MagicRouter.navigateTo(
                page: const ProfileView(),
              );
            },
            child: SvgIcon(
              icon: AssetsStrings.profile,
              color: ColorManager.black,
              height: 28.h,
            ),
          ),
          SizedBox(width: 20.w),
          GestureDetector(
            onTap: () {
              CacheHelper.removeData(key: "access_token");
              MagicRouter.navigateTo(
                page: const LoginView(),
                withHistory: false,
              );
            },
            child: SvgIcon(
              icon: AssetsStrings.logOut,
              color: ColorManager.mainColor,
              height: 28.h,
            ),
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0.02.sh),
            CustomText(
              text: "My Tasks",
              color: ColorManager.black2,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 10.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TabItem(
                    text: "All",
                    color: ColorManager.mainColor,
                    textColor: ColorManager.white,
                    fontWeight: FontWeight.w700,
                  ),
                  TabItem(
                    text: "Inprogress",
                    color: ColorManager.grey9,
                    textColor: ColorManager.grey8,
                  ),
                  TabItem(
                    text: "Waiting",
                    color: ColorManager.grey9,
                    textColor: ColorManager.grey8,
                  ),
                  TabItem(
                    text: "Finished",
                    color: ColorManager.grey9,
                    textColor: ColorManager.grey8,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeStates>(
                builder: (context, state) {
                  if (state is HomeLoadingState) {
                    return const EmitLoadingItem();
                  } else if (state is HomeNetworkErrorState) {
                    return const EmitNetworkItem();
                  } else if (state is HomeFailedState) {
                    return SizedBox(
                      child: EmitFailedItem(text: state.msg),
                    );
                  }
                  return ListView.separated(
                    itemCount: cubit.products.length,
                    separatorBuilder: (context, index) => SizedBox(
                      height: 30.h,
                    ),
                    itemBuilder: (context, index) {
                      final product = cubit.products[index];
                      return TaskItem(
                        id: "${product.id}",
                        user: "${product.user}",
                        image: "${product.image}",
                        title: "${product.title}",
                        status: "${product.status}",
                        description: "${product.desc}",
                        priority: "${product.priority}",
                        date: "${product.createdAt}",
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              MagicRouter.navigateTo(
                page: const QrScanView(),
              );
            },
            child: CircleAvatar(
              radius: 25.r,
              backgroundColor: ColorManager.thirdColor,
              child: SvgIcon(
                icon: AssetsStrings.qr,
                color: ColorManager.mainColor,
                height: 22.h,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () {
              MagicRouter.navigateTo(
                page: const AddTaskView(
                  fromEdit: false,
                ),
              );
            },
            child: CircleAvatar(
              radius: 30.r,
              backgroundColor: ColorManager.mainColor,
              child: SvgIcon(
                icon: AssetsStrings.add,
                color: ColorManager.white,
                height: 22.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
