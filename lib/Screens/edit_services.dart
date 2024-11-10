import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_dental_clinic/widgets/custom_appointments_button.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:family_dental_clinic/widgets/custom_form_text_field.dart';
import 'package:family_dental_clinic/widgets/custom_lable_text.dart';
import 'package:family_dental_clinic/widgets/custom_profile_picture.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditServices extends StatefulWidget {
  const EditServices({super.key});

  @override
  State<EditServices> createState() => _EditServicesState();
}

class _EditServicesState extends State<EditServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          XFile? image =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          final TextEditingController headingController =
              TextEditingController();
          final TextEditingController descriptionController =
              TextEditingController();
          if (image != null) {
            showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return Column(
                    children: [
                      SizedBox(height: 10.h),
                      FutureBuilder<Uint8List>(
                        future: image.readAsBytes(),
                        builder: (_, ss) {
                          return ss.hasData
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10000.r),
                                  child: SizedBox(
                                    height: 100.w,
                                    width: 100.w,
                                    child: Image.memory(
                                      ss.data!,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: CircularProgressIndicator());
                        },
                      ),
                      SizedBox(height: 10.h),
                      CustomFormTextField(
                        controller: headingController,
                        lableText: 'Heading',
                      ),
                      CustomFormTextField(
                        controller: descriptionController,
                        lableText: 'Description',
                        fieldType: CustomFormTextFieldType.address,
                      ),
                      SizedBox(height: 30.h),
                      SizedBox(
                        width: 300.w,
                        child: CustomButton(
                          onTap: () async {
                            FirebaseStorage.instance
                                .ref(pathNames.services)
                                .child(
                                    '${headingController.text}/${image.name}')
                                .putData(await image.readAsBytes())
                                .then((taskSnapshot) async {
                              await taskSnapshot.ref
                                  .getDownloadURL()
                                  .then((url) {
                                Utils(context)
                                    .generateId(pathNames.services)
                                    .then((serviceId) {
                                  FirebaseFirestore.instance
                                      .collection(pathNames.services)
                                      .doc()
                                      .set({
                                    fieldAndKeyName.url: url,
                                    fieldAndKeyName.serviceId: serviceId,
                                    fieldAndKeyName.heading:
                                        headingController.text,
                                    fieldAndKeyName.description:
                                        descriptionController.text,
                                  }).then((_) {
                                    Navigator.pop(context);
                                    Fluttertoast.showToast(
                                        msg: messages.serviceAddedSuccessfully);
                                  });
                                });
                              });
                            });
                          },
                          title: 'Add',
                        ),
                      ),
                    ],
                  );
                });
          }
        },
        backgroundColor: Colors.blue,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Icon(Icons.add, size: 30.sp),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              const CustomLableText(text: 'Edit Services'),
              SizedBox(height: 20.h),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(pathNames.services)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data!.docs.map((e) {
                          return ListTile(
                            onLongPress: () {
                              Utils(context).confirmationDialog(
                                title: messages.deleteServiceConfirmation,
                                onConfirm: () {
                                  FirebaseStorage.instance
                                      .refFromURL(e.get(fieldAndKeyName.url))
                                      .delete()
                                      .then((_) {
                                    FirebaseFirestore.instance
                                        .collection(pathNames.services)
                                        .doc(e.id)
                                        .delete()
                                        .then((_) {
                                      Fluttertoast.showToast(
                                          msg: messages
                                              .serviceDeletedSuccessfully);
                                    });
                                  });
                                },
                              );
                            },
                            onTap: () {
                              final TextEditingController headingController =
                                  TextEditingController(
                                      text: e.get(fieldAndKeyName.heading));
                              final TextEditingController
                                  descriptionController = TextEditingController(
                                      text: e.get(fieldAndKeyName.description));
                              showModalBottomSheet(
                                  context: context,
                                  builder: (ctx) {
                                    return Column(
                                      children: [
                                        SizedBox(height: 10.h),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            CustomProfilePicture(
                                              url: e.get(fieldAndKeyName.url),
                                              size: 120,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                ImagePicker()
                                                    .pickImage(
                                                        source:
                                                            ImageSource.gallery)
                                                    .then((file) {
                                                  if (file != null) {
                                                    Utils(context)
                                                        .confirmationDialog(
                                                      title: messages
                                                          .imageUpdateConfirmation,
                                                      onConfirm: () async {
                                                        FirebaseStorage.instance
                                                            .ref(pathNames
                                                                .services)
                                                            .child(
                                                                '${e.get(fieldAndKeyName.heading)}/${file.name}')
                                                            .putData(await file
                                                                .readAsBytes())
                                                            .then(
                                                                (taskSnapshot) async {
                                                          await taskSnapshot.ref
                                                              .getDownloadURL()
                                                              .then((url) {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    pathNames
                                                                        .services)
                                                                .doc(e.id)
                                                                .set(
                                                                    {
                                                                  fieldAndKeyName
                                                                      .url: url
                                                                },
                                                                    SetOptions(
                                                                        merge:
                                                                            true));
                                                          });
                                                        });
                                                      },
                                                    );
                                                  }
                                                });
                                              },
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              child: Icon(
                                                Icons.file_upload_outlined,
                                                size: 30.sp,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 3.r,
                                                    offset: Offset(3.w, 3.h),
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        CustomFormTextField(
                                          controller: headingController,
                                          lableText: 'Heading',
                                        ),
                                        CustomFormTextField(
                                          controller: descriptionController,
                                          lableText: 'Description',
                                          fieldType:
                                              CustomFormTextFieldType.address,
                                        ),
                                        SizedBox(height: 30.h),
                                        SizedBox(
                                          width: 300.w,
                                          child: CustomButton(
                                            onTap: () {
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      pathNames.services)
                                                  .doc(e.id)
                                                  .set({
                                                fieldAndKeyName.heading:
                                                    headingController.text,
                                                fieldAndKeyName.description:
                                                    descriptionController.text,
                                              }, SetOptions(merge: true)).then(
                                                      (_) {
                                                Fluttertoast.showToast(
                                                    msg: messages
                                                        .serviceDetailsUpdated);
                                              });
                                            },
                                            title: 'Update',
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            leading: CustomProfilePicture(
                                size: 40, url: e.get(fieldAndKeyName.url)),
                            title: Text(
                              e.get(fieldAndKeyName.heading),
                              style: GoogleFonts.roboto(fontSize: 18),
                              textScaler: TextScaler.linear(1.sp),
                            ),
                            trailing: Icon(
                              Icons.edit_note,
                              size: 30.sp,
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
