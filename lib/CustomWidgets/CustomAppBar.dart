import 'package:family_dental_clinic/CustomWidgets/CustomCopyableText.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomProfilePicture.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:family_dental_clinic/provider/UserDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget {
  final GestureTapCallback onMenuTap;
  const CustomAppBar({super.key, required this.onMenuTap});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isProfileBarExpanded = false;
  UserData? userData;

  @override
  Widget build(BuildContext context) {
    userData = Provider.of<UserDataProvider>(context, listen: true).getUserData;

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(5.sp),
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(width: 1.sp, color: Colors.blue),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 2.r,
                blurStyle: BlurStyle.inner,
                offset: Offset(2.w, 2.h),
                color: Colors.black.withOpacity(0.3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomProfilePicture(url: userData!.profilePicture),
              Text(
                userData!.name,
                style: GoogleFonts.sahitya(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                textScaleFactor: 1.sp,
              ),
              Visibility(
                visible: isProfileBarExpanded,
                child: Column(
                  children: [
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 130.w),
                          child: CustomCopyableText(
                            onTap: () async {
                              Utils(context)
                                  .viewAddressOnMap(userData!.address);
                            },
                            title: 'Address:',
                            text: userData!.address,
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 100.w),
                          child: CustomCopyableText(
                            onTap: () async {
                              Utils(context).openDialPad(userData!.phone);
                            },
                            title: 'Contact:',
                            text: userData!.phone,
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 130.w),
                          child: CustomCopyableText(
                            onTap: () async {
                              Utils(context).sendEmail(userData!.email);
                            },
                            title: 'Email:',
                            text: userData!.email,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isProfileBarExpanded = !isProfileBarExpanded;
                  });
                },
                behavior: HitTestBehavior.translucent,
                child: SizedBox(
                  height: 20.h,
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Icon(
                      isProfileBarExpanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      size: 30.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10.h,
          right: 10.w,
          child: GestureDetector(
            onTap: widget.onMenuTap,
            behavior: HitTestBehavior.translucent,
            child: SizedBox(
              height: 30.h,
              width: 30.w,
              child: Icon(
                Icons.menu,
                color: Colors.white,
                size: 30.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
