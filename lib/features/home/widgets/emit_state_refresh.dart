import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmitStateForRefresh extends StatelessWidget {
  const EmitStateForRefresh({super.key, required this.widget});

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 0.3.sh),
        widget,
        SizedBox(height: 0.7.sh),
      ],
    );
  }
}
