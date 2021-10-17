//@dart=2.9

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';

import '../global_stuff.dart';

class PDFApi {
  static const routeName = 'PdfApi';
  static Future<File> pickFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result == null) return null;


    // final fileName = path.basename(File(result.paths.first).path);
    // File f = File(result.paths.first);
    // var bytes = await f.readAsBytes();
    // var ints = bytes.toList();
    // print(ints);
    // String s = ints.toString();
    // print(s);
    // final url = '$ipAddress/hat/sora';
    // var response = await http.post(Uri.parse(url),
    //     headers: <String, String>{'Content-Type': 'application/json'},
    //     body: json.encode({'string': s}));
    // var responseBody = json.decode(response.body);
    // print(responseBody);
    // var toBytes = Uint8List.fromList(ints);

    // File t = File('/data/user/0/com.example.mril/cache/$fileName.pdf');
    // t.writeAsBytes(toBytes);
    // return t;

    return File(result.paths.first);
  }
}
