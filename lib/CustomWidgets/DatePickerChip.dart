import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum DatePickerChipState {
  active,
  selected,
  disabled,
}

class DatePickerChip extends StatelessWidget {
  final GestureTapCallback onTap;
  final DatePickerChipState state;
  final String date;
  final String day;
  const DatePickerChip({
    Key? key,
    required this.onTap,
    this.state = DatePickerChipState.active,
    required this.date,
    required this.day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: state == DatePickerChipState.disabled,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 90.h,
          width: 80.w,
          decoration: BoxDecoration(
            color: state == DatePickerChipState.disabled
                ? const Color(0xFFFFFFFF).withOpacity(0.9)
                : Color(state == DatePickerChipState.selected
                    ? 0xFF084B7F
                    : 0xFFFFFFFF),
            border: state == DatePickerChipState.selected
                ? const Border()
                : Border.all(
                    width: 1.sp,
                    color: const Color(0xFF6B779A),
                  ),
            borderRadius: BorderRadius.circular(13.r),
            boxShadow: [
              state == DatePickerChipState.selected
                  ? BoxShadow(
                      blurRadius: 60.r,
                      color: Colors.black.withOpacity(0.1),
                    )
                  : const BoxShadow(),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 19.h),
              Text(
                date,
                style: state == DatePickerChipState.selected
                    ? GoogleFonts.raleway(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      )
                    : GoogleFonts.raleway(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6B779A),
                      ),
                textScaleFactor: 1.sp,
              ),
              SizedBox(height: 14.h),
              Text(
                day,
                style: state == DatePickerChipState.selected
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
            ],
          ),
        ),
      ),
    );
  }
}
