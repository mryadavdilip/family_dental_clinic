import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_dental_clinic/Authentication/auth_controller.dart';
import 'package:family_dental_clinic/CustomWidgets/AppointmentsCard.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomIconButton.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomLableText.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:family_dental_clinic/modules/AppointmentsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentsHistory extends StatefulWidget {
  final bool isAdmin;
  const AppointmentsHistory({Key? key, this.isAdmin = false}) : super(key: key);

  @override
  State<AppointmentsHistory> createState() => _AppointmentsHistoryState();
}

class _AppointmentsHistoryState extends State<AppointmentsHistory> {
  List<AppointmentsResponse> appointmentsResponseList = [];

  @override
  void initState() {
    _loadAppointments();
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
                        return AppointmentsCard(
                          isInfoVisible: widget.isAdmin,
                          index: index,
                          response: appointmentsResponseList[index],
                          onCancel: _loadAppointments,
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _loadAppointments() async {
    appointmentsResponseList.clear();
    QuerySnapshot? appointmentsSnapshot;
    if (widget.isAdmin) {
      appointmentsSnapshot = await FireStoreUtils().getAllUsersAppointments();
    } else {
      appointmentsSnapshot = await FireStoreUtils()
          .appointmentsByUser(AuthController(context).currentUser!.uid);
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
      setState(() {});
    }
  }
}
