import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasky_app/core/helpers/cache_helper.dart';
import 'package:tasky_app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}
