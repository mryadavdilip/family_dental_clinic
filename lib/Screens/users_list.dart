import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:family_dental_clinic/widgets/custom_lable_text.dart';
import 'package:family_dental_clinic/widgets/custom_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class UsersList extends StatelessWidget {
  final bool isAdmin;
  const UsersList({
    super.key,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              const CustomLableText(text: 'Users'),
              SizedBox(height: 20.h),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(pathNames.users)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!.docs.map((e) {
                        return ListTile(
                          onTap: () {
                            Utils(context).showUserInfo(userDoc: e);
                          },
                          leading: CustomProfilePicture(
                            url: e.get(fieldAndKeyName.profilePicture),
                            size: 50,
                          ),
                          title: Text(
                            e.get(fieldAndKeyName.name),
                            style: GoogleFonts.aclonica(fontSize: 18),
                            textScaler: TextScaler.linear(1.sp),
                          ),
                          subtitle: Text(
                            e.get(fieldAndKeyName.userRole),
                            textScaler: TextScaler.linear(1.sp),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return const Center(
                      child: SingleChildScrollView(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
