import 'package:family_dental_clinic/CustomWidgets/CustomFormHeader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:family_dental_clinic/Authentication/auth_controller.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomFormButton.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomFormTextField.dart';
import 'package:family_dental_clinic/Screens/ResetPassword.dart';
import 'package:family_dental_clinic/Screens/Signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
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
              const CustomFormHeader(title: 'Login'),
              SizedBox(height: 40.h),
              CustomFormTextField(
                controller: _emailEditingController,
                fieldType: CustomFormTextFieldType.email,
                lableText: 'Email',
                hintText: 'Email',
              ),
              SizedBox(height: 30.h),
              CustomFormTextField(
                controller: _passwordEditingController,
                fieldType: CustomFormTextFieldType.password,
                lableText: 'Password',
                hintText: 'Password',
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResetPasswordPage(),
                    ),
                  );
                },
                behavior: HitTestBehavior.translucent,
                child: Text(
                  'Forgot password?',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blueGrey,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              CustomFormButton(
                onTap: () {
                  AuthController(context).loginWithEmaiAndPassword(
                      _emailEditingController.text,
                      _passwordEditingController.text);
                },
                title: 'Login',
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blueGrey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                      );
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Text(
                      "Create one",
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 40.h),
              // CustomFormButton(
              //   onTap: () {
              //     AuthController(context).signInWithGoogle();
              //   },
              //   title: 'Sign in with Google',
              //   outlined: true,
              // ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
