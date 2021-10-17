//@dart=2.9

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global_stuff.dart';
import '../models/accounts.dart';
import '../models/location.dart';

class BasicDetails {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final DateTime birthday;
  final String email;
  final String password;
  final String phoneNumber;

  BasicDetails({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.gender,
    @required this.birthday,
    @required this.email,
    @required this.password,
    @required this.phoneNumber,
  });
}

class BasicDetailsProvider with ChangeNotifier {
  // BasicDetails basic;
  BasicDetails _basics;

  BasicDetails get item {
    return _basics;
  }

  Future<void> findByUserId(String id, String url) async {
    // final urlSend = '$ipAddress/get/user';
    try {
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({'id': int.parse(id)}));
      var responseData = json.decode(response.body);
      String date =
          (responseData['basic_detail']['birthday_date']).substring(0, 10);
      print(date);
      var birthday = DateTime(int.parse(date.substring(0, 4)),
          int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
      BasicDetails basicDetails = BasicDetails(
        id: responseData['basic_detail']['id'].toString(),
        firstName: responseData['basic_detail']['first_name'],
        lastName: responseData['basic_detail']['last_name'],
        gender: responseData['basic_detail']['gender'],
        birthday: birthday,
        email: responseData['basic_detail']['email'],
        password: '',
        phoneNumber: responseData['basic_detail']['phone_number'],
      );
      print('K');
      print(basicDetails.firstName);
      _basics = basicDetails;
      //return basicDetails;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void editBasicDetailsProvider(
      BasicDetails bd, String userID, String url) async {
    print(bd.firstName);
    print(bd.lastName);
    try {
      await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'id': int.parse(userID),
            'first_name': bd.firstName,
            'last_name': bd.lastName,
            'gender': bd.gender,
            'birthday_date': bd.birthday.toIso8601String(),
            'email': bd.email,
            'password': bd.password,
            'phone_number': bd.phoneNumber
          }));
      _basics = bd;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

class AdditionalDetails {
  final String id;
  final String nationality;
  final File image;
  final String creditCard;
  final UserLocation location;
  final Accounts accounts;

  AdditionalDetails({
    @required this.id,
    @required this.image,
    @required this.nationality,
    @required this.creditCard,
    @required this.location,
    @required this.accounts,
  });
}

class AdditionalDetailsProvider with ChangeNotifier {
  AdditionalDetails additionalDetailsProvider;

  AdditionalDetails get item {
    return additionalDetailsProvider;
  }

  Future<void> findByUserId(String id, String url) async {
    try {
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({'id': int.parse(id)}));
      var responseData = json.decode(response.body);
      AdditionalDetails additionalDetails = responseData['additional_detail'] == null
          ? null
          : AdditionalDetails(
              id: responseData['additional_detail']['id'].toString(),
              image: responseData['additional_detail']['image'] == null
                  ? null
                  : stringToFile(
                      responseData['additional_detail']['image'], 'jpg'),
              nationality: responseData['additional_detail']['nationality'],
              creditCard: responseData['additional_detail']
                  ['credit_card_number'],
              location: responseData['additional_detail']['position'] == null
                  ? null
                  : UserLocation(
                      responseData['additional_detail']['position']['latitude'] *
                          1.0,
                      responseData['additional_detail']['position']
                              ['longitude'] *
                          1.0,
                      responseData['additional_detail']['position']['city'],
                      responseData['additional_detail']['position']['country']),
              accounts: responseData['additional_detail']['account'] == null
                  ? null
                  : Accounts(
                      twitter: responseData['additional_detail']['account']
                          ['twitter'],
                      facebook: responseData['additional_detail']['account']
                          ['facebook'],
                      telegram: responseData['additional_detail']['account']
                          ['telegram'],
                      instagram: responseData['additional_detail']['account']
                          ['instagram'],
                      linkedin: responseData['additional_detail']['account']
                          ['linkedin'],
                      gmail: responseData['additional_detail']['account']['gmail']));
      print(responseData);
      additionalDetailsProvider = additionalDetails;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> editPortfolio(String portfolio) async {
    final url = '';
    await http.post(Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode({
          'portfolio': portfolio,
        }));
  }

  void editAdditionalDetails(
      AdditionalDetails ad, String userID, String url) async {
    try {
      await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'id': int.parse(userID),
            'image': ad.image == null ? null : fileToString(ad.image),
            'nationality': ad.nationality,
            'credit_card_number': ad.creditCard,
            'position': {
              'latitude': ad.location.latitude,
              'longitude': ad.location.longitude,
              'city': ad.location.city,
              'country': ad.location.country
            },
            'account': {
              'twitter': ad.accounts.twitter,
              'facebook': ad.accounts.facebook,
              'instagram': ad.accounts.instagram,
              'gmail': ad.accounts.gmail,
              'telegram': ad.accounts.telegram,
              'linkedin': ad.accounts.linkedin
            }
          }));
      additionalDetailsProvider = ad;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

class EducationalDetails {
  final String id;
  final String educationLevels;
  final String specialization;
  final String spokenLanguage;
  final String courses;
  final String skills;
  final File pdf;
  final bool isGraduated;

