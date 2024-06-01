import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MagicRouter {
  static BuildContext currentContext = navigatorKey.currentContext!;

  static void navigateTo({required Widget page, bool withHistory = true}) {
    Navigator.pushAndRemoveUntil(
      currentContext,
      PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
        pageBuilder: (context, animation, secondaryAnimation) => page,
      ),
      (route) => withHistory,
    );
  }

  static void navigateReplacement({required Widget page}) {
    Navigator.pushReplacement(
      currentContext,
      PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
        pageBuilder: (context, animation, secondaryAnimation) => page,
      ),
    );
  }

  static void navigatePop() {
    Navigator.pop(currentContext);
  }
}
