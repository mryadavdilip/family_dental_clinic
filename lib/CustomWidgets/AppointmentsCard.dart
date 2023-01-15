import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomLableText.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomProfilePicture.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:family_dental_clinic/modules/AppointmentsResponse.dart';
import 'package:family_dental_clinic/provider/AppointmentsResponseProvider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentsCard extends StatefulWidget {
  final int index;
  final AppointmentsResponse? response;
  final GestureTapCallback refresh;
  final bool isAdmin;
  const AppointmentsCard({
    super.key,
    this.index = 0,
    this.response,
    required this.refresh,
    this.isAdmin = false,
  });

  @override
  State<AppointmentsCard> createState() => _AppointmentsCardState();
}

class _AppointmentsCardState extends State<AppointmentsCard> {
  @override
  Widget build(BuildContext context) {
    Provider.of<AppointmentsResponseProvider>(context, listen: true)
        .getConfirmResponseList;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
      child: Stack(
        children: [
          Container(
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
                    widget.response!.status,
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    textScaleFactor: 1.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                profileField('Date: ',
                    DateFormat('dd-MM-yyyy').format(widget.response!.time),
                    size: 13),
                SizedBox(height: 5.h),
                profileField('Time: ',
                    DateFormat('hh:mm a').format(widget.response!.time),
                    size: 13),
                SizedBox(height: 5.h),
                profileField('Problem: ', widget.response!.problem, size: 13),
                SizedBox(height: 10.h),
                Visibility(
                  visible:
                      widget.response!.status == AppointmentStatus.confirm.name,
                  child: InkWell(
                    onTap: () {
                      updateStatus(widget.response!.appointmentId,
                          AppointmentStatus.cancelled);
                    },
                    child: button('Cancel Appointment'),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: widget.isAdmin &&
                widget.response!.status == AppointmentStatus.confirm.name,
            child: Row(
              children: [
                IconButton(
                  iconSize: 30.sp,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    updateStatus(widget.response!.appointmentId,
                        AppointmentStatus.visited);
                  },
                  icon: Icon(
                    Icons.done,
                    size: 30.sp,
                  ),
                ),
                IconButton(
                  iconSize: 30.sp,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    uploadReportFile(
                      widget.response!.appointmentId,
                      widget.response!.uid,
                    );
                  },
                  icon: Icon(
                    Icons.upload_file_outlined,
                    size: 30.sp,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: widget.isAdmin,
            child: Positioned(
              right: 10.w,
              top: 10.w,
              child: GestureDetector(
                onTap: () async {
                  QueryDocumentSnapshot? userDoc;
                  List<QueryDocumentSnapshot> currentUserAppointmentsDocs = [];
                  await FirebaseFirestore.instance
                      .collection(pathNames.users)
                      .where(fieldAndKeyName.uid,
                          isEqualTo: widget.response!.uid)
                      .get()
                      .then((snapshot) {
                    userDoc = snapshot.docs.first;
                  }).then((_) async {
                    currentUserAppointmentsDocs = await FireStoreUtils()
                        .appointmentsByUser(widget.response!.uid)
                        .then((snapshot) {
                      return snapshot.docs;
                    });
                  });

                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return Padding(
                        padding: EdgeInsets.all(20.sp),
                        child: Stack(
                          children: [
                            Material(
                              borderRadius: BorderRadius.circular(10.r),
                              color: Colors.blue.shade100,
                              child: Column(
                                children: [
                                  SizedBox(height: 10.h),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.w),
                                      child: Text(
                                        'Appointment Id: ${widget.response!.appointmentId}',
                                        style: GoogleFonts.roboto(fontSize: 14),
                                        textScaleFactor: 1.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  CustomProfilePicture(
                                      url: userDoc!
                                          .get(fieldAndKeyName.profilePicture)),
                                  SizedBox(height: 50.h),
                                  const CustomLableText(text: 'Personal info'),
                                  SizedBox(height: 20.h),
                                  profileField(
                                    "Name: ",
                                    userDoc!
                                        .get(fieldAndKeyName.name)
                                        .toString()
                                        .toUpperCase(),
                                  ),
                                  SizedBox(height: 20.h),
                                  profileField(
                                    "Age: ",
                                    AgeCalculator.age(DateTime.parse(userDoc!
                                            .get(fieldAndKeyName.dateOfBirth)))
                                        .years
                                        .toString(),
                                  ),
                                  SizedBox(height: 20.h),
                                  profileField(
                                    "Gender: ",
                                    userDoc!.get(fieldAndKeyName.gender),
                                  ),
                                  SizedBox(height: 20.h),
                                  profileField(
                                    "phone: ",
                                    userDoc!.get(fieldAndKeyName.phone),
                                  ),
                                  SizedBox(height: 20.h),
                                  profileField(
                                    "Email: ",
                                    userDoc!
                                        .get(fieldAndKeyName.email)
                                        .toString()
                                        .toUpperCase(),
                                  ),
                                  SizedBox(height: 20.h),
                                  profileField(
                                    "Address: ",
                                    userDoc!.get(fieldAndKeyName.address),
                                  ),
                                  SizedBox(height: 10.h),
                                  const Divider(color: Colors.red),
                                  SizedBox(height: 10.h),
                                  const CustomLableText(
                                      text: 'Additional info'),
                                  SizedBox(height: 20.h),
                                  profileField(
                                    "Last login: ",
                                    userDoc!.get(fieldAndKeyName.lastLogin),
                                  ),
                                  SizedBox(height: 20.h),
                                  profileField(
                                    "User role: ",
                                    userDoc!
                                        .get(fieldAndKeyName.userRole)
                                        .toString()
                                        .toUpperCase(),
                                  ),
                                  SizedBox(height: 20.h),
                                  profileField(
                                    "Unique id: ",
                                    userDoc!.get(fieldAndKeyName.uid),
                                  ),
                                  SizedBox(height: 20.h),
                                  profileField(
                                    "Total appointments: ",
                                    currentUserAppointmentsDocs.length
                                        .toString(),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 10.w,
                              right: 10.w,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 30.sp,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                behavior: HitTestBehavior.translucent,
                child: Icon(
                  Icons.info_outline,
                  size: 30.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget profileField(String lable, String value, {double size = 18}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: RichText(
        text: TextSpan(
          text: lable,
          style: GoogleFonts.raleway(
            fontSize: size,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: value,
              style: GoogleFonts.raleway(
                fontSize: size,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
        overflow: TextOverflow.fade,
        textScaleFactor: 1.sp,
      ),
    );
  }

  Widget button(String title) {
    return Container(
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
          title,
          textScaleFactor: 1.sp,
          style: GoogleFonts.raleway(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  updateStatus(int appointmentId, AppointmentStatus status) {
    Utils(context).confirmationDialog(
      onConfirm: () async {
        FireStoreUtils()
            .getUserByUid(widget.response!.uid)
            .then((userDoc) async {
          await FirebaseFirestore.instance
              .collection(pathNames.appointments)
              .doc(PathName(context).getAppointmentPath(
                widget.response!.appointmentId,
                userDoc.get(fieldAndKeyName.email),
              ))
              .update({
            fieldAndKeyName.status: status.name,
          }).then((_) {
            widget.refresh();
          });
        });
      },
      title: messages.cancelAppointmentConfirmation,
    );
  }

  uploadReportFile(int appointmentId, String uid) async {
    FilePicker.platform
        .pickFiles(
            allowMultiple: false, dialogTitle: 'Please pick patient report')
        .then((result) async {
      PlatformFile file = result!.files.first;
      await FireStoreUtils().getUserByUid(uid).then((userDoc) async {
        Utils(context).confirmationDialog(
          onConfirm: () async {
            await FirebaseStorage.instance
                .ref(pathNames.reports)
                .child(userDoc.get(fieldAndKeyName.email))
                .child(file.name)
                .putData(file.bytes!)
                .then((taskSnapshot) {
              Utils(context).generateId(pathNames.reports).then(
                (reportId) async {
                  await taskSnapshot.ref.getDownloadURL().then((url) {
                    FirebaseFirestore.instance
                        .collection(pathNames.appointments)
                        .doc(PathName(context).getAppointmentPath(reportId))
                        .set({
                      fieldAndKeyName.appointmentId: appointmentId,
                      fieldAndKeyName.reportId: reportId,
                      fieldAndKeyName.uid: uid,
                      fieldAndKeyName.url: url,
                    });
                  });
                },
              );
            });
          },
          title: messages.uploadReportConfirmation,
        );
      });
    });
  }
}
