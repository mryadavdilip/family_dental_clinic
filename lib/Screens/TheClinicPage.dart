import 'package:family_dental_clinic/Screens/PDFPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TheClinicPage extends StatelessWidget {
  const TheClinicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => const PDFPage(
                            path: 'assets/documents/clinic/about us.pdf',
                          )),
                );
              },
              title: Text(
                'About us',
                style: GoogleFonts.roboto(fontSize: 21),
                textScaleFactor: 1.sp,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => const PDFPage(
                            path:
                                'assets/documents/clinic/practice location.pdf',
                          )),
                );
              },
              title: Text(
                'Practice location',
                style: GoogleFonts.roboto(fontSize: 21),
                textScaleFactor: 1.sp,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => const PDFPage(
                            path: 'assets/documents/clinic/sterilisation.pdf',
                          )),
                );
              },
              title: Text(
                'Sterilisation',
                style: GoogleFonts.roboto(fontSize: 21),
                textScaleFactor: 1.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
