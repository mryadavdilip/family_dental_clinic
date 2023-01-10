import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:family_dental_clinic/modules/AppointmentsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AppointmentsCard extends StatefulWidget {
  final int index;
  final AppointmentsResponse response;
  final GestureTapCallback onCancel;
  const AppointmentsCard(
      {super.key,
      this.index = 0,
      required this.response,
      required this.onCancel});

  @override
  State<AppointmentsCard> createState() => _AppointmentsCardState();
}

class _AppointmentsCardState extends State<AppointmentsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: Color(widget.index.isEven ? 0xFFC7ECF0 : 0xFFE6EEFF),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.h),
            Center(
              child: Text(
                widget.response.status,
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                textScaleFactor: 1.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: RichText(
                text: TextSpan(
                  text: "Date: ",
                  style: GoogleFonts.raleway(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text:
                          DateFormat('dd-MM-yyyy').format(widget.response.time),
                      style: GoogleFonts.raleway(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                textScaleFactor: 1.sp,
              ),
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: RichText(
                text: TextSpan(
                  text: "Time: ",
                  style: GoogleFonts.raleway(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: DateFormat('hh:mm a').format(widget.response.time),
                      style: GoogleFonts.raleway(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                textScaleFactor: 1.sp,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: RichText(
                text: TextSpan(
                  text: "Problem: ",
                  style: GoogleFonts.raleway(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: widget.response.problem,
                      style: GoogleFonts.raleway(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                overflow: TextOverflow.fade,
                textScaleFactor: 1.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Visibility(
              visible: widget.response.status == AppointmentStatus.confirm.name,
              child: InkWell(
                onTap: () {
                  Utils(context).confirmationDialog(
                    onConfirm: () {
                      FirebaseFirestore.instance
                          .collection(pathNames.appointments)
                          .doc(PathName(context).getAppointmentPath(
                              widget.response.appointmentId))
                          .update({
                        fieldAndKeyName.status:
                            AppointmentStatus.cancelled.name,
                      }).then((value) {
                        widget.onCancel();
                      });
                    },
                    title: messages.cancelAppointmentConfirmation,
                  );
                },
                child: Container(
                  height: 38.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffEA0001),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.r),
                      bottomRight: Radius.circular(12.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Cancel Appointment",
                      textScaleFactor: 1.sp,
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
