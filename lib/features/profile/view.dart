import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/theming/assets.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';
import 'package:tasky_app/core/widgets/emit_failed_item.dart';
import 'package:tasky_app/core/widgets/emit_loading_item.dart';
import 'package:tasky_app/core/widgets/emit_network_item.dart';
import 'package:tasky_app/core/widgets/svg_icons.dart';
import 'package:tasky_app/features/profile/widgets/profile_item.dart';

import 'cubit.dart';
import 'states.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getUserInfo(),
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    final cubit = ProfileCubit.get(context);

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
          text: "Profile",
          color: ColorManager.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileStates>(
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return const EmitLoadingItem();
          } else if (state is ProfileNetworkErrorState) {
            return const EmitNetworkItem();
          } else if (state is ProfileFailedState) {
            return EmitFailedItem(text: state.msg);
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ListView(
              children: [
                ProfileItem(
                  title: "Name",
                  body: "${cubit.user!.displayName}",
                ),
                ProfileItem(
                  title: "Phone",
                  body: "${cubit.user!.username}",
                  withCody: true,
                ),
                ProfileItem(
                  title: "Level",
                  body: "${cubit.user!.level}",
                ),
                ProfileItem(
                  title: "Years of experience",
                  body: "${cubit.user!.experienceYears} years",
                ),
                ProfileItem(
                  title: "Location",
                  body: "${cubit.user!.address}",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
