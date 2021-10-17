// @dart=2.9

import 'dart:math';
import 'dart:convert';
import '../global_stuff.dart';
import '../providers/job.dart';

import '../providers/accounts.dart';
import 'package:random_string/random_string.dart';

Object userAccount(bool isFreelancer) {
  int length = 10;
  var jsonData = {
    'userId': randomNumeric(length),
    'token': randomAlphaNumeric(length),
    'object': {
      'previous_works': isFreelancer ? [] : null,
      // 'portfolio': isFreelancer ? randomAlpha(length) : null,
      'portfolio': null,
      'rate': isFreelancer ? Random().nextDouble() * 100 : null,
      'date_of_account_creation': DateTime.now().toIso8601String(),
      'basic_detail': {
        'id': randomAlpha(length),
        'email': randomAlpha(length),
        'gender': randomAlpha(length),
        'password': randomAlpha(length),
        'last_name': randomAlpha(length),
        'first_name': randomAlpha(length),
        'phone_number': randomAlpha(length),
        'birthday_date': DateTime.now().toIso8601String()
      },
      'educational_detail': {
        'graduate': true,
        'id': randomAlpha(length),
        'c_v': null, // randomAlpha(length),
        'skills': randomAlpha(length),
        'courses': randomAlpha(length),
        'education': randomAlpha(length),
        'specialization': randomAlpha(length),
        'languages_known': randomAlpha(length),
      },
      'additional_detail': {
        'accounts': null,
        'id': randomAlpha(length),
        'nationality': randomAlpha(length),
        'credit_card_number': randomAlpha(length),
        'image':
            null, //fileToString(stringToFile(randomListOfInts(1500), 'jpg')),
        'position': {
          'city': randomAlpha(length),
          'country': randomAlpha(length),
          'latitude': Random().nextDouble() * 180,
          'longitude': Random().nextDouble() * 360,
        },
      },
    }
  };
  var jsonResponse = json.encode(jsonData);
  return isFreelancer
      ? FreelancerAccount(jsonResponse)
      : UserAccount(jsonResponse);
}

CompanyAccount companyAccount() {
  int length = 7;
  var jsonData = {
    'object': {
      'accounts': null,
      'id': randomNumeric(length),
      'name': randomAlpha(length),
      'email': randomAlpha(length),
      'password': randomAlpha(length),
      'description': randomAlpha(length),
      'specialization': randomAlpha(length),
      'rate': double.parse(randomNumeric(length)),
      'date_of account_creation': DateTime.now().toIso8601String(),
      'image': fileToString(stringToFile(randomListOfInts(1500), 'jpg')),
      'location': {
        'city': randomAlpha(length),
        'country': randomAlpha(length),
        'latitude': Random().nextDouble() * 180,
        'longitude': Random().nextDouble() * 360,
      }
    }
  };
  var jsonResponse = json.encode(jsonData);
  return CompanyAccount(jsonResponse);
}

Job jobOffer() {
  int length = 7;
  return Job(
    jobCondition: JobCondition(
        id: randomNumeric(length),
        country: randomAlpha(length),
        gender: randomAlpha(length),
        nationality: randomAlpha(length),
        languages: randomAlpha(length),
        age: randomAlpha(length),
        skills: randomAlpha(length),
        educationLevel: randomAlpha(length),
        specialization: randomAlpha(length),
        yearsOfExperience: randomAlpha(length)),
    company: companyAccount().companyDetails,
    id: randomNumeric(length),
    title: randomAlpha(length),
    description: randomAlpha(length),
    salary: int.parse(randomNumeric(length)),
    shift: randomAlpha(length),
    durationOfJob: double.parse(randomNumeric(length)),
    dateOfPublication: DateTime.now(),
    numberOfVacancies: int.parse(randomNumeric(length)),
    image: stringToFile(randomListOfInts(500), 'jpg'),
  );
}

String randomListOfInts(int length) {
  String s = '[';
  for (int i = 0; i < length; i++) {
    s += randomNumeric(2) + ', ';
  }
  s = s.substring(0, s.length - 2);
  s += ']';
  return s;
}
