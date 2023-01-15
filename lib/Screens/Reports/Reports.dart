import 'package:family_dental_clinic/Authentication/auth_controller.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomLableText.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:family_dental_clinic/modules/ReportsResponse.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Reports extends StatefulWidget {
  final bool isAdmin;
  const Reports({
    super.key,
    required this.isAdmin,
  });

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  List<ReportsResponse> reports = [];

  @override
  void initState() {
    loadReports();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              CustomLableText(
                  text: widget.isAdmin ? 'All reports' : 'Your reports'),
              SizedBox(height: 30.h),
              reports.isEmpty
                  ? const Center(
                      child: Text('There are currently no reports available'),
                    )
                  : Column(
                      children: reports.map((e) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'appointmentId: ${e.appointmentId}',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.dotted,
                                ),
                                textScaleFactor: 1.sp,
                              ),
                              SizedBox(height: 2.h),
                              Image.network(
                                e.url,
                                height: 350.h,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  loadReports() async {
    reports = await FireStoreUtils()
        .getReports(
            widget.isAdmin ? null : AuthController(context).currentUser!.uid)
        .catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    });
    setState(() {});
  }
}
