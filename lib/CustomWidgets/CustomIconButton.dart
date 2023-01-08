import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomIconButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final bool inverted;
  final IconData icon;
  const CustomIconButton({
    Key? key,
    required this.onTap,
    this.inverted = false,
    this.icon = Icons.arrow_back,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        constraints: BoxConstraints(maxHeight: 40.w, maxWidth: 40.w),
        padding: EdgeInsets.all(10.sp),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(inverted ? 0xFFEA0001 : 0xFFF1F4F7),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: Color(inverted ? 0xFFF1F4F7 : 0xFFEA0001),
        ),
      ),
    );
  }
}
