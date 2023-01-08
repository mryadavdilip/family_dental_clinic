import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_dental_clinic/Authentication/auth_controller.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/provider/AdminDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
        .collection(pathName.users)
        .doc(AuthController(context).currentUser?.email)
        .get()
        .then((doc) {
      Provider.of<UserDataProvider>(context, listen: false)
          .setUserData(UserData(
        id: doc.get(fieldAndKeyName.id),
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
}
