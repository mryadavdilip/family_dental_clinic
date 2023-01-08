import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCopyableText extends StatelessWidget {
  final GestureTapCallback onTap;
  final String title;
  final String text;
  final Color fontColor;
  const CustomCopyableText({
    super.key,
    required this.onTap,
    this.title = '',
    this.text = '',
    this.fontColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: RichText(
        text: TextSpan(
          text: '$title ',
          style: GoogleFonts.raleway(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: fontColor,
          ),
          children: [
            TextSpan(
              text: text,
              style: GoogleFonts.raleway(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: fontColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        textScaleFactor: 1.sp,
      ),
    );
  }
}
