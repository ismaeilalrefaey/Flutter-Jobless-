//@dart=2.9

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global_stuff.dart';
import '../models/location.dart';
import '../models/http_exceptions.dart';

class EmploymentDetails {
  DateTime from, to;
  UserLocation jobLocation;
  String id, userId, jobTitle, jobDetails;

  EmploymentDetails({
    @required this.id,
    @required this.to,
    @required this.from,
    @required this.userId,
    @required this.jobTitle,
    @required this.jobDetails,
    @required this.jobLocation,
  });
}

class EmploymentDetailsProvider with ChangeNotifier {
  List<EmploymentDetails> _employmentDetails = [];

  List<EmploymentDetails> get items => [..._employmentDetails];

  //fetch employment details
  Future<void> fetchAndSetEmploymentDetails(String userId) async {
    final url = '$ipAddress/get/user_employment_details';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode({'id': int.parse(userId)}),
      );
      final List<EmploymentDetails> loadedData = [];
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      print(extractedData);
      extractedData.forEach((employmentDetails) {
        var from = employmentDetails['date_of_start'];
        var date = from.substring(0, 10);
        DateTime fromDate = DateTime(int.parse(date.substring(0, 4)),
            int.parse(date.substring(5, 7)), int.parse(date.substring(8)));

        var to = employmentDetails['date_of_end'];
        date = to.substring(0, 10);
        DateTime toDate = DateTime(int.parse(date.substring(0, 4)),
            int.parse(date.substring(5, 7)), int.parse(date.substring(8)));

        loadedData.add(
          EmploymentDetails(
            id: employmentDetails['id'].toString(),
            to: toDate,
            from: fromDate,
            userId: userId,
            jobTitle: employmentDetails['title'],
            jobDetails: employmentDetails['details'],
            jobLocation: UserLocation(
              0.0,
              0.0,
              employmentDetails['city'],
              employmentDetails['country'],
            ).getCityCoordinates(),
          ),
        );
      });
      _employmentDetails = loadedData.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> add(EmploymentDetails employmentDetails) async {
    try {
      final uri = '$ipAddress/add/user/employmentdetails';
      print('in Add');
      print(employmentDetails.to);
      print(employmentDetails.from);
      await http.post(
        Uri.parse(uri),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode({
          'title': employmentDetails.jobTitle,
          'details': employmentDetails.jobDetails,
          'city': employmentDetails.jobLocation.city,
          'user_id': int.parse(employmentDetails.userId),
          'country': employmentDetails.jobLocation.country,
          'date_of_end': employmentDetails.to.toIso8601String(),
          'date_of_start': employmentDetails.from.toIso8601String(),
        }),
      );
      print('Posted');
      _employmentDetails.add(employmentDetails);
      print('Added !!');
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void delete(String employmentDetailsId) async {
    try {
      String uri = '$ipAddress/delete/user/employmentdetails';
      var response = await http.post(Uri.parse(uri),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode(
              {'employment_detail_id': employmentDetailsId.toString()}));
      print(response.statusCode);
      if (response.statusCode == 200) {
        _employmentDetails
            .removeWhere((element) => element.id == employmentDetailsId);
        notifyListeners();
      } else {
        throw HttpExceptions('Could not delete');
      }
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }
}
