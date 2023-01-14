import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:family_dental_clinic/modules/AppointmentsResponse.dart';
import 'package:flutter/cupertino.dart';

class AppointmentsResponseProvider extends ChangeNotifier {
  List<AppointmentsResponse> confirmList = [];
  List<AppointmentsResponse> historyList = [];

  List<AppointmentsResponse> get getConfirmResponseList => confirmList;
  List<AppointmentsResponse> get getHistoryResponseList => historyList;

  updateConfirmResponseList(List<AppointmentsResponse> newResponseList) {
    confirmList = newResponseList;
    notifyListeners();
  }

  updateHistoryResponseList(List<AppointmentsResponse> newResponseList) {
    historyList = newResponseList;
    notifyListeners();
  }
}
