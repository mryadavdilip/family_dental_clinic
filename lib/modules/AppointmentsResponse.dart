class AppointmentsResponse {
  AppointmentsResponse({
    required this.appointmentId,
    required this.time,
    required this.status,
    required this.uid,
  });

  int appointmentId;
  DateTime time;
  String status;
  String uid;
}
