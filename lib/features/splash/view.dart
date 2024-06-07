import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/helpers/cache_helper.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/theming/assets.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/features/home/view.dart';
import 'package:tasky_app/features/start_page/view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  _goNext() async {
    String token = CacheHelper.get(key: "access_token") ?? "";
    await Future.delayed(
      const Duration(milliseconds: 1000),
      () {
        MagicRouter.navigateTo(
          page: token.isNotEmpty ? const HomeView() : const StartView(),
          withHistory: false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.mainColor,
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Center(
          child: Image.asset(
            AssetsStrings.appIconImage,
            height: 0.2.sh,
            width: 1.sw,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}
