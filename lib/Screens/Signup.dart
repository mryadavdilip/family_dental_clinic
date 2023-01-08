import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomFormHeader.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:family_dental_clinic/Authentication/auth_controller.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomFormButton.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomFormTextField.dart';
import 'package:intl/intl.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _confPasswordEditingController =
      TextEditingController();
  final TextEditingController _firstNameEditingController =
      TextEditingController();
  final TextEditingController _lastNameEditingController =
      TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _dobEditingController = TextEditingController();
  final TextEditingController _genderEditingController =
      TextEditingController();
  final TextEditingController _addressEditingController =
      TextEditingController();

  Set<String> gendersList = {};
  String selectedGender = '';

  @override
  void initState() {
    _loadDropdowns();
    _phoneEditingController.text = '+91';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: 812.h,
          width: 375.w,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                const CustomFormHeader(title: 'Sign Up'),
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
                SizedBox(height: 30.h),
                CustomFormTextField(
                  controller: _confPasswordEditingController,
                  fieldType: CustomFormTextFieldType.password,
                  lableText: 'Confirm Password',
                  hintText: 'Confirm Password',
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 37.5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomFormTextField(
                        width: 140.w,
                        controller: _firstNameEditingController,
                        lableText: 'First Name',
                        hintText: 'First Name',
                      ),
                      CustomFormTextField(
                        width: 140.w,
                        controller: _lastNameEditingController,
                        lableText: 'Surname',
                        hintText: 'Surname',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                CustomFormTextField(
                  controller: _phoneEditingController,
                  lableText: 'Phone Number',
                  hintText: '+91',
                ),
                SizedBox(height: 30.h),
                CustomFormTextField(
                  controller: _dobEditingController,
                  fieldType: CustomFormTextFieldType.datePicker,
                  lableText: 'Date of birth',
                  hintText: 'dd/MM/yyyy',
                ),
                SizedBox(height: 30.h),
                gendersList.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomFormTextField(
                        controller: _genderEditingController,
                        fieldType: CustomFormTextFieldType.gender,
                        lableText: 'Gender',
                        hintText: gendersList.first,
                        gendersList: gendersList,
                      ),
                SizedBox(height: 30.h),
                CustomFormTextField(
                  controller: _addressEditingController,
                  fieldType: CustomFormTextFieldType.address,
                  lableText: 'Address',
                  hintText: 'House/Apartment, street, area/town, city, state',
                ),
                SizedBox(height: 40.h),
                CustomFormButton(
                  onTap: () {
                    AuthController(context).signupWithEmailAndPassword(
                      email: _emailEditingController.text,
                      password: _passwordEditingController.text,
                      confirmPassword: _confPasswordEditingController.text,
                      name:
                          '${_firstNameEditingController.text} ${_lastNameEditingController.text}',
                      phone: _phoneEditingController.text,
                      dateOfBirth: DateFormat('dd/MM/yyyy')
                          .parse(_dobEditingController.text)
                          .toIso8601String(),
                      gender: _genderEditingController.text,
                      gendersList: gendersList,
                      address: _addressEditingController.text,
                    );
                  },
                  title: 'Sign up',
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
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
                        Navigator.pop(context);
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Text(
                        "Login here",
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
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _loadDropdowns() {
    _firestore
        .collection(pathName.staticData)
        .doc(pathName.signupForm)
        .get()
        .then((data) {
      data.data()?[fieldAndKeyName.gendersList].forEach((e) {
        gendersList.add(e[fieldAndKeyName.description].toString());
        selectedGender = gendersList.first;
        setState(() {});
      });
    });
  }
}
