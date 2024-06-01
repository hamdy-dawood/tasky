import 'package:flutter/material.dart';

class LoginControllers {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
  }
}
