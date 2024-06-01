import 'package:flutter/material.dart';

class RegisterControllers {
  final nameController = TextEditingController();
  final experienceController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();

  void dispose() {
    nameController.dispose();
    experienceController.dispose();
    addressController.dispose();
    passwordController.dispose();
  }
}
