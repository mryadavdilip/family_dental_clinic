import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:family_dental_clinic/provider/user_data_provider.dart';
import 'package:family_dental_clinic/widgets/custom_form_button.dart';
import 'package:family_dental_clinic/widgets/custom_form_header.dart';
import 'package:family_dental_clinic/widgets/custom_form_text_field.dart';
import 'package:family_dental_clinic/widgets/custom_profile_picture.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:family_dental_clinic/authentication/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserData? userData;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    userData =
        Provider.of<UserDataProvider>(context, listen: false).getUserData;
    _loadDropdowns();

    _firstNameEditingController.text = userData!.name.split(' ').first;
    _lastNameEditingController.text = userData!.name.split(' ').last;
    _phoneEditingController.text = userData!.phone;
    _dobEditingController.text =
        DateFormat('dd/MM/yyyy').format(DateTime.parse(userData!.dateOfBirth));
    _genderEditingController.text = userData!.gender;
    _addressEditingController.text = userData!.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userData = Provider.of<UserDataProvider>(context, listen: true).getUserData;
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
                const CustomFormHeader(title: 'Edit Profile'),
                SizedBox(height: 40.h),
                GestureDetector(
                  onTap: () {
                    AuthController(context).setProfilePicture();
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomProfilePicture(url: userData!.profilePicture),
                      Icon(
                        Icons.photo_camera_outlined,
                        size: 30.sp,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 37.5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomFormTextField(
                        fieldType: CustomFormTextFieldType.name,
                        width: 140.w,
                        controller: _firstNameEditingController,
                        lableText: 'First Name',
                        hintText: 'First Name',
                      ),
                      CustomFormTextField(
                        fieldType: CustomFormTextFieldType.name,
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
                  fieldType: CustomFormTextFieldType.phone,
                  controller: _phoneEditingController,
                  lableText: 'Phone Number',
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
                    Utils(context).confirmationDialog(
                        title: messages.editProfileConfirmation,
                        onConfirm: () async {
                          AuthController(context).updateProfile(
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
                        });
                  },
                  title: 'Submit',
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: RichText(
                    text: TextSpan(
                      text: "To delete your account and data with FDC, ",
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blueGrey,
                      ),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              AuthController(context).deleteAccount();
                            },
                          text: "Click here",
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                    textScaler: TextScaler.linear(1.sp),
                  ),
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
        .collection(pathNames.staticData)
        .doc(pathNames.signupForm)
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