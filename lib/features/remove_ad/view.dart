import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/emit_loading_item.dart';
import 'package:tasky_app/core/widgets/snack_bar.dart';
import 'package:tasky_app/features/home/view.dart';

import 'cubit.dart';
import 'states.dart';

class RemoveAdView extends StatelessWidget {
  const RemoveAdView({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RemoveAdCubit()..removeAd(itemId: id),
      child: const _RemoveAdBody(),
    );
  }
}

class _RemoveAdBody extends StatelessWidget {
  const _RemoveAdBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Center(
        child: BlocConsumer<RemoveAdCubit, RemoveAdStates>(
          listener: (context, state) {
            if (state is RemoveAdFailedState) {
              showMessage(
                message: state.msg,
                color: ColorManager.redPrimary,
              );
            } else if (state is RemoveAdNetworkErrorState) {
              showMessage(
                message: "check network connection",
                color: ColorManager.redPrimary,
              );
            } else if (state is RemoveAdSuccessState) {
              showMessage(
                message: "Task Deleted",
                color: ColorManager.green,
              );
              return MagicRouter.navigateTo(
                page: const HomeView(),
                withHistory: false,
              );
            }
          },
          builder: (context, state) {
            if (state is RemoveAdLoadingState) {
              return const EmitLoadingItem();
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
