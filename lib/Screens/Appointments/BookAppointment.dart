import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_dental_clinic/Authentication/auth_controller.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomAppointmentsButton.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomChip.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomIconButton.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomLableText.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomTextField.dart';
import 'package:family_dental_clinic/CustomWidgets/DatePickerChip.dart';
import 'package:family_dental_clinic/Screens/Appointments/AppointmentsHistory.dart';
import 'package:family_dental_clinic/modules/SlotTimeResponse.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({Key? key}) : super(key: key);

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _monthEditingController = TextEditingController();

  DateTime dateTime = DateTime.now();
  int? selectedDate;

  ItemScrollController dayScrollController = ItemScrollController();

  List<SlotTime> slotTimesList = [];
  SlotTime? selectedSlot;

  final TextEditingController _symptomsEditingController =
      TextEditingController();

  @override
  void initState() {
    _monthEditingController.text =
        '${Utils(context).getMonthName(dateTime.month)} ${dateTime.year}';
    selectedDate = dateTime.day;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dayScrollController.scrollTo(
          index: (selectedDate ?? 1) - 1,
          duration: const Duration(milliseconds: 300));
    });

    loadSlots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Row(
                children: [
                  SizedBox(width: 20.w),
                  CustomIconButton(onTap: () {
                    Navigator.pop(context);
                  }),
                  const CustomLableText(text: 'Book Appointment'),
                ],
              ),
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomTextField(
                  controller: _monthEditingController,
                  onTap: () async {
                    await showDatePicker(
                      context: context,
                      keyboardType: TextInputType.text,
                      initialDate: dateTime,
                      firstDate: DateTime(1901),
                      lastDate:
                          DateTime(DateTime.now().year + 2, 0, 0, 0, 0, 0, 0),
                    ).then(
                      (date) {
                        if (date != null) {
                          dateTime = date;
                          _monthEditingController.text =
                              '${Utils(context).getMonthName(dateTime.month)} ${dateTime.year}';
                        }

                        selectedDate = dateTime.day;
                        setState(() {});
                      },
                    );
                  },
                  lableText: 'Select Month',
                  fontColor: Colors.black,
                  isDatePicker: true,
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Select Day',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                height: 80,
                child: ScrollablePositionedList.builder(
                  shrinkWrap: true,
                  itemCount: Utils(context)
                          .getDaysInMonth(dateTime.month, dateTime.year) ??
                      0,
                  scrollDirection: Axis.horizontal,
                  itemScrollController: dayScrollController,
                  padding: EdgeInsets.only(left: 20.w),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: DatePickerChip(
                        onTap: () {
                          selectedDate = index + 1;
                          dateTime = DateTime(
                              dateTime.year, dateTime.month, selectedDate!);
                          setState(() {});
                          loadSlots();
                        },
                        date:
                            '${index + 1}${Utils(context).getOrdinal(number: index + 1)}',
                        day: DateFormat('EEEE')
                            .format(DateTime(
                                dateTime.year, dateTime.month, index + 1))
                            .toString(),
                        state:
                            DateTime(dateTime.year, dateTime.month, index + 1)
                                        .difference(DateTime.now())
                                        .inDays <
                                    0
                                ? DatePickerChipState.disabled
                                : selectedDate == index + 1
                                    ? DatePickerChipState.selected
                                    : DatePickerChipState.active,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 30.h),
              const CustomLableText(text: 'Available Time'),
              SizedBox(height: 20.h),
              slotTimesList.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        'No slot available, please select another date.',
                        style: GoogleFonts.roboto(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFED1C24),
                        ),
                        textScaleFactor: 1.sp,
                      ),
                    )
                  : SizedBox(
                      height: 140.h,
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: slotTimesList.length,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: 20.w, right: 10.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10.w,
                          crossAxisSpacing: 10.h,
                          childAspectRatio: 0.4,
                        ),
                        itemBuilder: (context, index) {
                          return CustomChip(
                            onTap: () {
                              selectedSlot = slotTimesList[index];

                              dateTime = DateTime(
                                dateTime.year,
                                dateTime.month,
                                dateTime.day,
                                selectedSlot == null
                                    ? dateTime.hour
                                    : selectedSlot!.startTime.hour,
                                selectedSlot == null
                                    ? dateTime.minute
                                    : selectedSlot!.startTime.minute,
                                selectedSlot == null
                                    ? dateTime.second
                                    : selectedSlot!.startTime.second,
                              );

                              if (kDebugMode) {
                                print(
                                    'dateTime: ${dateTime.toIso8601String()}');
                              }
                              setState(() {});
                            },
                            title: slotTimesList[index].startTimeDescription,
                            color: selectedSlot == slotTimesList[index]
                                ? CustomChipColor.blue
                                : CustomChipColor.white,
                          );
                        },
                      ),
                    ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: CustomTextField(
                  controller: _symptomsEditingController,
                  lableText: 'What Problem(s) are you experiencing',
                  hintText: 'Write in your problem',
                  maxLines: 10,
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: CustomButton(
                  onTap: () async {
                    Utils(context)
                        .generateId(pathNames.appointments)
                        .then((appointmentId) {
                      _firestore
                          .collection(pathNames.appointments)
                          .doc(PathName(context)
                              .getAppointmentPath(appointmentId))
                          .set({
                        fieldAndKeyName.appointmentId: appointmentId,
                        fieldAndKeyName.uid:
                            AuthController(context).currentUser!.uid,
                        fieldAndKeyName.time: dateTime.toIso8601String(),
                        fieldAndKeyName.problem:
                            _symptomsEditingController.text,
                        fieldAndKeyName.status: AppointmentStatus.confirm.name,
                      }).then((value) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return Scaffold(
                              backgroundColor: Colors.transparent,
                              body: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 550.h,
                                    width: 335.w,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 40.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 30.h),
                                        Icon(
                                          Icons.check_circle_outline,
                                          size: 100.sp,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(height: 12.h),
                                        Text(
                                          'Thank You !',
                                          style: GoogleFonts.rubik(
                                            fontSize: 38,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF333333),
                                          ),
                                          textScaleFactor: 1.sp,
                                        ),
                                        SizedBox(height: 30.h),
                                        SizedBox(
                                          height: 50.h,
                                          child: Text(
                                            'Appointment scheduled at:\n${dateTime.day} ${Utils(context).getMonthName(dateTime.month)} ${dateTime.year}, ${DateFormat('hh:mm a').format(dateTime)}',
                                            style: GoogleFonts.rubik(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF677294),
                                            ),
                                            textAlign: TextAlign.center,
                                            textScaleFactor: 1.sp,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            loadSlots();
                                            Navigator.pop(context);
                                          },
                                          behavior: HitTestBehavior.translucent,
                                          child: Container(
                                            height: 54.h,
                                            width: 295.w,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF084B7F),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: Text(
                                              'Done',
                                              style: GoogleFonts.rubik(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                              textScaleFactor: 1.sp,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        GestureDetector(
                                          onTap: () {
                                            //
                                          },
                                          behavior: HitTestBehavior.translucent,
                                          child: SizedBox(
                                            height: 54.h,
                                            width: 260.w,
                                            child: Center(
                                              child: Text(
                                                'Edit your appointment',
                                                style: GoogleFonts.rubik(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      const Color(0xFF677294),
                                                ),
                                                textScaleFactor: 1.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      });
                    });
                  },
                  title: 'Submit',
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: CustomButton(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => const AppointmentsHistory()));
                  },
                  title: 'Appointments',
                  color: const Color(0xFF005292),
                ),
              ),
              SizedBox(height: 25.h),
            ],
          ),
        ),
      ),
    );
  }

  loadSlots() async {
    slotTimesList.clear();
    QuerySnapshot appointmentsSnapshot =
        await _firestore.collection(pathNames.appointments).get();

    DateTime startTime =
        DateTime(dateTime.year, dateTime.month, dateTime.day, 10, 0, 0);
    DateTime endTime =
        DateTime(dateTime.year, dateTime.month, dateTime.day, 19, 0, 0);
    DateTime breakStartTime =
        DateTime(dateTime.year, dateTime.month, dateTime.day, 14, 30, 0);
    DateTime breakEndTime =
        DateTime(dateTime.year, dateTime.month, dateTime.day, 16, 0, 0);
    Duration step = const Duration(minutes: 15);

    while (startTime.isBefore(endTime)) {
      DateTime timeIncrement = startTime.add(step);
      bool isBooked = false;

      if (appointmentsSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in appointmentsSnapshot.docs) {
          if (DateTime.parse(doc.get(fieldAndKeyName.time))
              .isAtSameMomentAs(timeIncrement)) {
            isBooked = true;
          }
        }
      }

      if (!(timeIncrement.isAfter(breakStartTime) &&
          timeIncrement.isBefore(breakEndTime))) {
        if (!isBooked) {
          slotTimesList.add(SlotTime(
            startTime: timeIncrement,
            startTimeDescription: DateFormat('hh:mm a').format(timeIncrement),
          ));
        }
      }
      startTime = timeIncrement;
    }

    if (slotTimesList.isNotEmpty) {
      selectedSlot = slotTimesList.first;
      dateTime = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        selectedSlot!.startTime.hour,
        selectedSlot!.startTime.minute,
        selectedSlot!.startTime.second,
      );
      if (kDebugMode) {
        print('dateTime: ${dateTime.toIso8601String()}');
        print('slotTimesList: $slotTimesList');
      }
    }

    setState(() {});
  }
}
