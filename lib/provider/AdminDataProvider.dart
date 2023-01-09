import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:flutter/cupertino.dart';

class UserDataProvider extends ChangeNotifier {
  UserData? userData;

  UserData get getUserData =>
      userData ??
      UserData(
        uid: '',
        email: '',
        name: '',
        dateOfBirth: '',
        gender: '',
        address: '',
        profilePicture: '',
        phone: '',
        description: '',
        userRole: UserRole.patient,
      );

  setUserData(UserData newData) {
    userData = newData;
    notifyListeners();
  }
}
