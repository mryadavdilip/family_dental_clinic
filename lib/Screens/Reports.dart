import 'dart:io';

import 'package:family_dental_clinic/Authentication/auth_controller.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomLableText.dart';
import 'package:family_dental_clinic/Screens/PDFPage.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:family_dental_clinic/modules/ReportsResponse.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.w, vertical: 10.h),
                          child: FutureBuilder<Uint8List?>(
                              future: FirebaseStorage.instance
                                  .refFromURL(e.url)
                                  .getData(),
                              builder: (context, snapshot) {
                                return !snapshot.hasData
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Container(
                                        padding: EdgeInsets.all(20.sp),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 3.r,
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 3.r,
                                              offset: Offset(3.w, 3.h),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            detailField(
                                              onTap: () {},
                                              title: 'User Id: ',
                                              subtitle: e.uid,
                                            ),
                                            detailField(
                                              onTap: () {},
                                              title: 'Appointment Id: ',
                                              subtitle:
                                                  e.appointmentId.toString(),
                                            ),
                                            detailField(
                                              onTap: () {},
                                              title: 'Report Id: ',
                                              subtitle: e.reportId.toString(),
                                            ),
                                            detailField(
                                              onTap: () async {
                                                getApplicationDocumentsDirectory();
                                                File file = File(
                                                    '/storage/emulated/0/Download/Family Dental Clinic - Report (${DateTime.now().millisecondsSinceEpoch}).pdf');
                                                if (file.existsSync()) {
                                                  await file.delete();
                                                }
                                                await file
                                                    .writeAsBytes(
                                                        snapshot.data!)
                                                    .then((_) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          messages.reportSaved);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (ctx) =>
                                                              PDFPage(
                                                                sfPdfViewer:
                                                                    SfPdfViewer
                                                                        .memory(
                                                                  snapshot
                                                                      .data!,
                                                                  canShowScrollStatus:
                                                                      true,
                                                                  canShowPasswordDialog:
                                                                      true,
                                                                  canShowPaginationDialog:
                                                                      true,
                                                                  canShowHyperlinkDialog:
                                                                      true,
                                                                  canShowScrollHead:
                                                                      true,
                                                                  enableTextSelection:
                                                                      true,
                                                                  enableDocumentLinkAnnotation:
                                                                      true,
                                                                  enableDoubleTapZooming:
                                                                      true,
                                                                  enableHyperlinkNavigation:
                                                                      true,
                                                                ),
                                                              )));
                                                });
                                              },
                                              title: 'Url: ',
                                              subtitle: e.url,
                                            ),
                                          ],
                                        ),
                                      );
                              }),
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

  RichText detailField({
    required String title,
    required String subtitle,
    GestureTapCallback? onTap,
  }) {
    return RichText(
      text: TextSpan(
        text: title,
        style: GoogleFonts.actor(
          fontSize: 18,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                onTap!();
              },
            text: subtitle,
            style: GoogleFonts.adventPro(
              fontSize: 13,
              decoration: TextDecoration.underline,
            ),
          )
        ],
      ),
      textScaleFactor: 1.sp,
    );
  }
}
