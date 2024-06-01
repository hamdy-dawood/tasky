import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/core/helpers/cache_helper.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/emit_loading_item.dart';
import 'package:tasky_app/features/home/view.dart';
import 'package:tasky_app/features/login/view.dart';

import 'cubit.dart';
import 'states.dart';

class RefreshTokenView extends StatelessWidget {
  const RefreshTokenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RefreshTokenCubit()..getToken(),
      child: const _RefreshTokenBody(),
    );
  }
}

class _RefreshTokenBody extends StatelessWidget {
  const _RefreshTokenBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: BlocConsumer<RefreshTokenCubit, RefreshTokenStates>(
        listener: (context, state) {
          if (state is RefreshTokenFailedState) {
            CacheHelper.removeData(key: "access_token");
            MagicRouter.navigateTo(
              page: const LoginView(),
              withHistory: false,
            );
          } else if (state is RefreshTokenSuccessState ||
              state is RefreshTokenErrorNetworkState) {
            MagicRouter.navigateTo(
              page: const HomeView(),
              withHistory: false,
            );
          }
        },
        builder: (context, state) {
          if (state is RefreshTokenLoadingState) {
            return const EmitLoadingItem();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
