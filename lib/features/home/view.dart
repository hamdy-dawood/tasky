import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/helpers/cache_helper.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/theming/assets.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';
import 'package:tasky_app/core/widgets/dialog.dart';
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
import 'widgets/emit_state_refresh.dart';
import 'widgets/task_item.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final cubit = HomeCubit.get(context);

    cubit.selectedItem = 0;
    cubit.selectedItemName = "";
    cubit.products.clear();
    cubit.isMainLoad = true;
    cubit.currentPage = 1;
    cubit.getProducts(status: "");

    cubit.scrollController.addListener(() {
      if (cubit.scrollController.position.pixels ==
          cubit.scrollController.position.maxScrollExtent) {
        cubit.getNextPage(
          status: cubit.selectedItemName,
        );
      }
    });

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
              mainDialog(
                context: context,
                title: "Logout",
                subTitle: "Are you sure want to logout?",
                buttonText: 'Logout',
                yesPress: () {
                  CacheHelper.removeData(key: "access_token");
                  MagicRouter.navigateTo(
                    page: const LoginView(),
                    withHistory: false,
                  );
                },
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
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));

          // cubit.selectedItem = 0;
          // cubit.selectedItemName = "";
          cubit.products.clear();
          cubit.isMainLoad = true;
          cubit.currentPage = 1;
          // cubit.onSelectedItem(index: 0, name: "");

          cubit.getProducts(
            status: cubit.selectedItemName,
          );
        },
        color: ColorManager.mainColor,
        backgroundColor: ColorManager.white,
        child: Padding(
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
                      cubit: cubit,
                      text: "All",
                      fontWeight: FontWeight.w700,
                      index: 0,
                    ),
                    TabItem(
                      cubit: cubit,
                      text: "Inprogress",
                      index: 1,
                    ),
                    TabItem(
                      cubit: cubit,
                      text: "Waiting",
                      index: 2,
                    ),
                    TabItem(
                      cubit: cubit,
                      text: "Finished",
                      index: 3,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: BlocBuilder<HomeCubit, HomeStates>(
                  buildWhen: (previous, current) =>
                      current is! PaginationHomeLoadingState,
                  builder: (context, state) {
                    if (state is HomeLoadingState) {
                      return const EmitStateForRefresh(
                        widget: EmitLoadingItem(),
                      );
                    } else if (state is HomeNetworkErrorState) {
                      return const EmitStateForRefresh(
                        widget: EmitNetworkItem(),
                      );
                    } else if (state is HomeFailedState) {
                      return EmitStateForRefresh(
                        widget: EmitFailedItem(text: state.msg),
                      );
                    }

                    return cubit.products.isNotEmpty
                        ? Stack(
                            children: [
                              ListView.builder(
                                controller: cubit.scrollController,
                                itemCount: cubit.products.length,
                                itemBuilder: (context, index) {
                                  final product = cubit.products[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 30.h,
                                    ),
                                    child: TaskItem(
                                      id: "${product.id}",
                                      user: "${product.user}",
                                      image: "${product.image}",
                                      title: "${product.title}",
                                      status: "${product.status}",
                                      description: "${product.desc}",
                                      priority: "${product.priority}",
                                      date: "${product.createdAt}",
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                bottom: 0,
                                child: SizedBox(
                                  height: 60.h,
                                  width: 1.sw,
                                  child: BlocBuilder<HomeCubit, HomeStates>(
                                    buildWhen: (previous, current) =>
                                        current is PaginationHomeLoadingState ||
                                        current is HomeSuccessState,
                                    builder: (context, state) {
                                      if (state is PaginationHomeLoadingState) {
                                        return const EmitLoadingItem();
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        : EmitStateForRefresh(
                            widget: Center(
                              child: CustomText(
                                text: "No Data Found",
                                color: ColorManager.mainColor,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
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
