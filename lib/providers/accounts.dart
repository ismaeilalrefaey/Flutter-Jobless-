//@dart=2.9

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'details.dart';
import '../global_stuff.dart';
import '../models/accounts.dart';
import '../models/location.dart';

abstract class Account with ChangeNotifier {
  String userId, token;

  String get userToken => token;

  Account get accounts => this;
}

class UserAccount extends Account {
  BasicDetails basicDetails;
  EducationalDetails educationalDetails;
  AdditionalDetails additionalDetails;
  DateTime dateOfAccountCreation;

  UserAccount(String jsonResponse) {
    var data = json.decode(jsonResponse);
    print(data);
    token = data['token'];
    userId = data['object']['id'].toString();
    String date = (data['object']['date_of_account_creation']).substring(0, 10);
    dateOfAccountCreation = DateTime(int.parse(date.substring(0, 4)),
        int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
    var object = data['object'];
    var k = object['basic_detail']['birthday_date'];
    date = k.substring(0, 10);
    DateTime birthday = DateTime(int.parse(date.substring(0, 4)),
        int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
    print(birthday);
    basicDetails = BasicDetails(
      id: object['basic_detail']['id'].toString(),
      firstName: object['basic_detail']['first_name'],
      lastName: object['basic_detail']['last_name'],
      gender: object['basic_detail']['gender'],
      birthday: birthday,
      email: object['basic_detail']['email'],
      password: object['basic_detail']['password'],
      phoneNumber: object['basic_detail']['phone_number'],
    );
    educationalDetails = object['educational_detail'] == null
        ? null
        : EducationalDetails(
            isGraduated: object['graduate'],
            skills: object['educational_detail']['skills'],
            courses: object['educational_detail']['courses'],
            id: object['educational_detail']['id'].toString(),
            educationLevels: object['educational_detail']['education'],
            specialization: object['educational_detail']['specialization'],
            spokenLanguage: object['educational_detail']['languages_known'],
            pdf: object['educational_detail']['c_v'] == null
                ? null
                : stringToFile(object['educational_detail']['c_v'], 'pdf'),
          );

    additionalDetails = object['additional_detail'] == null
        ? null
        : AdditionalDetails(
            id: object['additional_detail']['id'].toString(),
            image: object['additional_detail']['image'] == null
                ? null
                : stringToFile(object['additional_detail']['image'], 'jpg'),
            nationality: object['additional_detail']['nationality'],
            creditCard: object['additional_detail']['credit_card_number'],
            location: object['additional_detail']['position'] == null
                ? null
                : UserLocation(
                    object['additional_detail']['position']['latitude'] * 1.0,
                    object['additional_detail']['position']['longitude'] * 1.0,
                    object['additional_detail']['position']['city'],
                    object['additional_detail']['position']['country'],
                  ),
            accounts: object['additional_detail']['account'] == null
                ? null
                : Accounts(
                    twitter: object['additional_detail']['account']['twitter'],
                    facebook: object['additional_detail']['account']
                        ['facebook'],
                    telegram: object['additional_detail']['account']
                        ['telegram'],
                    instagram: object['additional_detail']['account']
                        ['instagram'],
                    linkedin: object['additional_detail']['account']
                        ['linkedin'],
                    gmail: object['additional_detail']['account']['gmail'],
                  ),
          );
    print('After Addit');
    print(additionalDetails == null ? 'null' : 'has Value');
  }
  UserAccount.detailedConstructor(
      BasicDetails basicDetails,
      EducationalDetails educationalDetails,
      AdditionalDetails additionalDetails,
      String userId) {
    this.userId = userId;
    this.basicDetails = basicDetails;
    this.additionalDetails = additionalDetails;
    this.educationalDetails = educationalDetails;
  }

  Future<bool> rate(String freelancerId, double rate) async {
    try {
      final url = '$ipAddress/user/ratefreelancer';
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'user_id': int.parse(this.userId),
            'freelancer_id': int.parse(freelancerId),
            'rate': rate.toString(),
          }));
      print(response.statusCode.toString());
      if (response.statusCode != 200) {
        print('Rate failed');
        return false;
      }
      print('Rate Succeeded');
      return true;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void applyForAJob(String jobId) async {
    try {
      final url = '$ipAddress/user/apply_for_a_job';
      await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'user_id': int.parse(this.userId),
            'job_offer_id': int.parse(jobId),
          }));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  void approveFreelancer(String freelancerId, String offerId) async {
    final url = '$ipAddress/user/accept/freelancer';
    try {
      await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'freelancer_id': int.parse(freelancerId),
            'freelance_job_offer_id': int.parse(offerId),
          }));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void disapproveFreelancer(String freelancerId, String offerId) async {
    try {
      final url = '$ipAddress/user/reject/freelancer';
      await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'freelancer_id': int.parse(freelancerId),
            'freelance_job_offer_id': int.parse(offerId),
          }));
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

