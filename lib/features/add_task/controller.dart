import 'package:flutter/material.dart';

class AddTaskControllers {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  void dispose() {
    titleController.dispose();
    descController.dispose();
  }
}
