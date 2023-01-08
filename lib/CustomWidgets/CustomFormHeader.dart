import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFormHeader extends StatelessWidget {
  final String title;
  const CustomFormHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 26.sp,
            color: Colors.blueGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          height: 1.h,
          width: 300.w,
          color: Colors.blueGrey,
        ),
      ],
    );
  }
}
