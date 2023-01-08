import 'package:family_dental_clinic/CustomWidgets/CustomFormButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

enum CustomFormTextFieldType {
  text,
  email,
  password,
  phone,
  datePicker,
  address,
  gender,
}

class CustomFormTextField extends StatefulWidget {
  final TextEditingController controller;
  final CustomFormTextFieldType fieldType;
  final String lableText;
  final String hintText;
  final Set<String> gendersList;
  final double width;
  const CustomFormTextField({
    Key? key,
    required this.controller,
    this.lableText = '',
    this.hintText = '',
    this.fieldType = CustomFormTextFieldType.text,
    this.gendersList = const {},
    this.width = 300,
  }) : super(key: key);

  @override
  State<CustomFormTextField> createState() => _CustomFormTextFieldState();
}

class _CustomFormTextFieldState extends State<CustomFormTextField> {
  late bool obscureText;
  @override
  void initState() {
    obscureText = widget.fieldType == CustomFormTextFieldType.password;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.lableText,
          style: GoogleFonts.roboto(
            fontSize: 21.sp,
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 75.h,
          width: widget.width.w,
          child: TextField(
            controller: widget.controller,
            style: GoogleFonts.roboto(
              fontSize: 18.sp,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w600,
            ),
            keyboardType: widget.fieldType == CustomFormTextFieldType.phone
                ? TextInputType.phone
                : widget.fieldType == CustomFormTextFieldType.email
                    ? TextInputType.emailAddress
                    : TextInputType.text,
            maxLines:
                widget.fieldType == CustomFormTextFieldType.address ? 5 : 1,
            readOnly: widget.fieldType == CustomFormTextFieldType.datePicker ||
                widget.fieldType == CustomFormTextFieldType.gender,
            onTap: widget.fieldType == CustomFormTextFieldType.datePicker
                ? _showDatePicker
                : widget.fieldType == CustomFormTextFieldType.gender
                    ? selectGender
                    : null,
            cursorColor: Colors.blueGrey,
            obscureText: obscureText,
            decoration: InputDecoration(
              suffixIcon: widget.fieldType == CustomFormTextFieldType.password
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      child: Icon(
                        obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 25.sp,
                        color: Colors.blueGrey,
                      ),
                    )
                  : widget.fieldType == CustomFormTextFieldType.datePicker
                      ? GestureDetector(
                          onTap: _showDatePicker,
                          child: Icon(
                            Icons.calendar_today_outlined,
                            size: 25.sp,
                            color: Colors.blueGrey,
                          ),
                        )
                      : const SizedBox(),
              hintText: widget.hintText,
              hintStyle: GoogleFonts.roboto(
                fontSize: 18.sp,
                color: Colors.blueGrey[300],
                fontWeight: FontWeight.w600,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.sp,
                  color: Colors.blueGrey.shade700,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.sp,
                  color: Colors.blueGrey,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _showDatePicker() async {
    DateTime? dob = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );

    if (dob != null) {
      widget.controller.text = DateFormat('dd/MM/yyyy').format(dob);
    }
  }

  selectGender() {
    String selectedGender = widget.controller.text;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: 200.h),
      enableDrag: true,
      builder: (ctx) {
        return StatefulBuilder(builder: (cntx, setStat) {
          return Column(
            children: [
              GridView(
                shrinkWrap: true,
                padding: EdgeInsets.all(20.sp),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  mainAxisExtent: 50.h,
                  childAspectRatio: 1,
                ),
                children: widget.gendersList.map((e) {
                  return GestureDetector(
                    onTap: () {
                      selectedGender = e;
                      setStat(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5.sp),
                      decoration: BoxDecoration(
                        color: selectedGender == e
                            ? Colors.blueGrey
                            : Colors.white,
                        border: Border.all(width: 1.sp, color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        e,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: selectedGender == e
                              ? Colors.white
                              : Colors.blueGrey,
                        ),
                        textScaleFactor: 1.sp,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Spacer(),
              CustomFormButton(
                height: 40.h,
                width: 150.w,
                onTap: () {
                  widget.controller.text = selectedGender;
                  Navigator.pop(context);
                },
                title: 'Done',
                outlined: true,
              ),
              SizedBox(height: 5.h),
            ],
          );
        });
      },
    );
  }
}
