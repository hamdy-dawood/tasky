import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/features/add_task/cubit.dart';

import 'core/helpers/navigator.dart';
import 'features/register/cubit.dart';
import 'features/splash/view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => UserRegisterCubit()),
              BlocProvider(create: (context) => AddTaskCubit()),
            ],
            child: MaterialApp(
              title: "Tasky App",
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              home: child,
            ),
          ),
        );
      },
      child: const SplashView(),
    );
  }
}
