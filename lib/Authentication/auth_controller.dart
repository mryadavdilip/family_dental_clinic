import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_dental_clinic/Screens/SigninVerification.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:family_dental_clinic/provider/AdminDataProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:family_dental_clinic/navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AuthController {
  final BuildContext context;
  AuthController(this.context);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Reference storageRef = FirebaseStorage.instance.ref();

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
            _firestore.collection(pathNames.users).doc(email).update({
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
        _firestore.collection(pathNames.users).doc(credential.user!.email).set({
          fieldAndKeyName.uid: credential.user!.uid,
          fieldAndKeyName.email: credential.user!.email,
          fieldAndKeyName.name: name,
          fieldAndKeyName.phone: phone,
          fieldAndKeyName.dateOfBirth: dateOfBirth,
          fieldAndKeyName.gender: gender,
          fieldAndKeyName.address: address,
          fieldAndKeyName.profilePicture: Constants().getDefaultProfilePicture,
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
    _firestore.collection(pathNames.users).doc(currentUser!.email).update({
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
      codeSent: (vid, code) {
        log('vid: $vid, code: $code');
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
          _firestore.collection(pathNames.users).doc(email).update({
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
                .child('${pathNames.userProfilePictures}/${currentUser!.email}')
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
                    .collection(pathNames.users)
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

  deleteAccount() {
    String email = currentUser!.email!;
    String profilePictureUrl =
        Provider.of<UserDataProvider>(context, listen: false)
            .getUserData
            .profilePicture;
    _auth.signOut().then((value) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => SigninVerification(
                  result: (password) async {
                    await _auth
                        .signInWithEmailAndPassword(
                            email: email, password: password)
                        .then(
                          (value) => value.user!.delete().then((_) async {
                            await FireStoreUtils()
                                .appointmentsByUser(value.user!.uid)
                                .then((ss) async {
                              if (ss.docs.isNotEmpty) {
                                for (var doc in ss.docs) {
                                  await _firestore
                                      .collection(pathNames.appointments)
                                      .doc(doc.id)
                                      .delete()
                                      .then((_) async {
                                    await _firestore
                                        .collection(pathNames.users)
                                        .doc(value.user!.email)
                                        .delete();
                                  });
                                }
                              }
                            }).then((_) async {
                              if (profilePictureUrl !=
                                  Constants().getDefaultProfilePicture) {
                                await FirebaseStorage.instance
                                    .refFromURL(profilePictureUrl)
                                    .delete()
                                    .then((value) {
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              const Navigation()));
                                  Fluttertoast.showToast(
                                      msg: messages.accountDeleteSuccessful);
                                });
                              }
                            });
                          }),
                        );
                  },
                ))));
  }
}
