import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:family_dental_clinic/navigation.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  final BuildContext context;
  AuthController(this.context);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  loginWithEmaiAndPassword(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: messages.allFieldsRequired);
    } else {
      try {
        _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((credential) {
          if (credential.user != null) {
            _firestore.collection(pathName.users).doc(email).update({
              fieldAndKeyName.lastLogin:
                  "${credential.user?.metadata.lastSignInTime?.toIso8601String()}"
            });
          }
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Navigation(),
              ),
              (route) => false);
        }).onError((error, stackTrace) {
          Fluttertoast.showToast(msg: error.toString());
          if (kDebugMode) {
            print(error);
          }
        });
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
        if (kDebugMode) {
          print(e);
        }
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  signupWithEmailAndPassword({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required Set<String> gendersList,
    required String address,
  }) async {
    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        name.isEmpty ||
        dateOfBirth.isEmpty ||
        (gender.isEmpty || gender == gendersList.first) ||
        address.isEmpty) {
      Fluttertoast.showToast(msg: messages.allFieldsRequired);
    } else if (password != confirmPassword) {
      Fluttertoast.showToast(msg: messages.passwordDoesNotMatch);
    } else {
      _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((credential) async {
        _firestore.collection(pathName.users).doc(credential.user!.email).set({
          fieldAndKeyName.id: await Utils(context).generateId(pathName.users),
          fieldAndKeyName.email: credential.user!.email,
          fieldAndKeyName.name: name,
          fieldAndKeyName.phone: phone,
          fieldAndKeyName.dateOfBirth: dateOfBirth,
          fieldAndKeyName.gender: gender,
          fieldAndKeyName.address: address,
          fieldAndKeyName.profilePicture:
              'https://firebasestorage.googleapis.com/v0/b/family-dental-clinic-2c2cb.appspot.com/o/userProfilePictures%2Fadmin%40fdc.com?alt=media&token=cdc62642-7907-42f0-bd07-1e131e53a8a8',
          fieldAndKeyName.userRole: UserRole.patient.name,
          fieldAndKeyName.description: '',
        }).then((value) async {
          await currentUser?.updateDisplayName(name);
          await currentUser?.updateEmail(email);
        });
      }).then((value) {
        Fluttertoast.showToast(msg: messages.accountCreatedSuccessfully);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => const Navigation()),
            (r) => false);
      }).onError((error, stackTrace) {
        Fluttertoast.showToast(msg: error.toString());
        if (kDebugMode) {
          print(error);
        }
      });
    }
  }

  updateProfile({
    required String name,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required Set<String> gendersList,
    required String address,
  }) async {
    _firestore.collection(pathName.users).doc(currentUser!.email).update({
      fieldAndKeyName.name: name,
      fieldAndKeyName.phone: phone,
      fieldAndKeyName.dateOfBirth: dateOfBirth,
      fieldAndKeyName.gender: gender,
      fieldAndKeyName.address: address,
      fieldAndKeyName.userRole: UserRole.patient.name,
      fieldAndKeyName.description: '',
    }).then((value) async {
      await currentUser?.updateDisplayName(name);
    }).then((value) {
      Fluttertoast.showToast(msg: messages.profileUpdatedSuccessfully);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => const Navigation()),
          (r) => false);
    });
  }

  Future<PhoneAuthCredential> verifyPhone(String phone) async {
    PhoneAuthCredential? credential;
    await _auth
        .verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (phoneAuthCredential) async {
        credential = phoneAuthCredential;
      },
      verificationFailed: (e) {
        Fluttertoast.showToast(msg: e.toString());
      },
      codeSent: (id, code) {
        log('id: $id, code: $code');
      },
      codeAutoRetrievalTimeout: (s) {
        Fluttertoast.showToast(msg: s);
      },
    )
        .then((value) {
      currentUser!.updatePhoneNumber(credential!).then((_) {
        Fluttertoast.showToast(msg: messages.phoneUpdated);
      });
    });
    return credential!;
  }

  signInWithGoogle() async {
    await GoogleSignIn().signIn().then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Navigation()));
      Fluttertoast.showToast(msg: messages.signedInSuccessfully);
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
      if (kDebugMode) {
        print(e);
      }
    });
  }

  resetPassword(String email) {
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: messages.allFieldsRequired);
    } else {
      try {
        _auth.sendPasswordResetEmail(email: email).then((credential) {
          _firestore.collection(pathName.users).doc(email).update({
            fieldAndKeyName.lastResetRequest: DateTime.now().toIso8601String()
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Navigation(),
              ),
              (route) => false);
          Fluttertoast.showToast(msg: messages.resetRequestSentToYourEmail);
        }).onError((error, stackTrace) {
          Fluttertoast.showToast(msg: error.toString());
        });
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  signout() {
    _auth.signOut().then(
      (v) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Navigation(),
            ),
            (route) => false);
        Fluttertoast.showToast(msg: messages.loggedOutSuccessfully);
      },
    ).onError(
      (error, stackTrace) {
        Fluttertoast.showToast(msg: error.toString());
      },
    );
  }

  Future<bool> isSignedIn() async {
    bool signedInWithGoogle = await GoogleSignIn().isSignedIn();
    bool signedInWithEmailAndPassword = currentUser != null;
    return signedInWithGoogle || signedInWithEmailAndPassword;
  }

  void setProfilePicture() {
    final Reference storageRef = FirebaseStorage.instance.ref();

    ImagePicker()
        .pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    )
        .then((image) {
      if (image != null) {
        Utils(context).confirmationDialog(
          title: messages.profilePictureConfirmation,
          onConfirm: () async {
            storageRef
                .child('${pathName.userProfilePictures}/${currentUser!.email}')
                .putData(await image.readAsBytes())
                .then((snapshot) {
              snapshot.ref.getDownloadURL().then((url) {
                currentUser?.updatePhotoURL(url).then((v) {
                  Fluttertoast.showToast(
                      msg: messages.profilePictureUpdatedSuccessfully);
                }).catchError((e) {
                  Fluttertoast.showToast(msg: e.toString());
                });
                _firestore
                    .collection(pathName.users)
                    .doc(currentUser!.email)
                    .update({
                  fieldAndKeyName.profilePicture: url,
                });
              }).then((value) {
                Utils(context).syncUserData();
              });
            });
          },
        );
      }
    });
  }
}
