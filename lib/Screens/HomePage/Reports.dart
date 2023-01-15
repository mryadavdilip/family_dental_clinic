import 'package:family_dental_clinic/Authentication/auth_controller.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomLableText.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:family_dental_clinic/modules/ReportsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';

class Reports extends StatefulWidget {
  final bool isAdmin;
  const Reports({
    super.key,
    this.isAdmin = false,
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
                : ListBody(
                    children: reports.map((e) {
                      return ListTile(
                        onTap: () {
                          OpenFile.open(e.file.path);
                        },
                        leading: Icon(Icons.picture_as_pdf, size: 30.sp),
                        title: Text(
                          e.file.path.split('/').last,
                          style: GoogleFonts.roboto(
                            fontSize: 21,
                          ),
                          textScaleFactor: 1.sp,
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  loadReports() async {
    await FireStoreUtils().getReports(
        widget.isAdmin ? null : AuthController(context).currentUser!.uid);
  }
}
