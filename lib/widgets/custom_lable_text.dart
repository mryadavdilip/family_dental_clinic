import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomLableText extends StatelessWidget {
  final String text;
  const CustomLableText({Key? key, this.text = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 19.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF333333),
          ),
          textScaler: TextScaler.linear(1.sp),
        ),
      ),
    );
  }
}
