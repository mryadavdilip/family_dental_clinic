import 'package:family_dental_clinic/widgets/appointments_card.dart';
import 'package:family_dental_clinic/widgets/custom_icon_button.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:family_dental_clinic/modules/appointments_response.dart';
import 'package:family_dental_clinic/provider/appointments_response_provider.dart';
import 'package:family_dental_clinic/widgets/custom_lable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AppointmentsHistory extends StatefulWidget {
  final bool isAdmin;
  const AppointmentsHistory({
    Key? key,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  State<AppointmentsHistory> createState() => _AppointmentsHistoryState();
}

class _AppointmentsHistoryState extends State<AppointmentsHistory> {
  List<AppointmentsResponse> responseList = [];

  @override
  void initState() {
    _loadAppointmentsHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    responseList =
        Provider.of<AppointmentsResponseProvider>(context, listen: true)
            .getHistoryResponseList;
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
                  const CustomLableText(text: 'Appointments History'),
                ],
              ),
              SizedBox(height: 30.h),
              responseList.isEmpty
                  ? const Center(
                      child:
                          Text('There are currently no appointments available'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: responseList.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return AppointmentsCard(
                          isAdmin: widget.isAdmin,
                          index: index,
                          response: responseList[index],
                          refresh: _loadAppointmentsHistory,
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future _loadAppointmentsHistory() async {
    Provider.of<AppointmentsResponseProvider>(context, listen: false)
        .updateHistoryResponseList(
            await FireStoreUtils().getAppointmentsResponse(
      context,
      AppointmentStatus.confirm,
      isAdmin: widget.isAdmin,
      exclude: true,
    ));
  }
}
