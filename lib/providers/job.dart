//@dart=2.9
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../providers/details.dart';

class Job with ChangeNotifier {
  final JobCondition jobCondition;
  final CompanyDetails company;
  final String id;
  final String title;
  final String description;
  final int salary;
  final String shift;
  final double durationOfJob;
  final DateTime dateOfPublication;
  final int numberOfVacancies;
  final File image;
  bool favorite = false;

  Job(
      {@required this.jobCondition,
      @required this.company,
      @required this.id,
      @required this.title,
      @required this.description,
      @required this.salary,
      @required this.shift,
      @required this.durationOfJob,
      @required this.dateOfPublication,
      @required this.numberOfVacancies,
      @required this.image,
      this.favorite});
}

class JobCondition with ChangeNotifier {
  final String id;
  final String country;
  final String gender;
  final String nationality;
  final String languages;
  final String age;
  final String skills;
  final String educationLevel;
  final String specialization;
  final String yearsOfExperience;

  JobCondition({
    @required this.id,
    @required this.country,
    @required this.gender,
    @required this.nationality,
    @required this.languages,
    @required this.age,
    @required this.skills,
    @required this.educationLevel,
    @required this.specialization,
    @required this.yearsOfExperience,
  });
}
