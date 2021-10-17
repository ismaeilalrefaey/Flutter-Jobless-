//@dart=2.9

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import '../models/location.dart';

class EmploymentDetails {
  File companyImage;
  DateTime from, to;
  UserLocation jobLocation;
  String id, userId, jobTitle;

  EmploymentDetails(
    this.id,
    this.to,
    this.from,
    this.userId,
    this.jobTitle,
    this.jobLocation,
    this.companyImage,
  );
}

class EmploymentDetailsProvider with ChangeNotifier {
  List<EmploymentDetails> _employmentDetails = [
    EmploymentDetails(
      '1',
      DateTime.now(),
      DateTime.now(),
      'userId',
      'CEO',
      UserLocation(
        double.parse(randomNumeric(2)),
        double.parse(randomNumeric(2)),
        'city',
        'country',
      ),
      null,
    ),
    EmploymentDetails(
      '2',
      DateTime.now(),
      DateTime.now(),
      'userId',
      'Technician',
      UserLocation(
        double.parse(randomNumeric(2)),
        double.parse(randomNumeric(2)),
        'city',
        'country',
      ),
      null,
    ),
    EmploymentDetails(
      '3',
      DateTime.now(),
      DateTime.now(),
      'userId',
      'Designer',
      UserLocation(
        double.parse(randomNumeric(2)),
        double.parse(randomNumeric(2)),
        'city',
        'country',
      ),
      null,
    ),
    EmploymentDetails(
      '4',
      DateTime.now(),
      DateTime.now(),
      'userId',
      'Teacher',
      UserLocation(
        double.parse(randomNumeric(2)),
        double.parse(randomNumeric(2)),
        'city',
        'country',
      ),
      null,
    ),
  ];

  List<EmploymentDetails> get items => _employmentDetails;


  //fetch employment details
}
