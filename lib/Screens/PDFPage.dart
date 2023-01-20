import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFPage extends StatelessWidget {
  final SfPdfViewer sfPdfViewer;
  const PDFPage({
    super.key,
    required this.sfPdfViewer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sfPdfViewer,
    );
  }
}
