import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_dental_clinic/Authentication/auth_controller.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomAppBar.dart';
import 'package:family_dental_clinic/CustomWidgets/CustomAppointmentsButton.dart';
import 'package:family_dental_clinic/Screens/Appointments/AppointmentsHistory.dart';
import 'package:family_dental_clinic/Screens/Appointments/BookAppointment.dart';
import 'package:family_dental_clinic/Screens/HomePage/ProfilePage.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/provider/AdminDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final bool isAdmin;
  const HomePage({Key? key, this.isAdmin = false}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List drawerItems = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserData? userData;

  final CarouselController _carouselController = CarouselController();
  int activeDentalServiceIndex = 0;

  @override
  void initState() {
    drawerItems = [
      {
        'title': 'Profile',
        'icon': Icons.person_outline,
        'action': () {
          scaffoldKey.currentState!.closeEndDrawer();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => const ProfilePage()),
          );
        },
      },
      {
        'title': widget.isAdmin ? 'Appointments' : 'Book Appointment',
        'icon': Icons.history_outlined,
        'action': () {
          scaffoldKey.currentState!.closeEndDrawer();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => widget.isAdmin
                    ? AppointmentsHistory(isAdmin: widget.isAdmin)
                    : const BookAppointmentPage()),
          );
        },
      },
      {
        'title': 'Reports',
        'icon': Icons.picture_as_pdf_outlined,
        'action': () {},
      },
      {
        'title': 'The Clinic',
        'icon': Icons.local_hospital_outlined,
        'action': () {},
      },
      {
        'title': 'FAQ',
        'icon': Icons.info_outline,
        'action': () {},
      },
      {
        'title': 'Logout',
        'icon': Icons.logout_outlined,
        'action': () {
          AuthController(context).signout();
        },
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userData = Provider.of<UserDataProvider>(context, listen: true).getUserData;
    return Scaffold(
      key: scaffoldKey,
      endDrawer: SafeArea(
        child: StatefulBuilder(builder: (ctx, setStat) {
          return Drawer(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(20.r),
              ),
            ),
            child: Column(
              children: [
                Column(
                  children: drawerItems.map((e) {
                    return ListTile(
                      onTap: () {
                        e['action']();
                        setStat(() {});
                      },
                      leading: Icon(
                        e['icon'],
                        size: 30.sp,
                        color: Colors.black,
                      ),
                      title: Text(
                        e['title'],
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textScaleFactor: 1.sp,
                      ),
                      minLeadingWidth: 50.w,
                    );
                  }).toList(),
                ),
                SizedBox(height: 50.h),
              ],
            ),
          );
        }),
      ),
      body: SafeArea(
        child: SizedBox(
          width: 375.w,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomAppBar(
                  onMenuTap: () {
                    scaffoldKey.currentState?.openEndDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.sp),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          border: Border.all(width: 1.sp, color: Colors.white),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2.r,
                              blurStyle: BlurStyle.inner,
                              offset: Offset(2.w, 2.h),
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 150.w),
                              child: Text(
                                'Experience advanced dentristry at Family Dental Clinic',
                                style: GoogleFonts.raleway(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                textScaleFactor: 1.sp,
                              ),
                            ),
                            Container(
                              height: 120.w,
                              width: 120.w,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://firebasestorage.googleapis.com/v0/b/family-dental-clinic-2c2cb.appspot.com/o/images%2Fdescriptionimg.jpg?alt=media&token=53cf9c40-11c0-4542-b2dd-76028d787772'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Featured Dental Services',
                        style: GoogleFonts.raleway(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                        textScaleFactor: 1.sp,
                      ),
                      SizedBox(height: 10.h),
                      FutureBuilder(
                        future: _firestore.collection(pathNames.services).get(),
                        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                          return !snapshot.hasData
                              ? const Center(child: CircularProgressIndicator())
                              : snapshot.hasData
                                  ? Column(
                                      children: [
                                        CarouselSlider.builder(
                                          carouselController:
                                              _carouselController,
                                          itemCount: snapshot.data?.size,
                                          itemBuilder: (ctx, _, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.blueGrey.shade100,
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(500.r),
                                                  topRight:
                                                      Radius.circular(500.r),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 240.w,
                                                    width: 240.w,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.blueGrey,
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          snapshot
                                                              .data?.docs[index]
                                                              .get(
                                                                  fieldAndKeyName
                                                                      .url),
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 250.w,
                                                    padding:
                                                        EdgeInsets.all(10.sp),
                                                    margin:
                                                        EdgeInsets.all(10.sp),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.r),
                                                      border: Border.all(
                                                        width: 3.sp,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          snapshot
                                                              .data?.docs[index]
                                                              .get(
                                                            fieldAndKeyName
                                                                .heading,
                                                          ),
                                                          style: GoogleFonts
                                                              .alegreyaSc(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          textScaleFactor: 1.sp,
                                                        ),
                                                        SizedBox(height: 5.h),
                                                        Text(
                                                          snapshot
                                                              .data?.docs[index]
                                                              .get(
                                                            fieldAndKeyName
                                                                .description,
                                                          ),
                                                          style: GoogleFonts
                                                              .anekGurmukhi(
                                                            fontSize: 16,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          textScaleFactor: 1.sp,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          options: CarouselOptions(
                                            height: 610.h,
                                            aspectRatio: 1,
                                            initialPage: 0,
                                            onPageChanged: (i, r) {
                                              activeDentalServiceIndex = i;
                                              setState(() {});
                                            },
                                            enableInfiniteScroll: false,
                                            autoPlay: true,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Builder(builder: (context) {
                                          var items = snapshot.data!.docs;
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: items.map((e) {
                                              return GestureDetector(
                                                onTap: () {
                                                  _carouselController
                                                      .animateToPage(
                                                    items.indexOf(e),
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    curve: Curves.bounceInOut,
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Visibility(
                                                      visible: items.indexOf(
                                                              items.first) !=
                                                          items.indexOf(e),
                                                      child: Container(
                                                        height: 5.w,
                                                        width: 5.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: activeDentalServiceIndex ==
                                                                  items.indexOf(
                                                                      e)
                                                              ? Colors.orange
                                                              : Colors.blue
                                                                  .shade100,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 20.w,
                                                      width: 20.w,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            activeDentalServiceIndex ==
                                                                    items
                                                                        .indexOf(
                                                                            e)
                                                                ? Colors.orange
                                                                : Colors.blue
                                                                    .shade100,
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: items.indexOf(
                                                              items.last) !=
                                                          items.indexOf(e),
                                                      child: Container(
                                                        height: 5.w,
                                                        width: 5.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: activeDentalServiceIndex ==
                                                                  items.indexOf(
                                                                      e)
                                                              ? Colors.orange
                                                              : Colors.blue
                                                                  .shade100,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        }),
                                      ],
                                    )
                                  : Center(
                                      child: Text(snapshot.error.toString()),
                                    );
                        },
                      ),
                      SizedBox(height: 30.h),
                      Visibility(
                        visible: !widget.isAdmin,
                        child: Center(
                          child: CustomButton(
                            onTap: () {
                              drawerItems.firstWhere((element) =>
                                  element['title'].toString().toLowerCase() ==
                                  'book appointment')['action']();
                            },
                            title: 'Book Appointment',
                            color: const Color(0xFF005292),
                          ),
                        ),
                      ),
                      SizedBox(height: 50.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
