import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_dental_clinic/Authentication/auth_controller.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomFormButton.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/modules/AppointmentsResponse.dart';
import 'package:family_dental_clinic/provider/AdminDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  final BuildContext context;
  Utils(this.context);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<UserData> syncUserData() async {
    UserData userData = await _firestore
        .collection(pathNames.users)
        .doc(AuthController(context).currentUser?.email)
        .get()
        .then((doc) {
      Provider.of<UserDataProvider>(context, listen: false)
          .setUserData(UserData(
        uid: doc.get(fieldAndKeyName.uid),
        email: doc.get(fieldAndKeyName.email),
        name: doc.get(fieldAndKeyName.name),
        dateOfBirth: doc.get(fieldAndKeyName.dateOfBirth),
        gender: doc.get(fieldAndKeyName.gender),
        address: doc.get(fieldAndKeyName.address),
        profilePicture: doc.get(fieldAndKeyName.profilePicture),
        phone: doc.get(fieldAndKeyName.phone),
        description: doc.get(fieldAndKeyName.description),
        userRole: doc.get(fieldAndKeyName.userRole) == UserRole.admin.name
            ? UserRole.admin
            : UserRole.patient,
      ));
      return Provider.of<UserDataProvider>(context, listen: false).getUserData;
    }).catchError((e) {
      log('getUserDataError: $e');
    });

    return userData;
  }

  viewAddressOnMap(String address) async {
    await locationFromAddress(address).then((locations) {
      if (locations.isNotEmpty) {
        if (kDebugMode) {
          print(locations.first.latitude);
          print(locations.first.longitude);
        }

        launchUrl(Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=${locations.first.latitude},${locations.first.longitude}'));
      } else {
        Fluttertoast.showToast(msg: messages.addressNotFound);
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  openDialPad(String phone) async {
    Uri url = Uri.parse('tel://$phone');
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    } else {
      Fluttertoast.showToast(msg: Messages(url).cannotDial);
    }
  }

  sendEmail(String email) async {
    Uri url = Uri.parse('mailto:$email');
    launchUrl(url).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  confirmationDialog(
      {required String title, required Function onConfirm}) async {
    showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 350.h, horizontal: 30.w),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    textScaleFactor: 1.sp,
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomFormButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        width: 140.w,
                        title: 'Cancel',
                        outlined: true,
                      ),
                      CustomFormButton(
                        onTap: () {
                          onConfirm();
                          Navigator.pop(context);
                        },
                        width: 140.w,
                        title: 'Confirm',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  getOrdinal({required int number}) {
    if (number >= 11 && number <= 13) {
      return 'th';
    }

    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  Future<int> generateId(String path) async {
    int max = 0;

    await _firestore.collection(path).get().then((snapshot) {
      max = snapshot.size;
    }).catchError((e) {});

    if (kDebugMode) {
      print('max id in firestore: $max');
    }
    return max + 1;
  }

  String? getMonthName(int month) {
    Map<int, String> monthName = {
      1: 'January',
      2: 'February',
      3: 'March',
      4: 'April',
      5: 'May',
      6: 'June',
      7: 'July',
      8: 'August',
      9: 'September',
      10: 'October',
      11: 'November',
      12: 'December',
    };
    return monthName[month];
  }

  int? getDaysInMonth(int month, int year) {
    Map<int, int> daysInMonth = {
      1: 31,
      2: year % 4 == 0 ? 29 : 28,
      3: 31,
      4: 30,
      5: 31,
      6: 30,
      7: 31,
      8: 31,
      9: 30,
      10: 31,
      11: 30,
      12: 31,
    };
    return daysInMonth[month];
  }
}

class FireStoreUtils {
  Future<QuerySnapshot> appointmentsByUser(String uid) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(pathNames.appointments)
        .where(fieldAndKeyName.uid, isEqualTo: uid)
        .get();
    return snapshot;
  }

  Future<QuerySnapshot> getAllUsersAppointments(
      [AppointmentStatus? status, bool exclude = false]) async {
    QuerySnapshot? snapshot;
    if (status == null) {
      await FirebaseFirestore.instance
          .collection(pathNames.appointments)
          .get()
          .then((ss) {
        snapshot = ss;
      });
    } else {
      if (exclude) {
        await FirebaseFirestore.instance
            .collection(pathNames.appointments)
            .where(fieldAndKeyName.status, isNotEqualTo: status)
            .get()
            .then((ss) {
          snapshot = ss;
        });
      } else {
        await FirebaseFirestore.instance
            .collection(pathNames.appointments)
            .where(fieldAndKeyName.status, isEqualTo: status)
            .get()
            .then((ss) {
          snapshot = ss;
        });
      }
    }
    return snapshot!;
  }

  Future<QuerySnapshot> appointmentsByUserAndStatus(
      String uid, AppointmentStatus status,
      [bool exclude = false]) async {
    QuerySnapshot? snapshot;
    if (exclude) {
      await FirebaseFirestore.instance
          .collection(pathNames.appointments)
          .where(fieldAndKeyName.uid, isEqualTo: uid)
          .where(fieldAndKeyName.status, isNotEqualTo: status.name)
          .get()
          .then((ss) {
        snapshot = ss;
      });
    } else {
      await FirebaseFirestore.instance
          .collection(pathNames.appointments)
          .where(fieldAndKeyName.uid, isEqualTo: uid)
          .where(fieldAndKeyName.status, isEqualTo: status.name)
          .get()
          .then((ss) {
        snapshot = ss;
      });
    }
    return snapshot!;
  }

  Future<List<AppointmentsResponse>> getAppointmentsResponse(
      BuildContext context, AppointmentStatus status,
      {bool isAdmin = false, bool exclude = false}) async {
    List<AppointmentsResponse> appointmentsResponseList = [];
    appointmentsResponseList.clear();
    QuerySnapshot? appointmentsSnapshot;
    if (isAdmin) {
      appointmentsSnapshot =
          await FireStoreUtils().getAllUsersAppointments(status, exclude);
    } else {
      appointmentsSnapshot = await FireStoreUtils().appointmentsByUserAndStatus(
          AuthController(context).currentUser!.uid, status, exclude);
    }

    if (appointmentsSnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in appointmentsSnapshot.docs) {
        appointmentsResponseList.add(AppointmentsResponse(
          appointmentId: doc.get(fieldAndKeyName.appointmentId),
          time: DateTime.parse(doc.get(fieldAndKeyName.time)),
          status: doc.get(fieldAndKeyName.status),
          uid: doc.get(fieldAndKeyName.uid),
          problem: doc.get(fieldAndKeyName.problem),
        ));
      }
    }

    appointmentsResponseList.sort((a, b) {
      return a.appointmentId.compareTo(b.appointmentId);
    });

    return appointmentsResponseList.reversed.toList();
  }

  updateAppointmentsStatusToExpire() async {
    List docsList = [];
    await FirebaseFirestore.instance
        .collection(pathNames.appointments)
        .where(fieldAndKeyName.status, isEqualTo: AppointmentStatus.confirm)
        .get()
        .then((snapshot) {
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        DateTime time = DateTime.parse(doc.get(fieldAndKeyName.time));
        if (time.isBefore(DateTime.now())) {
          docsList.add(doc);
        }
      }
    }).then((_) async {
      for (QueryDocumentSnapshot doc in docsList) {
        await FirebaseFirestore.instance
            .collection(pathNames.appointments)
            .doc(doc.id)
            .update({fieldAndKeyName.status: AppointmentStatus.expired});
      }
    });
  }
}
