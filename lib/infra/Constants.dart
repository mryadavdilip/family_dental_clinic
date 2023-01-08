import 'package:family_dental_clinic/Authentication/auth_controller.dart';
import 'package:flutter/cupertino.dart';

class PathName {
  final BuildContext? context;
  PathName([this.context]);
  final String staticData = 'static_data';
  final String signupForm = 'signup_form';
  final String clinicDetails = 'clinic_details';
  final String users = 'users';
  final String services = 'Services';
  final String userProfilePictures = 'userProfilePictures';
  final String appointments = 'appointments';
  String getAppointmentPath(String id) {
    return '${AuthController(context!).currentUser!.email!}$id';
  }
}

final PathName pathName = PathName();

class FieldAndKeyName {
  final String id = 'id';
  final String gendersList = 'gendersList';
  final String address = 'address';
  final String description = 'description';
  final String heading = 'heading';
  final String url = 'url';
  final String name = 'name';
  final String phone = 'phone';
  final String email = 'email';
  final String dateOfBirth = 'dateOfBirth';
  final String gender = 'gender';
  final String lastLogin = 'lastLogin';
  final String lastResetRequest = 'lastResetRequest';
  final String profilePicture = 'profilePicture';
  final String userRole = 'userRole';
  final String time = 'time';
  final String status = 'status';
}

final FieldAndKeyName fieldAndKeyName = FieldAndKeyName();

class Messages {
  final Uri? url;
  Messages([this.url]);

  final String somethingWentWrong = 'Something went wrong';
  final String dataNotFound = 'Data not found';
  final String addressNotFound = 'Address not found';
  final String copiedToClipboard = 'Copied to clipboard';
  final String allFieldsRequired = 'All fields required';
  final String passwordDoesNotMatch =
      'Password and confirm password does not match';
  final String invalidPhone = 'Invalid phone';
  final String accountCreatedSuccessfully = 'Account created successfully';
  final String profileUpdatedSuccessfully = 'Profile updated successfully';
  final String signedInSuccessfully = 'Signed in successfully';
  final String resetRequestSentToYourEmail = 'Reset request sent to your email';
  final String loggedOutSuccessfully = 'Logged out successfully';
  final String profilePictureUpdatedSuccessfully =
      'Profile picture updated successfully';
  final String phoneUpdated = 'Phone Updated';

  String get cannotLaunchUrl => 'Cannot launch: $url';
  String get cannotDial => 'Cannot dial: ${url!.path}';
  String get cannotSendEmail => 'Cannot send email to: $url';
  String get profilePictureConfirmation =>
      'Are you sure, you want to upload profile picture?';
  String get editProfileConfirmation =>
      'Are you sure, you want to update profile?';
  String get cancelAppointmentConfirmation =>
      'Are you sure, you want to cancel appointment?';
}

final Messages messages = Messages();

enum UserRole {
  admin,
  patient,
}

class UserData {
  final String id;
  final String name;
  final String address;
  final String description;
  final String email;
  final String profilePicture;
  final String phone;
  final String dateOfBirth;
  final String gender;
  final UserRole userRole;
  UserData({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.email,
    required this.profilePicture,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.userRole,
  });
}

enum AppointmentStatus {
  confirm,
  cancelled,
  cancelledByDoctor,
  visited,
  expired,
}
