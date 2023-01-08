import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomChipColor {
  white,
  blue,
}

class CustomChip extends StatelessWidget {
  final GestureTapCallback onTap;
  final CustomChipColor color;
  final String title;
  const CustomChip({
    Key? key,
    required this.onTap,
    this.color = CustomChipColor.white,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 40.h,
        width: 100.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(color == CustomChipColor.blue ? 0xFF084B7F : 0xFFFFFFFF),
          border: color == CustomChipColor.blue
              ? const Border()
              : Border.all(
                  width: 1.sp,
                  color: const Color(0xFF6B779A),
                ),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            color == CustomChipColor.blue
                ? BoxShadow(
                    blurRadius: 60.r,
                    color: Colors.black.withOpacity(0.1),
                  )
                : const BoxShadow(),
          ],
        ),
        child: Text(
          title,
          style: color == CustomChipColor.blue
              ? GoogleFonts.raleway(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                )
              : GoogleFonts.raleway(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B779A),
                ),
          textScaleFactor: 1.sp,
        ),
      ),
    );
  }
}
