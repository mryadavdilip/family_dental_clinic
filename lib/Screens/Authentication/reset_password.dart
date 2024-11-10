import 'package:family_dental_clinic/widgets/custom_form_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:family_dental_clinic/authentication/auth_controller.dart';
import 'package:family_dental_clinic/widgets/custom_form_button.dart';
import 'package:family_dental_clinic/widgets/custom_form_text_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailEditingController = TextEditingController();

  @override
  void dispose() {
    _emailEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: 812.h,
          width: 375.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              const CustomFormHeader(title: 'Reset Password'),
              SizedBox(height: 40.h),
              CustomFormTextField(
                controller: _emailEditingController,
                lableText: 'Email',
                hintText: 'Email',
              ),
              SizedBox(height: 40.h),
              CustomFormButton(
                onTap: () {
                  AuthController(context)
                      .resetPassword(_emailEditingController.text);
                },
                title: 'Send Request',
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                behavior: HitTestBehavior.translucent,
                child: Text(
                  "No, thanks!",
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blueGrey,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
