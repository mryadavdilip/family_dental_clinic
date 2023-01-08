import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_dental_clinic/Authentication/auth_controller.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomIconButton.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomLableText.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:family_dental_clinic/modules/AppointmentsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AdminAppointments extends StatefulWidget {
  const AdminAppointments({Key? key}) : super(key: key);

  @override
  State<AdminAppointments> createState() => _AdminAppointmentsState();
}

class _AdminAppointmentsState extends State<AdminAppointments> {
  List<AppointmentsResponse> appointmentsResponseList = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Row(
                children: [
                  SizedBox(width: 20.w),
                  CustomIconButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const CustomLableText(text: 'Appointments'),
                ],
              ),
              SizedBox(height: 30.h),
              appointmentsResponseList.isEmpty
                  ? const Center(
                      child:
                          Text('There are currently no appointments available'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: appointmentsResponseList.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.w, vertical: 10.h),
                          child: Container(
                            width: 350.w,
                            decoration: BoxDecoration(
                              color:
                                  Color(index.isEven ? 0xFFC7ECF0 : 0xFFE6EEFF),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15.h),
                                Center(
                                  child: Text(
                                    appointmentsResponseList[index].status,
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 25.w),
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
                                          text: DateFormat('dd-MM-yyyy').format(
                                              appointmentsResponseList[index]
                                                  .time),
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 25.w),
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
                                          text: DateFormat('hh:mm a').format(
                                              appointmentsResponseList[index]
                                                  .time),
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
                                SizedBox(height: 10.h),
                                Visibility(
                                  visible:
                                      appointmentsResponseList[index].status ==
                                          AppointmentStatus.confirm.name,
                                  child: InkWell(
                                    onTap: () {
                                      Utils(context).confirmationDialog(
                                        onConfirm: () {
                                          String docId = '';
                                          FirebaseFirestore.instance
                                              .collection(pathName.appointments)
                                              .get()
                                              .then((ss) {
                                            if (ss.docs.isNotEmpty) {
                                              for (QueryDocumentSnapshot doc
                                                  in ss.docs) {
                                                if (doc.get(
                                                        fieldAndKeyName.id) ==
                                                    appointmentsResponseList[
                                                            index]
                                                        .appointmentId) {
                                                  docId = doc.id;
                                                }
                                              }
                                            }
                                          }).then((value) {
                                            FirebaseFirestore.instance
                                                .collection(
                                                    pathName.appointments)
                                                .doc(docId)
                                                .update({
                                              fieldAndKeyName.status:
                                                  AppointmentStatus
                                                      .cancelledByDoctor.name,
                                            }).then((value) {
                                              _loadData();
                                            });
                                          });
                                        },
                                        title: messages
                                            .cancelAppointmentConfirmation,
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
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _loadData() async {
    appointmentsResponseList.clear();
    await FirebaseFirestore.instance
        .collection(pathName.appointments)
        .orderBy(fieldAndKeyName.id, descending: true)
        .get()
        .then((appointmentsSnapshot) {
      if (appointmentsSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in appointmentsSnapshot.docs) {
          appointmentsResponseList.add(AppointmentsResponse(
            appointmentId: doc.get(fieldAndKeyName.id),
            time: DateTime.parse(doc.get(fieldAndKeyName.time)),
            status: doc.get(fieldAndKeyName.status),
          ));
        }
      }
    }).then((value) {
      setState(() {});
    });
  }
}
