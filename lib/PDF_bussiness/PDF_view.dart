//@dart=2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class PDFViewer extends StatefulWidget {
  final File file;
  const PDFViewer({@required this.file});
  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  @override
  Widget build(BuildContext context) {
    final name = path.basename(widget.file.path);
    return PDFViewerScaffold(appBar: AppBar(title: Text(name)), path: widget.file.path);
  }
}
