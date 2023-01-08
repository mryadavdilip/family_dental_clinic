class AppointmentsResponse {
  AppointmentsResponse({
    required this.appointmentId,
    required this.time,
    required this.status,
  });

  String appointmentId;
  DateTime time;
  String status;
}
