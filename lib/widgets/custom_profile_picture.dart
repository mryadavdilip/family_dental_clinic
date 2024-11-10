import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProfilePicture extends StatelessWidget {
  final String url;
  final double size;
  const CustomProfilePicture({super.key, this.url = '', this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.w,
      width: size.w,
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
