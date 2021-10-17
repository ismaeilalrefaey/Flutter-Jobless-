//@dart=2.9
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/accounts.dart';
import '../global_stuff.dart';
import '../models/accounts.dart';
import '../models/location.dart';
import '../providers/details.dart';
import 'dart:convert';

import '../models/http_exceptions.dart';
import 'job.dart';

class JobBusiness with ChangeNotifier {
  List<Job> _jobsItems = [];

  // GET ALL JOBS
  List<Job> get jobsItem {
    return [..._jobsItems];
  }

  // favorite toggle
  Future<void> toggle(String userId, String jobId) async {
    final url = '$ipAddress/user/change_job_favorite';
    try {
      await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'user_id': int.parse(userId),
            'job_offer_id': int.parse(jobId),
          }));
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  List<Job> _requests = [];
  List<Job> get getRequests => [..._requests];

  List<Job> _favoriteList = [];
  List<Job> get getFavorite => [..._favoriteList];

  // GET A SPECIFIC LIST OF JOBS FOR THIS USER
  Future<void> specificJobs(String url, String userId) async {
    List<Job> loadedData = [];
    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'user_id': int.parse(userId),
          }));
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return [];
      }
      print(extractedData);
      extractedData.forEach((jobData) {
        String date = jobData['date_of_publication'].substring(0, 10);
        var publicationDate = DateTime(int.parse(date.substring(0, 4)),
            int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
        loadedData.add(
          Job(
              jobCondition: JobCondition(
                id: jobData['job_condition']['id'].toString(),
                country: jobData['job_condition']['country'],
                gender: jobData['job_condition']['gender'],
                nationality: jobData['job_condition']['nationality'],
                languages: jobData['job_condition']['language'],
                age: jobData['job_condition']['age'].toString(),
                skills: jobData['job_condition']['skills'],
                educationLevel: jobData['job_condition']['education_level'],
                specialization: jobData['job_condition']['specialization'],
                yearsOfExperience:
                    jobData['job_condition']['years_of_experience'].toString(),
              ),
              company: CompanyDetails(
                id: jobData['company']['id'].toString(),
                name: jobData['company']['name'],
                email: jobData['company']['email'],
                password: null,
                specialization: jobData['company']['specialization'],
                description: jobData['company']['description'],
                image: jobData['company']['image'] == null
                    ? null
                    : stringToFile(jobData['company']['image'], 'jpg'),
                accounts: jobData['company']['account'] == null
                    ? null
                    : Accounts(
                        twitter: jobData['company']['account']['twitter'],
                        facebook: jobData['company']['account']['facebook'],
                        telegram: jobData['company']['account']['telegram'],
                        instagram: jobData['company']['account']['instagram'],
                        linkedin: jobData['company']['account']['linkedin'],
                        gmail: jobData['company']['account']['gmail']),
                location: jobData['company']['position'] == null
                    ? null
                    : UserLocation(
                        0.0,
                        0.0,
                        jobData['company']['position']['city'],
                        jobData['company']['position']['country']),
                rating: jobData['company']['rating'] * 1.0,
              ),
              id: jobData['id'].toString(),
              title: jobData['title'],
              description: jobData['description'],
              salary: jobData['salary'],
              shift: jobData['shift_time_of_job'],
              durationOfJob: jobData['duration_of_job'] == null
                  ? 0.0
                  : jobData['duration_of_job'] * 1.0,
              dateOfPublication: publicationDate,
              numberOfVacancies: jobData['number_of_vacancies'],
              image: jobData['image'] == null
                  ? null
                  : stringToFile(jobData['image'], 'jpg'),
              favorite: jobData['favorite']),
        );
      });
      if (url == '$ipAddress/user/favorite_job_offer') {
        _favoriteList = loadedData.reversed.toList();
      } else if (url == '$ipAddress/user/get_applied_job') {
        _requests = loadedData.reversed.toList();
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  // User CANCEL REQUESTES HE SENT
  Future<void> deleteRequest(String userId, String jobId) async {
    final url = '$ipAddress/delete/user/user_job_offer';
    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'user_id': userId,
            'job_id': jobId,
          }));
      print(response.statusCode);
      if (response.statusCode == 200) {
        _requests.removeWhere((job) => job.id == jobId);
        notifyListeners();
      } else {
        throw HttpExceptions('Could not cancel right now try later');
      }
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  // FIND A JOB BY ID
  Job findById(String id) {
    return _jobsItems.firstWhere((job) => job.id == id);
  }

  // SEARCH ABOUT SOMETHING
  Future<void> searchAboutJobs(String specialization, String userId) async {
    final url = '$ipAddress/user/search';
    try {
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'id': int.parse(userId),
            'title': specialization,
          }));

      var extractedJobs = json.decode(response.body);
      List<Job> loadedJobs = [];

      if (extractedJobs == null || extractedJobs.isEmpty) {
        return;
      }
      print(extractedJobs);
      extractedJobs.forEach((jobData) {
        String date = jobData['date_of_publication'].substring(0, 10);
        var publicationDate = DateTime(int.parse(date.substring(0, 4)),
            int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
        loadedJobs.add(
          Job(
              jobCondition: jobData['job_condition'] == null
                  ? null
                  : JobCondition(
                      id: jobData['job_condition']['id'].toString(),
                      country: jobData['job_condition']['country'],
                      gender: jobData['job_condition']['gender'],
                      nationality: jobData['job_condition']['nationality'],
                      languages: jobData['job_condition']['language'],
                      age: jobData['job_condition']['age'] == null
                          ? ''
                          : jobData['job_condition']['age'].toString(),
                      skills: jobData['job_condition']['skills'],
                      educationLevel: jobData['job_condition']
                          ['education_level'],
                      specialization: jobData['job_condition']
                          ['specialization'],
                      yearsOfExperience: jobData['job_condition']
                                  ['years_of_experience'] ==
                              null
                          ? ''
                          : jobData['job_condition']['years_of_experience']
                              .toString(),
                    ),
              company: CompanyDetails(
                id: jobData['company']['id'].toString(),
                name: jobData['company']['name'],
                email: jobData['company']['email'],
                password: null,
                specialization: jobData['company']['specialization'],
                description: jobData['company']['description'],
                image: jobData['company']['image'] == null
                    ? null
                    : stringToFile(jobData['company']['image'], 'jpg'),
                accounts: jobData['company']['account'] == null
                    ? null
                    : Accounts(
                        twitter: jobData['company']['account']['twitter'],
                        facebook: jobData['company']['account']['facebook'],
                        telegram: jobData['company']['account']['telegram'],
                        instagram: jobData['company']['account']['instagram'],
                        linkedin: jobData['company']['account']['linkedin'],
                        gmail: jobData['company']['account']['gmail']),
                location: jobData['company']['position'] == null
                    ? null
                    : UserLocation(
                        jobData['company']['position']['latitude'] * 1.0,
                        jobData['company']['position']['longitude'] * 1.0,
                        jobData['company']['position']['city'],
                        jobData['company']['position']['country']),
                rating: jobData['company']['rating'],
              ),
              id: jobData['id'].toString(),
              title: jobData['title'],
              description: jobData['description'],
              salary: jobData['salary'],
              shift: jobData['shift_time_of_job'],
              durationOfJob: jobData['duration_of_job'] == null
                  ? 0.0
                  : jobData['duration_of_job'] * 1.0,
              dateOfPublication: publicationDate,
              numberOfVacancies: jobData['number_of_vacancies'],
              image: jobData['image'] == null
                  ? null
                  : stringToFile(jobData['image'], 'jpg'),
              favorite: jobData['favorite']),
        );
      });
      _jobsItems = loadedJobs.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // ADD NEW JOB
  Future<void> addJobs(Job job, JobCondition jobCondition, String id) async {
    final url = '$ipAddress/company/add/job';
    try {
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'company_id': int.parse(id),
            'title': job.title,
            'description': job.description,
            'salary': job.salary,
            'shift': job.shift,
            'durationOfJob': job.durationOfJob,
            'numberOfVacancies': job.numberOfVacancies,
            'dateOfPublication': job.dateOfPublication.toIso8601String(),
            'job_condition': {
              'country': jobCondition.country,
              'gender': jobCondition.gender,
              'nationality': jobCondition.nationality,
              'languages': jobCondition.languages,
              'age': int.parse(jobCondition.age),
              'skills': jobCondition.skills,
              'education': jobCondition.educationLevel,
              'specialization': jobCondition.specialization,
              'yearsOfExperience': jobCondition.yearsOfExperience == null
                  ? 0
                  : int.parse(jobCondition.yearsOfExperience)
            }
          }));
      // _jobsItems.add(job);
      if (response.statusCode == 201) {
        throw 'Wait for the Admin to approve';
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  // EDIR EXISTED JOB
  Future<void> editJob(
      String jobId, Job newJob, JobCondition newCondition) async {
    final jobIndex = _jobsItems.indexWhere((job) => job.id == jobId);
    if (jobIndex >= 0) {
      try {
        final url = '$ipAddress/company/edit/job';
        await http.post(Uri.parse(url),
            headers: <String, String>{'Content-Type': 'application/json'},
            body: json.encode({
              'job_condition': {
                'country': newCondition.country,
                'gender': newCondition.gender,
                'nationality': newCondition.nationality,
                'languages': newCondition.languages,
                'age': int.parse(newCondition.age),
                'skills': newCondition.skills,
                'education': newCondition.educationLevel,
                'specialization': newCondition.specialization,
                'years_of_experience': newCondition.yearsOfExperience == null
                    ? 0
                    : int.parse(newCondition.yearsOfExperience)
              },
              'id': int.parse(newJob.id),
              'company_id': int.parse(newJob.company.id),
              'title': newJob.title,
              'description': newJob.description,
              'salary': newJob.salary,
              'shift_time_of_job': newJob.shift,
              'duration_of_job': newJob.durationOfJob,
              'number_of_vacancies': newJob.numberOfVacancies,
              'image': newJob.image == null ? null : fileToString(newJob.image),
            }));

        _jobsItems[jobIndex] = newJob;
        notifyListeners();
      } catch (error) {
        print(error.toString());
        throw (error);
      }
    } else {
      print('there is no job with this id');
    }
  }

  //FETCH A JOB
  Future<void> fetchAndSetJobs(String urlFetchJob, String userId) async {
    try {
      final response = await http.post(
        Uri.parse(urlFetchJob),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId == null ? null : int.parse(userId),
        }),
      );
      final List<Job> loadedData = [];
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      print(extractedData);
      extractedData.forEach((jobData) {
        String date = jobData['date_of_publication'].substring(0, 10);
        var publicationDate = DateTime(int.parse(date.substring(0, 4)),
            int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
        loadedData.add(
          Job(
              jobCondition: jobData['job_condition'] == null
                  ? null
                  : JobCondition(
                      id: jobData['job_condition']['id'].toString(),
                      country: jobData['job_condition']['country'],
                      gender: jobData['job_condition']['gender'],
                      nationality: jobData['job_condition']['nationality'],
                      languages: jobData['job_condition']['language'],
                      age: jobData['job_condition']['age'].toString(),
                      skills: jobData['job_condition']['skills'],
                      educationLevel: jobData['job_condition']
                          ['education_level'],
                      specialization: jobData['job_condition']
                          ['specialization'],
                      yearsOfExperience: jobData['job_condition']
                              ['years_of_experience']
                          .toString(),
                    ),
              company: CompanyDetails(
                id: jobData['company']['id'].toString(),
                name: jobData['company']['name'],
                email: jobData['company']['email'],
                password: null,
                specialization: jobData['company']['specialization'],
                description: jobData['company']['description'],
                image: jobData['company']['image'] == null
                    ? null
                    : stringToFile(jobData['company']['image'], 'jpg'),
                accounts: jobData['company']['account'] == null
                    ? null
                    : Accounts(
                        twitter: jobData['company']['account']['twitter'],
                        facebook: jobData['company']['account']['facebook'],
                        telegram: jobData['company']['account']['telegram'],
                        instagram: jobData['company']['account']['instagram'],
                        linkedin: jobData['company']['account']['linkedin'],
                        gmail: jobData['company']['account']['gmail']),
                location: jobData['company']['position'] == null
                    ? null
                    : UserLocation(
                        jobData['company']['position']['latitude'] == null
                            ? 0.0
                            : jobData['company']['position']['latitude'] * 1.0,
                        jobData['company']['position']['longitude'] == null
                            ? 0.0
                            : jobData['company']['position']['longitude'] * 1.0,
                        jobData['company']['position']['city'],
                        jobData['company']['position']['country']),
                rating: jobData['company']['rating'],
              ),
              id: jobData['id'].toString(),
              title: jobData['title'],
              description: jobData['description'],
              salary: jobData['salary'],
              shift: jobData['shift_time_of_job'],
              durationOfJob: jobData['duration_of_job'] == null
                  ? 0.0
                  : jobData['duration_of_job'] * 1.0,
              dateOfPublication: publicationDate,
              numberOfVacancies: jobData['number_of_vacancies'],
              image: jobData['image'] == null
                  ? null
                  : stringToFile(jobData['image'], 'jpg'),
              favorite: jobData['favorite']),
        );
      });
      _jobsItems = loadedData.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  // user add some filter for job, FOR USER
  Future<void> addUserFilter(
      String userId,
      String date,
      String country,
      String city,
      String gender,
      String salary,
      String shift,
      String yearsOfExperience,
      UserLocation userLocation) async {
    final url = '$ipAddress/filter/joboffer';

    var publishDate;
    if (date != null) {
      if (date == 'last 24 hours') {
        publishDate = 1;
      } else if (date == 'last week') {
        publishDate = 7;
      } else if (date == 'last 15 days') {
        publishDate = 15;
      } else if (date == 'last month') {
        publishDate = 30;
      }
    }

    Range salaryRange;
    if (salary != null) {
      salaryRange = salary.contains('-')
          ? Range(
              num.parse(salary.substring(0, salary.indexOf('\$'))),
              num.parse(
                  salary.substring(salary.indexOf('-') + 2, salary.length - 1)))
          : salary.contains('Less')
              ? Range(0, num.parse(salary.substring(10, salary.length - 1)))
              : salary.contains('More')
                  ? Range(num.parse(salary.substring(10, salary.length - 1)),
                      100000)
                  : null;
    }

    print(salaryRange);

    Range yearsRange;
    if (yearsOfExperience != null) {
      yearsRange = yearsOfExperience.contains('-')
          ? Range(
              num.parse(yearsOfExperience.substring(
                  0, yearsOfExperience.indexOf('-') - 1)),
              num.parse(yearsOfExperience.substring(
                  yearsOfExperience.indexOf('-') + 2,
                  yearsOfExperience.indexOf('y') - 1)))
          : yearsOfExperience.contains('Less')
              ? Range(
                  0,
                  num.parse(yearsOfExperience.substring(
                      10, yearsOfExperience.indexOf('y') - 1)))
              : yearsOfExperience.contains('More')
                  ? Range(
                      num.parse(yearsOfExperience.substring(
                          10, yearsOfExperience.indexOf('y') - 1)),
                      100000)
                  : null;
    }
    try {
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'user_id': int.parse(userId),
            'publish_date': publishDate,
            'salary': salaryRange == null
                ? null
                : {
                    'from': salaryRange.from,
                    'to': salaryRange.to,
                  },
            'country_location': country,
            'city_location': city,
            'position': userLocation == null
                ? null
                : {
                    'latitude': userLocation.latitude,
                    'longitude': userLocation.longitude,
                  },
            'gender': gender,
            'shift_time_of_job': shift,
            'years_of_experience': yearsRange == null
                ? null
                : {
                    'from': yearsRange.from,
                    'to': yearsRange.to,
                  },
          }));
      final List<Job> loadedData = [];
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      print(extractedData);
      extractedData.forEach((jobData) {
        String date = jobData['date_of_publication'].substring(0, 10);
        var publicationDate = DateTime(int.parse(date.substring(0, 4)),
            int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
        loadedData.add(
          Job(
              jobCondition: jobData['job_condition'] == null
                  ? null
                  : JobCondition(
                      id: jobData['job_condition']['id'].toString(),
                      country: jobData['job_condition']['country'],
                      gender: jobData['job_condition']['gender'],
                      nationality: jobData['job_condition']['nationality'],
                      languages: jobData['job_condition']['language'],
                      age: jobData['job_condition']['age'].toString(),
                      skills: jobData['job_condition']['skills'],
                      educationLevel: jobData['job_condition']
                          ['education_level'],
                      specialization: jobData['job_condition']
                          ['specialization'],
                      yearsOfExperience: jobData['job_condition']
                              ['years_of_experience']
                          .toString(),
                    ),
              company: CompanyDetails(
                id: jobData['company']['id'].toString(),
                name: jobData['company']['name'],
                email: jobData['company']['email'],
                password: null,
                specialization: jobData['company']['specialization'],
                description: jobData['company']['description'],
                image: jobData['company']['image'] == null
                    ? null
                    : stringToFile(jobData['company']['image'], 'jpg'),
                accounts: jobData['company']['account'] == null
                    ? null
                    : Accounts(
                        twitter: jobData['company']['account']['twitter'],
                        facebook: jobData['company']['account']['facebook'],
                        telegram: jobData['company']['account']['telegram'],
                        instagram: jobData['company']['account']['instagram'],
                        linkedin: jobData['company']['account']['linkedin'],
                        gmail: jobData['company']['account']['gmail']),
                location: jobData['company']['position'] == null
                    ? null
                    : UserLocation(
                        jobData['company']['position']['latitude'] == null
                            ? null
                            : jobData['company']['position']['latitude'] * 1.0,
                        jobData['company']['position']['longitude'] == null
                            ? null
                            : jobData['company']['position']['longitude'] * 1.0,
                        jobData['company']['position']['city'],
                        jobData['company']['position']['country']),
                rating: jobData['company']['rating'],
              ),
              id: jobData['id'].toString(),
              title: jobData['title'],
              description: jobData['description'],
              salary: jobData['salary'],
              shift: jobData['shift_time_of_job'],
              durationOfJob: jobData['duration_of_job'] == null
                  ? 0.0
                  : jobData['duration_of_job'] * 1.0,
              dateOfPublication: publicationDate,
              numberOfVacancies: jobData['number_of_vacancies'],
              image: jobData['image'] == null
                  ? null
                  : stringToFile(jobData['image'], 'jpg'),
              favorite: jobData['favorite']),
        );
      });
      _jobsItems = loadedData.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // DELETE A JOB
  Future<void> deleteJob(String jobId) async {
    final url = '$ipAddress/company/delete/job_after_admin_accept';
    final existingJobIndex = _jobsItems.indexWhere((job) => job.id == jobId);
    var existingJob = _jobsItems[existingJobIndex];

    _jobsItems.removeAt(existingJobIndex);
    notifyListeners();

    final offerResponse = await http.post(Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode({
          'job_offer_id': int.parse(jobId),
        }));

    if (offerResponse.statusCode == 400) {
      _jobsItems.insert(existingJobIndex, existingJob);
      notifyListeners();
      throw HttpExceptions('Could not delete this job right now try later ');
    }

    existingJob = null;
  }

  List<UserAccount> _applied = [];

  List<UserAccount> get usersApplied => [..._applied];

  Future<void> getAllUsersAppliedForAJob(String jobId) async {
    final url = '$ipAddress/company/get_all_income_request';
    try {
      print('userID in Fetch');
      print(jobId);
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'job_offer_id': int.parse(jobId),
          }));
      final List<UserAccount> loadedData = [];
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return [];
      }
      print(extractedData);
      extractedData.forEach((user) {
        String date =
            user['object']['basic_detail']['birthday_date'].substring(0, 10);
        DateTime birthday = DateTime(int.parse(date.substring(0, 4)),
            int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
        loadedData.add(
          UserAccount.detailedConstructor(
              BasicDetails(
                  id: user['object']['basic_detail']['id'].toString(),
                  firstName: user['object']['basic_detail']['first_name'],
                  lastName: user['object']['basic_detail']['last_name'],
                  gender: user['object']['basic_detail']['gender'],
                  birthday: birthday,
                  email: user['object']['basic_detail']['email'],
                  password: null,
                  phoneNumber: user['object']['basic_detail']['phone_number']),
              user['object']['educational_detail'] == null
                  ? null
                  : EducationalDetails(
                      id: user['object']['educational_detail']['id'].toString(),
                      educationLevels: user['object']['educational_detail']
                          ['education'],
                      specialization: user['object']['educational_detail']
                          ['specialization'],
                      spokenLanguage: user['object']['educational_detail']
                          ['languages_known'],
                      courses: user['object']['educational_detail']['courses'],
                      skills: user['object']['educational_detail']['skills'],
                      pdf: user['object']['educational_detail']['c_v'] == null
                          ? null
                          : stringToFile(
                              user['object']['educational_detail']['c_v'],
                              'jpg'),
                      isGraduated: user['object']['educational_detail']
                          ['graduate']),
              user['object']['additional_detail'] == null
                  ? null
                  : AdditionalDetails(
                      id: user['object']['additional_detail']['id'].toString(),
                      image:
                          user['object']['additional_detail']['image'] == null
                              ? null
                              : stringToFile(
                                  user['object']['additional_detail']['image'],
                                  'jpg'),
                      nationality: user['object']['additional_detail']
                          ['nationality'],
                      creditCard: user['object']['additional_detail']
                          ['credit_card_number'],
                      location: user['object']['additional_detail']
                                  ['position'] ==
                              null
                          ? null
                          : UserLocation(
                              user['object']['additional_detail']['position']
                                      ['latitude'] *
                                  1.0,
                              user['object']['additional_detail']['position']
                                      ['longitude'] *
                                  1.0,
                              user['object']['additional_detail']['position']
                                  ['city'],
                              user['object']['additional_detail']['position']
                                  ['country']),
                      accounts: user['object']['additional_detail']
                                  ['account'] ==
                              null
                          ? null
                          : Accounts(
                              twitter: user['object']['additional_detail']
                                  ['account']['twitter'],
                              facebook: user['object']['additional_detail']
                                  ['account']['facebook'],
                              telegram: user['object']['additional_detail']
                                  ['account']['telegram'],
                              instagram: user['object']['additional_detail']
                                  ['account']['instagram'],
                              linkedin: user['object']['additional_detail']
                                  ['account']['linkedin'],
                              gmail: user['object']['additional_detail']
                                  ['account']['gmail']),
                    ),
              user['object']['id'].toString()),
        );
      });
      _applied = loadedData.reversed.toList();
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  // add filter for user applied on job, FOR COMPANY
  Future<void> filterUsersApplied(
      String jobId, String age, String gender, String graduate) async {
    final url = '$ipAddress/filter/company/in_req_joboffer';

    Range ageRange;
    if (age != null) {
      ageRange = age.contains('-')
          ? Range(num.parse(age.substring(0, age.indexOf('-') - 1)),
              num.parse(age.substring(age.indexOf('-') + 2, age.length)))
          : Range(40, 60);
    }

    try {
      print('userID in Fetch');
      print(jobId);
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'id': int.parse(jobId),
            'age': age == null
                ? null
                : {
                    'from': ageRange.from,
                    'to': ageRange.to,
                  },
            'graduate': graduate == null
                ? null
                : graduate == 'Yes'
                    ? true
                    : false,
            'gender_of_user': gender,
          }));
      final List<UserAccount> loadedData = [];
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return [];
      }
      print(extractedData);
      extractedData.forEach((user) {
        String date =
            user['object']['basic_detail']['birthday_date'].substring(0, 10);
        DateTime birthday = DateTime(int.parse(date.substring(0, 4)),
            int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
        loadedData.add(
          UserAccount.detailedConstructor(
              BasicDetails(
                  id: user['object']['basic_detail']['id'].toString(),
                  firstName: user['object']['basic_detail']['first_name'],
                  lastName: user['object']['basic_detail']['last_name'],
                  gender: user['object']['basic_detail']['gender'],
                  birthday: birthday,
                  email: user['object']['basic_detail']['email'],
                  password: null,
                  phoneNumber: user['object']['basic_detail']['phone_number']),
              user['object']['educational_detail'] == null
                  ? null
                  : EducationalDetails(
                      id: user['object']['educational_detail']['id'].toString(),
                      educationLevels: user['object']['educational_detail']
                          ['education'],
                      specialization: user['object']['educational_detail']
                          ['specialization'],
                      spokenLanguage: user['object']['educational_detail']
                          ['languages_known'],
                      courses: user['object']['educational_detail']['courses'],
                      skills: user['object']['educational_detail']['skills'],
                      pdf: user['object']['educational_detail']['c_v'] == null
                          ? null
                          : stringToFile(
                              user['object']['educational_detail']['c_v'],
                              'jpg'),
                      isGraduated: user['object']['educational_detail']
                          ['graduate']),
              user['object']['additional_detail'] == null
                  ? null
                  : AdditionalDetails(
                      id: user['object']['additional_detail']['id'].toString(),
                      image:
                          user['object']['additional_detail']['image'] == null
                              ? null
                              : stringToFile(
                                  user['object']['additional_detail']['image'],
                                  'jpg'),
                      nationality: user['object']['additional_detail']
                          ['nationality'],
                      creditCard: user['object']['additional_detail']
                          ['credit_card_number'],
                      location: user['object']['additional_detail']
                                  ['position'] ==
                              null
                          ? null
                          : UserLocation(
                              user['object']['additional_detail']['position']
                                      ['latitude'] *
                                  1.0,
                              user['object']['additional_detail']['position']
                                      ['longitude'] *
                                  1.0,
                              user['object']['additional_detail']['position']
                                  ['city'],
                              user['object']['additional_detail']['position']
                                  ['country']),
                      accounts: user['object']['additional_detail']
                                  ['account'] ==
                              null
                          ? null
                          : Accounts(
                              twitter: user['object']['additional_detail']
                                  ['account']['twitter'],
                              facebook: user['object']['additional_detail']
                                  ['account']['facebook'],
                              telegram: user['object']['additional_detail']
                                  ['account']['telegram'],
                              instagram: user['object']['additional_detail']
                                  ['account']['instagram'],
                              linkedin: user['object']['additional_detail']
                                  ['account']['linkedin'],
                              gmail: user['object']['additional_detail']
                                  ['account']['gmail']),
                    ),
              user['object']['id'].toString()),
        );
      });
      _applied = loadedData.reversed.toList();
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }
}
