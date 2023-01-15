import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFPage extends StatelessWidget {
  final String path;
  const PDFPage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.asset(path),
    );
  }
}
