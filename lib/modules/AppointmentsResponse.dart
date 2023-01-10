class AppointmentsResponse {
  AppointmentsResponse({
    required this.appointmentId,
    required this.time,
    required this.problem,
    required this.status,
    required this.uid,
  });

  int appointmentId;
  DateTime time;
  String problem;
  String status;
  String uid;
}
