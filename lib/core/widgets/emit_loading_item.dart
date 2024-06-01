import 'package:flutter/material.dart';
import 'package:tasky_app/core/theming/colors.dart';

class EmitLoadingItem extends StatelessWidget {
  const EmitLoadingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: ColorManager.mainColor,
      ),
    );
  }
}