  EducationalDetails({
    @required this.id,
    @required this.educationLevels,
    @required this.specialization,
    @required this.spokenLanguage,
    @required this.courses,
    @required this.skills,
    @required this.pdf,
    @required this.isGraduated,
  });
}

class EducationalDetailsProvider with ChangeNotifier {
  EducationalDetails educationDetails;

  EducationalDetails get item {
    return educationDetails;
  }

  Future<void> findByUserId(String id, String url) async {
    // final urlSend = '$ipAddress/get/user';

    try {
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({'id': int.parse(id)}));
      var responseData = json.decode(response.body);
      File pdf;
      if (responseData['educational_detail'] != null) {
        var pdfResponse = responseData['educational_detail']['c_v'];
        if (pdfResponse != null) {
          pdf = stringToFile(responseData['educational_detail']['c_v'], 'pdf');
        }
      }
      EducationalDetails educationalDetails =
          responseData['educational_detail'] == null
              ? null
              : EducationalDetails(
                  pdf: pdf,
                  skills: responseData['educational_detail']['skills'],
                  courses: responseData['educational_detail']['courses'],
                  id: responseData['educational_detail']['id'].toString(),
                  isGraduated: responseData['educational_detail']['graduate'],
                  educationLevels: responseData['educational_detail']
                      ['education'],
                  specialization: responseData['educational_detail']
                      ['specialization'],
                  spokenLanguage: responseData['educational_detail']
                      ['languages_known'],
                );
      educationDetails = educationalDetails;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void editEducationDetails(
      EducationalDetails ed, String userID, String url) async {
    try {
      await http.post(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode({
          'id': int.parse(userID),
          'languages_known': ed.spokenLanguage,
          'education': ed.educationLevels,
          'specialization': ed.specialization,
          'graduate': ed.isGraduated,
          'courses': ed.courses,
          'skills': ed.skills,
          'c_v': ed.pdf == null ? null : fileToString(ed.pdf),
        }),
      );
      educationDetails = ed;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

class CompanyDetails {
  DateTime dateOfAaccountCreation = DateTime.now();
  final String id, name, email, password, specialization, description;
  double rating = 0.0;
  final File image;
  final Accounts accounts;
  final UserLocation location;

  CompanyDetails({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.specialization,
    @required this.description,
    @required this.image,
    @required this.accounts,
    @required this.location,
    this.rating,
    this.dateOfAaccountCreation,
  });
}

class CompanyDetailsProvider with ChangeNotifier {
  CompanyDetails companyDetails;

  CompanyDetails get item => companyDetails;

  Future<void> findByCompanyId(String id) async {
    final url = '$ipAddress/get/company';
    try {
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({'id': int.parse(id)}));
      var responseData = json.decode(response.body);
      CompanyDetails details = CompanyDetails(
        password: null,
        id: responseData['id'].toString(),
        name: responseData['name'],
        email: responseData['email'],
        rating: responseData['rating'],
        description: responseData['description'],
        specialization: responseData['specialization'],
        image: responseData['image'] == null
            ? null
            : stringToFile(responseData['image'], 'jpg'),
        accounts: responseData['accounts'] == null
            ? null
            : Accounts(
                gmail: responseData['accounts']['gmail'],
                twitter: responseData['accounts']['twitter'],
                facebook: responseData['accounts']['facebook'],
                telegram: responseData['accounts']['telegram'],
                linkedin: responseData['accounts']['linkedin'],
                instagram: responseData['accounts']['instagram'],
              ),
        location: responseData['position'] == null
            ? null
            : UserLocation(
                0.0,
                0.0,
                responseData['position']['city'],
                responseData['position']['country'],
              ),
      );
      companyDetails = details;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void editCompanyDetails(CompanyDetails cd, String compnayId) async {
    final url = '$ipAddress/edit/company';
    print(compnayId);
    try {
      await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'id': int.parse(compnayId),
            'name': cd.name,
            'description': cd.description,
            'specialization': cd.specialization,
            'email': cd.email,
            'password': cd.password,
            'rating': cd.rating,
            'image': cd.image == null ? null : fileToString(cd.image),
            'position': {
              'latitude': cd.location.latitude,
              'longitude': cd.location.longitude,
              'city': cd.location.city,
              'country': cd.location.country
            },
            'accounts': {
              'twitter': cd.accounts.twitter,
              'facebook': cd.accounts.facebook,
              'instagram': cd.accounts.instagram,
              'gmail': cd.accounts.gmail,
              'telegram': cd.accounts.telegram,
              'linkedin': cd.accounts.linkedin
            }
          }));
      companyDetails = cd;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
