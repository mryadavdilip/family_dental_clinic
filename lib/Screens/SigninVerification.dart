import 'package:family_dental_clinic/CustomWidgets/CustomFormHeader.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomFormButton.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomFormTextField.dart';

class SigninVerification extends StatefulWidget {
  final ValueChanged<String> result;
  const SigninVerification({Key? key, required this.result}) : super(key: key);

  @override
  State<SigninVerification> createState() => _SigninVerificationState();
}

class _SigninVerificationState extends State<SigninVerification> {
  final TextEditingController _passwordEditingController =
      TextEditingController();

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
              const CustomFormHeader(
                  title: 'Enter password to continue delete'),
              SizedBox(height: 40.h),
              CustomFormTextField(
                controller: _passwordEditingController,
                fieldType: CustomFormTextFieldType.password,
                lableText: 'Password',
                hintText: 'Password',
              ),
              SizedBox(height: 40.h),
              CustomFormButton(
                onTap: () {
                  Utils(context).confirmationDialog(
                    title: messages.deleteAccountConfirmation,
                    onConfirm: () {
                      widget.result(_passwordEditingController.text);
                      Navigator.pop(context);
                    },
                  );
                },
                title: 'Confirm',
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
