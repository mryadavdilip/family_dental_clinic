import 'package:family_dental_clinic/Authentication/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProfilePicture extends StatelessWidget {
  final String url;
  const CustomProfilePicture({super.key, this.url = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.w,
      width: 100.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1.sp,
          color: Colors.white,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 3.r,
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 5.r,
            offset: Offset(1.sp, 1.sp),
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
