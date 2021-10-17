//@dart=2.9
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:random_string/random_string.dart';

String ipAddress = 'http://192.168.43.176:3000';
// String ipAddress = 'http://192.168.43.82:3000';
// String ipAddress = 'http://10.0.2.2:3000';
//'$ipAddress'

String dateParser(DateTime date) {
  int m = date.month;
  String month = m < 10 ? '0$m' : m.toString();
  return '$month / ${date.year.toString()}';
}

String accurateDateParser(DateTime date) {
  int d = date.day, m = date.month, h = date.hour, mn = date.minute;
  String day = d < 10 ? '0$d' : d.toString(),
      minutes = mn < 10 ? '0$mn' : mn.toString(),
      month = m < 10 ? '0$m' : m.toString(),
      hours = h < 10 ? '0$h' : h.toString();
  return '$hours:$minutes - $day / $month / ${date.year.toString()}';
}

class Range {
  int from, to;
  Range(this.from, this.to);

  @override
  String toString() {
    return 'From ${this.from} to ${this.to}';
  }
}

List<int> parser(String list) {
  if (list == null) {
    return [];
  }
  list = list.substring(1, list.length - 1);
  List<String> temp = list.split(' ');
  String list2 = '';
  temp.forEach((element) {
    list2 += element;
  });
  return list2.split(',').map((e) => int.parse(e)).toList();
}

// Future<File> stringToFile(String s, String extension) async =>
//     await File('${getTemporaryDirectory()}/${randomAlpha(7)}.$extension')
//         .writeAsBytes(Uint8List.fromList(parser(s)));

File stringToFile(String s, String extension) {
  if (s == null || s.isEmpty) return null;
  // var ints = parser(s);
  // var bytes = Uint8List.fromList(ints);
  File f = File(
      '/data/user/0/com.example.mril/cache/MRIL_${randomAlpha(7)}.$extension');
  var list8 = base64.decode(s);
  f.writeAsBytesSync(list8.toList());
  return f;
}

String fileToString(File file) {
  if (file == null) return null;
  String _base64;
  _base64 = base64.encode((file.readAsBytesSync()));
  return _base64;
  // return file.readAsBytesSync().toList().toString();
}
