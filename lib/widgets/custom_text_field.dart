import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String lableText;
  final String? additionalNotes;
  final String? hintText;
  final bool isDatePicker;
  final GestureTapCallback? onTap;
  final bool readOnly;
  final int? maxLines;
  final ValueChanged? onChanged;
  final double height;
  final TextInputType? keyboardType;
  final Color fontColor;
  final FontWeight lableWeight;
  final bool enabled;
  const CustomTextField({
    Key? key,
    this.lableText = '',
    this.additionalNotes,
    this.hintText,
    this.controller,
    this.enabled = true,
    this.isDatePicker = false,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.maxLines,
    this.height = 60,
    this.keyboardType = TextInputType.text,
    this.fontColor = const Color(0xFFFAC032),
    this.lableWeight = FontWeight.w500,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.lableText != '',
          child: RichText(
            text: TextSpan(
              text: widget.lableText,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: widget.lableWeight,
                color: const Color(0xFF000000),
              ),
              children: [
                TextSpan(
                  text: widget.additionalNotes != null
                      ? ' (${widget.additionalNotes})'
                      : '',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: widget.lableWeight,
                    color: const Color(0xFFED1C24),
                  ),
                ),
              ],
            ), textScaler: TextScaler.linear(1.sp),
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: widget.height.h,
          width: 330.w,
          child: TextFormField(
            enabled: widget.enabled,
            onTap: widget.onTap,
            controller: widget.controller,
            onChanged: widget.onChanged,
            maxLines: widget.maxLines,
            keyboardType: widget.keyboardType,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: widget.fontColor,
            ),
            readOnly: widget.readOnly || widget.isDatePicker,
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hintText,
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: widget.fontColor,
              ),
              suffixIcon: Visibility(
                visible: widget.isDatePicker,
                child: Icon(
                  Icons.calendar_today,
                  color: widget.fontColor,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.sp,
                  color: const Color(0xFF000000).withOpacity(0.5),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: (widget.maxLines ?? 1).h > 1.h ? 20.h : 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
