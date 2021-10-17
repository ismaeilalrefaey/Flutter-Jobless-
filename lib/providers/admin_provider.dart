// @dart=2.9

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'job.dart';
import 'details.dart';
import '../global_stuff.dart';
import '../models/accounts.dart';
import '../models/location.dart';

class AdminProvider with ChangeNotifier {
  List<CompanyDetails> newCompanies = [];

  List<Job> newJobOffers = [];

  List<CompanyDetails> get companies => newCompanies;
  List<Job> get jobs => newJobOffers;

  Future<void> fetchAndSetCompanies() async {
    var segement = 'all_company_request';
    final url = '$ipAddress/admin/$segement';
    print(url);
    try {
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({}),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      var responseBody = json.decode(response.body) as List<dynamic>;
      print(responseBody);
      if (responseBody == null || responseBody.isEmpty) {
        return [];
      }
      List<CompanyDetails> loadedData = [];
      responseBody.forEach((company) {
        loadedData.add(
          CompanyDetails(
            id: company['id'].toString(),
            name: company['name'],
            email: company['email'],
            password: '',
            specialization: '',
            description: '',
            image: null,
            accounts: null,
            location: null,
          ),
        );
      });
      newCompanies = loadedData.reversed.toList();
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> fetchAndSetJobs() async {
    var segement = 'all_job_offers';
    final url = '$ipAddress/admin/$segement';
    print(url);
    try {
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({}),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      var responseBody = json.decode(response.body) as List<dynamic>;
      print(responseBody);
      if (responseBody == null || responseBody.isEmpty) {
        return [];
      }
      List<Job> loadedData = [];
      responseBody.forEach((job) {
        print('1');
        print(job['duration_of_job']);
        print('2');
        print(job['salary'] is double);
        print('3');
        print(job['number_of_vacancies']);
        String date = (job['date_of_publication']).substring(0, 10);
        print(date);
        var dateOfPublication = DateTime(int.parse(date.substring(0, 4)),
            int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
        print(dateOfPublication);
        loadedData.add(
          Job(
            jobCondition: JobCondition(
              id: job['job_condition']['id'].toString(),
              country: job['job_condition']['country'],
              gender: job['job_condition']['gender'],
              nationality: job['job_condition']['nationality'],
              languages: job['job_condition']['language'],
              age: job['job_condition']['age'].toString(),
              skills: job['job_condition']['skills'],
              educationLevel: job['job_condition']['education_level'],
              specialization: job['job_condition']['specialization'],
              yearsOfExperience:
                  job['job_condition']['years_of_experience'].toString(),
            ),
            company: CompanyDetails(
              id: job['company']['id'].toString(),
              name: job['company']['name'],
              email: job['company']['email'],
              password: null,
              specialization: job['company']['specialization'],
              description: job['company']['description'],
              image: job['company']['image'] == null ? null :  stringToFile(job['company']['image'], 'jpg'),
              accounts: job['company']['account'] == null
                  ? null
                  : Accounts(
                      twitter: job['company']['account']['twitter'],
                      facebook: job['company']['account']['facebook'],
                      telegram: job['company']['account']['telegram'],
                      instagram: job['company']['account']['instagram'],
                      linkedin: job['company']['account']['linkedin'],
                      gmail: job['company']['account']['gmail']),
              location: job['company']['position'] == null
                  ? null
                  : UserLocation(0.0, 0.0, job['company']['position']['city'],
                      job['company']['position']['country']),
              rating: job['company']['rating'] == null
                  ? 0.0
                  : job['company']['rating'],
            ),
            id: job['id'].toString(),
            title: job['title'],
            description: job['description'],
            salary: job['salary'] == null ? 0 : job['salary'],
            shift: job['shift_time_of_job'],
            durationOfJob: job['duration_of_job'] == null
                ? 0.0
                : (job['duration_of_job'] as int).toDouble(),
            dateOfPublication: dateOfPublication,
            numberOfVacancies: job['number_of_vacancies'] == null
                ? 0
                : job['number_of_vacancies'],
            image:job['image'] == null ? null : stringToFile(job['image'], 'jpg'),
            favorite: job['favorite'],
          ),
        );
      });
      newJobOffers = loadedData.reversed.toList();
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> actionOfAdminOnCompanies(String id, bool isApproved) async {
    String companySegment = 'company_signup',
        deleteSegement = 'reject',
        approveSegement = 'accept';
    final url =
        '$ipAddress/admin/${isApproved ? approveSegement : deleteSegement}_$companySegment';
    var debug = 'it\s a ';
    debug += isApproved ? 'Approval' : 'Denial';
    print(debug);
    print('URL: $url');
    print('id is: $id');
    try {
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({'id': int.parse(id)}),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      if (response.body == 'Created' || response.body == 'OK') {
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> actionOfAdminOnJobs(String id, bool isApproved) async {
    String jobSegment = 'job_offer',
        deleteSegement = 'reject',
        approveSegement = 'accept';
    final url =
        '$ipAddress/admin/${isApproved ? approveSegement : deleteSegement}_$jobSegment';
    var debug = 'it\s a Job\'s ';
    debug += isApproved ? 'Approval' : 'Denial';
    print(debug);
    print('URL: $url');
    print('id is: $id');
    try {
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({'id': int.parse(id)}),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      if (response.body == 'Created' || response.body == 'OK') {
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
