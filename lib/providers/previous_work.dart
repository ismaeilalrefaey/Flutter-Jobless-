//@dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global_stuff.dart';

class PreviousWork {
  String id, link, freelancerId;
  PreviousWork({
    @required this.id,
    @required this.link,
    @required this.freelancerId,
  });
}

class PreviousWorkProvider with ChangeNotifier {
  List<PreviousWork> _previousWork = [];

  List<PreviousWork> get items => [..._previousWork];

  Future<void> fetchAndSetPreviousWork(String userId) async {
    final url = '$ipAddress/get/freelancer_previous_works';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode({'id': int.parse(userId)}),
      );
      final List<PreviousWork> loadedData = [];
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      print(extractedData);
      extractedData.forEach((previousWork) {
        loadedData.add(PreviousWork(
          id: previousWork['id'].toString(),
          link: previousWork['link'],
          freelancerId: previousWork['freelancer_id'].toString(),
        ));
      });
      _previousWork = loadedData.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> add(PreviousWork previousWork) async {
    try {
      final uri = '$ipAddress/add/freelancer/previouswork';
      var response = await http.post(
        Uri.parse(uri),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode({
          'link': previousWork.link,
          'freelancer_id': int.parse(previousWork.freelancerId),
        }),
      );
      if (response.statusCode == 200) {
        _previousWork.add(previousWork);
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void delete(String previousWorkId, String freelnacerId) async {
    try {
      final uri = '$ipAddress/delete/freelancer/previouswork';
      var response = await http.post(Uri.parse(uri),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'previous_works_id': int.parse(previousWorkId),
            'freelancer_id': int.parse(freelnacerId)
          }));
      if (response.statusCode == 200) {
        _previousWork.removeWhere((element) => element.id == previousWorkId);
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