class FreelancerAccount extends Account {
  BasicDetails basicDetails;
  EducationalDetails educationalDetails;
  AdditionalDetails additionalDetails;
  DateTime dateOfAccountCreation;
  double rate;
  File portfolio;

  FreelancerAccount(String jsonResponse) {
    var data = json.decode(jsonResponse);
    print(data);
    token = data['token'];
    userId = data['object']['id'].toString();
    var object = data['object'];
    rate = object['rate'];
    portfolio = object['portfolio'] == null ? null : stringToFile(object['portfolio'], 'pdf');
    String date = object['date_of_account_creation'].substring(0, 10);
    dateOfAccountCreation = DateTime(int.parse(date.substring(0, 4)),
        int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
    var dateBirthday = object['basic_detail']['birthday_date'].substring(0, 10);
    DateTime birthday = DateTime(
        int.parse(dateBirthday.substring(0, 4)),
        int.parse(dateBirthday.substring(5, 7)),
        int.parse(dateBirthday.substring(8)));
    basicDetails = BasicDetails(
      id: object['basic_detail']['id'].toString(),
      firstName: object['basic_detail']['first_name'],
      lastName: object['basic_detail']['last_name'],
      gender: object['basic_detail']['gender'],
      birthday: birthday,
      email: object['basic_detail']['email'],
      password: null,
      phoneNumber: object['basic_detail']['phone_number'],
    );

    educationalDetails = object['educational_detail'] == null
        ? null
        : EducationalDetails(
            id: object['educational_detail']['id'].toString(),
            skills: object['educational_detail']['skills'],
            courses: object['educational_detail']['courses'],
            isGraduated: object['educational_detail']['graduate'],
            educationLevels: object['educational_detail']['education'],
            specialization: object['educational_detail']['specialization'],
            spokenLanguage: object['educational_detail']['languages_known'],
            pdf: object['educational_detail']['c_v'] == null
                ? null
                : stringToFile(object['educational_detail']['c_v'], 'jpg'));
    additionalDetails = object['additional_detail'] == null
        ? null
        : AdditionalDetails(
            id: object['additional_detail']['id'].toString(),
            image: object['additional_detail']['image'] == null
                ? null
                : stringToFile(object['additional_detail']['image'], 'jpg'),
            nationality: object['additional_detail']['nationality'],
            creditCard: object['additional_detail']['credit_card_number'],
            location: object['additional_detail']['position'] == null
                ? null
                : UserLocation(
                    object['additional_detail']['position']['latitude'] * 1.0,
                    object['additional_detail']['position']['longitude'] * 1.0,
                    object['additional_detail']['position']['city'],
                    object['additional_detail']['position']['country'],
                  ),
            accounts: object['additional_detail']['account'] == null
                ? null
                : Accounts(
                    twitter: object['additional_detail']['account']['twitter'],
                    facebook: object['additional_detail']['account']
                        ['facebook'],
                    telegram: object['additional_detail']['account']
                        ['telegram'],
                    instagram: object['additional_detail']['account']
                        ['instagram'],
                    linkedin: object['additional_detail']['account']
                        ['linkedin'],
                    gmail: object['additional_detail']['account']['gmail'],
                  ),
          );
  }

  FreelancerAccount get accounts => this;

  List<FreelancerAccount> _allAccounts = [];

  List<FreelancerAccount> get allFreelancerAccounts => [..._allAccounts];

  Future<void> getAllFreelancerAccount() async {
    final url = '$ipAddress/user/get_all_freelancer';
    List<FreelancerAccount> loadedAccounts = [];
    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({}));
      print(response.body);
      final extractedAccounts = json.decode(response.body);
      if (extractedAccounts == null || extractedAccounts == []) {
        return;
      }
      print('before');
      print(extractedAccounts);
      extractedAccounts.forEach((freelencerAccount) {
        print(freelencerAccount.toString());
        loadedAccounts.add(FreelancerAccount(json.encode(freelencerAccount)));
      });
      print('after');
      _allAccounts = loadedAccounts.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  List<FreelancerAccount> _allFreelancersApplied = [];

  List<FreelancerAccount> get allFreelancersApplied =>
      [..._allFreelancersApplied];

  Future<void> getFreelancersAppliedForAJob(String jobId) async {
    _allFreelancersApplied = [];
    final url = '$ipAddress/user/get_all_income_request';
    print(jobId);
    List<FreelancerAccount> loadedAccounts = [];
    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'freelance_job_offer_id': int.parse(jobId),
          }));
      print(response.body);
      final extractedAccounts = json.decode(response.body);
      if (extractedAccounts == null || extractedAccounts.isEmpty) {
        _allFreelancersApplied = [];
        notifyListeners();
        return;
      }

      print('before');
      print(extractedAccounts);
      extractedAccounts.forEach((freelencerAccount) {
        print(freelencerAccount.toString());
        loadedAccounts.add(FreelancerAccount(json.encode(freelencerAccount)));
      });
      print('after');
      print(loadedAccounts);
      _allFreelancersApplied = loadedAccounts.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> filterFreelancerApplied(String jobId, String rate) async {
    final url = '$ipAddress/filter/user/in_req_frjoboffer';
    print(jobId);
    List<FreelancerAccount> loadedAccounts = [];

    var convertedRate;
    if (rate != null) {
      if (rate == 'More than 30 %') {
        convertedRate = 30;
      } else if (rate == 'More than 60 %') {
        convertedRate = 60;
      } else if (rate == 'More than 90 %') {
        convertedRate = 90;
      }
    }

    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'id': int.parse(jobId),
            'rate': convertedRate,
          }));
      print(response.body);
      final extractedAccounts = json.decode(response.body);
      if (extractedAccounts == null || extractedAccounts.isEmpty) {
        _allFreelancersApplied = [];
        notifyListeners();
        return;
      }

      print('before');
      print(extractedAccounts);
      extractedAccounts.forEach((freelencerAccount) {
        print(freelencerAccount.toString());
        loadedAccounts.add(FreelancerAccount(json.encode(freelencerAccount)));
      });
      print('after');
      print(loadedAccounts);
      _allFreelancersApplied = loadedAccounts.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void applyForAJob(String jobId) async {
    try {
      final url = '$ipAddress/freelancer/apply_for_a_frJob';
      await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'freelancer_id': this.userId,
            'freelance_job_offer_id': jobId,
          }));
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

