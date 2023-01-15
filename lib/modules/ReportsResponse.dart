import 'dart:io';

class ReportsResponse {
  final File file;
  final String uid;
  final String reportId;
  final String appointmentId;
  ReportsResponse(
    this.file,
    this.reportId,
    this.uid,
    this.appointmentId,
  );
}
