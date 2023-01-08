import 'package:family_dental_clinic/Authentication/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoutButton extends StatelessWidget {
  final BuildContext ctx;
  const LogoutButton({super.key, required this.ctx});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        AuthController(ctx).signout();
      },
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: Text(
        'Logout',
        style: GoogleFonts.raleway(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
        textScaleFactor: 1.sp,
      ),
    );
  }
}