class CompanyAccount extends Account {
  CompanyDetails companyDetails;

  CompanyAccount(String jsonResponse) {
    var data = json.decode(jsonResponse);
    token = data['token'];
    userId = data['object']['id'].toString();
    var object = data['object'];
    String date = object['date_of_account_creation'].substring(0, 10);
    DateTime dateOfAccountCreation = DateTime(int.parse(date.substring(0, 4)),
        int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
    print(dateOfAccountCreation);
    companyDetails = CompanyDetails(
        id: object['id'].toString(),
        name: object['name'],
        email: object['email'],
        accounts: object['account'] == null
            ? null
            : Accounts(
                twitter: object['account']['twitter'],
                facebook: object['account']['facebook'],
                telegram: object['account']['telegram'],
                instagram: object['account']['instagram'],
                linkedin: object['account']['linkedin'],
                gmail: object['account']['gmail'],
              ),
        password: null,
        description: object['description'],
        specialization: object['specialization'],
        image: object['image'] == null
            ? null
            : stringToFile(object['image'], 'jpg'),
        location: object['position'] == null
            ? null
            : UserLocation(
                0.0,
                0.0,
                object['position']['city'],
                object['position']['country'],
              ),
        rating: object['rate'],
        dateOfAaccountCreation: dateOfAccountCreation);
  }

  Future<bool> rate(String userId, double rate) async {
    try {
      final url = '$ipAddress/user/ratecompany';
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'company_id': int.parse(this.userId),
            'user_id': int.parse(userId),
            'rate': rate.toString(),
          }));
      print(response.statusCode.toString());
      if (response.statusCode != 200) {
        print('Rate failed');
        return false;
      }
      print('Rate Succeeded');
      return true;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void approveApplicant(String userId, String jobId) async {
    print('approve');
    print(userId);
    print(jobId);
    try {
      final url = '$ipAddress/company/accept_user';
      await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'user_id': int.parse(userId),
            'job_offer_id': int.parse(jobId),
          }));
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  void disapproveApplicant(String userId, String jobId) async {
    print('disapprove');
    print(userId);
    print(jobId);
    try {
      final url = '$ipAddress/company/reject_user';
      await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'user_id': int.parse(userId),
            'job_offer_id': int.parse(jobId),
          }));
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
