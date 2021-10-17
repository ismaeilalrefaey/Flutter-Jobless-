//@dart=2.9
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/accounts.dart';
import '../models/location.dart';
import '../providers/details.dart';
import 'dart:convert';
import 'dart:io';

import '../global_stuff.dart';
import '../models/http_exceptions.dart';
import 'accounts.dart';

class FreelanceOffer with ChangeNotifier {
  final String id;
  final UserAccount user;
  final DateTime dateOfPublication;
  final String title;
  final String description;
  File image;
  final double wage;
  final DateTime deadLine;
  final String skills;
  bool favorite;

  FreelanceOffer(
      {@required this.id,
      @required this.user,
      @required this.dateOfPublication,
      @required this.title,
      @required this.description,
      @required this.image,
      @required this.wage,
      @required this.deadLine,
      @required this.skills,
      this.favorite});

  Map<String, dynamic> toMap(FreelanceOffer offer) {
    return {
      'id': offer.id,
      'user': null,
      'date_of_publication': offer.dateOfPublication.toIso8601String(),
      'title': offer.title,
      'description': offer.description,
      'image': offer.image == null ? null : fileToString(offer.image),
      'wage': offer.wage,
      'deadLine': offer.deadLine,
      'skills': offer.skills,
      'favorite': offer.favorite
    };
  }
}

class FreelanceOfferBusiness with ChangeNotifier {
  List<FreelanceOffer> _freelanceOfferItem = [];

  // GET ALL FREELANCE OFFER
  List<FreelanceOffer> get freeLanceItem {
    return [..._freelanceOfferItem];
  }

  // favorite toggle
  Future<void> toggle(String userId, String offerId) async {
    final url = '$ipAddress/freelancer/change_fr_job_favorite';
    try {
      await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'freelancer_id': int.parse(userId),
            'freelance_job_offer_id': int.parse(offerId),
          }));
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  List<FreelanceOffer> _requests = [];
  List<FreelanceOffer> get getRequests => [..._requests];

  List<FreelanceOffer> _favoriteList = [];
  List<FreelanceOffer> get getFavorite => [..._favoriteList];

  // GET ALL FAVORITE FOR THIS USER
  Future<void> specificOffers(String url, String userId) async {
    List<FreelanceOffer> loadedOffers = [];
    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'freelancer_id': int.parse(userId),
          }));
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return [];
      }
      extractedData.forEach((offerData) {
        // convert publication date
        String date = offerData['date_of_publication'].substring(0, 10);
        var publicationDate = DateTime(int.parse(date.substring(0, 4)),
            int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
        // convert deadline date
        String deadline = offerData['deadline'].substring(0, 16);
        var convertedDeadline = DateTime(
            int.parse(deadline.substring(0, 4)),
            int.parse(deadline.substring(5, 7)),
            int.parse(deadline.substring(8, 10)),
            int.parse(deadline.substring(11, 13)),
            int.parse(deadline.substring(14, 16)));
        // convert birthday for user
        String birthday =
            offerData['user']['basic_detail']['birthday_date'].substring(0, 10);
        DateTime convertedBirthday = DateTime(
            int.parse(birthday.substring(0, 4)),
            int.parse(birthday.substring(5, 7)),
            int.parse(birthday.substring(8)));

        loadedOffers.add(
          FreelanceOffer(
            id: offerData['id'].toString(),
            user: UserAccount.detailedConstructor(
                BasicDetails(
                    id: offerData['user']['basic_detail']['id'].toString(),
                    firstName: offerData['user']['basic_detail']['first_name'],
                    lastName: offerData['user']['basic_detail']['last_name'],
                    gender: offerData['user']['basic_detail']['gender'],
                    birthday: convertedBirthday,
                    email: offerData['user']['basic_detail']['email'],
                    password: null,
                    phoneNumber: offerData['user']['basic_detail']
                        ['phone_number']),
                offerData['user']['educational_detail'] == null
                    ? null
                    : EducationalDetails(
                        id: offerData['user']['educational_detail']['id']
                            .toString(),
                        educationLevels: offerData['user']['educational_detail']
                            ['education'],
                        specialization: offerData['user']['educational_detail']
                            ['specialization'],
                        spokenLanguage: offerData['user']['educational_detail']
                            ['languages_known'],
                        courses: offerData['user']['educational_detail']
                            ['courses'],
                        skills: offerData['user']['educational_detail']
                            ['skills'],
                        pdf: offerData['educational_detail']['c_v'] == null
                            ? null
                            : stringToFile(
                                offerData['educational_detail']['c_v'], 'jpg'),
                        isGraduated: offerData['user']['educational_detail']
                            ['graduate']),
                offerData['user']['additional_detail'] == null
                    ? null
                    : AdditionalDetails(
                        id: offerData['user']['additional_detail']['id']
                            .toString(),
                        image: offerData['user']['additional_detail']
                                    ['image'] ==
                                null
                            ? null
                            : stringToFile(
                                offerData['user']['additional_detail']['image'],
                                'jpg'),
                        nationality: offerData['user']['additional_detail']
                            ['nationality'],
                        creditCard: offerData['user']['additional_detail']
                            ['credit_card_number'],
                        location: offerData['user']['additional_detail']
                                    ['position'] ==
                                null
                            ? null
                            : UserLocation(
                                offerData['user']['additional_detail']
                                        ['position']['latitude'] *
                                    1.0,
                                offerData['user']['additional_detail']
                                        ['position']['longitude'] *
                                    1.0,
                                offerData['user']['additional_detail']
                                    ['position']['city'],
                                offerData['user']['additional_detail']
                                    ['position']['country']),
                        accounts: offerData['user']['additional_detail']
                                    ['account'] ==
                                null
                            ? null
                            : Accounts(
                                twitter: offerData['user']['additional_detail']
                                    ['account']['twitter'],
                                facebook: offerData['user']['additional_detail']
                                    ['account']['facebook'],
                                telegram: offerData['user']['additional_detail']
                                    ['account']['telegram'],
                                instagram: offerData['user']['additional_detail']
                                    ['account']['instagram'],
                                linkedin: offerData['user']['additional_detail']
                                    ['account']['linkedin'],
                                gmail: offerData['user']['additional_detail']
                                    ['account']['gmail']),
                      ),
                offerData['user']['id'].toString()),
            dateOfPublication: publicationDate,
            title: offerData['title'],
            description: offerData['description'],
            image: offerData['image'] == null
                ? null
                : stringToFile(offerData['image'], 'jpg'),
            wage: offerData['wage'] * 1.0,
            deadLine: convertedDeadline,
            skills: offerData['skills'],
            favorite: offerData['favorite'],
          ),
        );
      });
      if (url == '$ipAddress/freelancer/favorite_frjob_offer') {
        _favoriteList = loadedOffers.reversed.toList();
      } else if (url == '$ipAddress/freelancer/get_applied_frJob') {
        _requests = loadedOffers.reversed.toList();
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  // FREELANCER CANCEL REQUESTES HE SENT
  Future<void> deleteRequest(String userId, String offerId) async {
    final url = '$ipAddress/delete/freelancer/freelancer_job_offer';
    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'freelancer_id': userId,
            'freelance_job_offer_id': offerId,
          }));
      print(response.statusCode);
      if (response.statusCode == 200) {
        _requests.removeWhere((offer) => offer.id == offerId);
        notifyListeners();
      } else {
        throw HttpExceptions('Could not cancel right now try later');
      }
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  //FIND OFFER BY ID
  FreelanceOffer findById(String id) {
    return _freelanceOfferItem.firstWhere((offer) => offer.id == id);
  }

  // SEARCH ABOUT SOMETHING
  Future<void> searchAboutOffers(String title, String freelancerId) async {
    final url = '$ipAddress/freelancer/search';
    try {
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode(
            {
              'id': int.parse(freelancerId),
              'title': title,
            },
          ));
      final List<FreelanceOffer> loadedData = [];
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return [];
      }
      extractedData.forEach((offerData) {
        String datePub = offerData['date_of_publication'].substring(0, 10);
        var publicationDate = DateTime(
            int.parse(datePub.substring(0, 4)),
            int.parse(datePub.substring(5, 7)),
            int.parse(datePub.substring(8)));
        String date =
            offerData['user']['basic_detail']['birthday_date'].substring(0, 10);
        DateTime birthday = DateTime(int.parse(date.substring(0, 4)),
            int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
        // convert deadline date
        String deadline = offerData['deadline'].substring(0, 16);
        DateTime convertedDeadline = DateTime(
            int.parse(deadline.substring(0, 4)),
            int.parse(deadline.substring(5, 7)),
            int.parse(deadline.substring(8, 10)),
            int.parse(deadline.substring(11, 13)),
            int.parse(deadline.substring(14, 16)));
        print('deadline loadedData');
        loadedData.add(
          FreelanceOffer(
              id: offerData['id'].toString(),
              user: UserAccount.detailedConstructor(
                  BasicDetails(
                      id: offerData['user']['basic_detail']['id'].toString(),
                      firstName: offerData['user']['basic_detail']
                          ['first_name'],
                      lastName: offerData['user']['basic_detail']['last_name'],
                      gender: offerData['user']['basic_detail']['gender'],
                      birthday: birthday,
                      email: offerData['user']['basic_detail']['email'],
                      password: null,
                      phoneNumber: offerData['user']['basic_detail']
                          ['phone_number']),
                  offerData['user']['educational_detail'] == null
                      ? null
                      : EducationalDetails(
                          id: offerData['user']['educational_detail']['id']
                              .toString(),
                          educationLevels: offerData['user']
                              ['educational_detail']['education'],
                          specialization: offerData['user']
                              ['educational_detail']['specialization'],
                          spokenLanguage: offerData['user']
                              ['educational_detail']['languages_known'],
                          courses: offerData['user']['educational_detail']
                              ['courses'],
                          skills: offerData['user']['educational_detail']
                              ['skills'],
                          pdf: offerData['educational_detail']['c_v'] == null
                              ? null
                              : stringToFile(
                                  offerData['educational_detail']['c_v'],
                                  'jpg'),
                          isGraduated: offerData['user']['educational_detail']
                              ['graduate']),
                  offerData['user']['additional_detail'] == null
                      ? null
                      : AdditionalDetails(
                          id: offerData['user']['additional_detail']['id']
                              .toString(),
                          image: offerData['user']['additional_detail']
                                      ['image'] ==
                                  null
                              ? null
                              : stringToFile(
                                  offerData['user']['additional_detail']
                                      ['image'],
                                  'jpg'),
                          nationality: offerData['user']['additional_detail']
                              ['nationality'],
                          creditCard: offerData['user']['additional_detail']
                              ['credit_card_number'],
                          location: offerData['user']['additional_detail']
                                      ['position'] ==
                                  null
                              ? null
                              : UserLocation(
                                  offerData['user']['additional_detail']
                                          ['position']['latitude'] *
                                      1.0,
                                  offerData['user']['additional_detail']
                                          ['position']['longitude'] *
                                      1.0,
                                  offerData['user']['additional_detail']
                                      ['position']['city'],
                                  offerData['user']['additional_detail']
                                      ['position']['country']),
                          accounts: offerData['user']['additional_detail']['account'] == null
                              ? null
                              : Accounts(
                                  twitter: offerData['user']['additional_detail']
                                      ['account']['twitter'],
                                  facebook: offerData['user']['additional_detail']
                                      ['account']['facebook'],
                                  telegram: offerData['user']['additional_detail']
                                      ['account']['telegram'],
                                  instagram: offerData['user']
                                          ['additional_detail']['account']
                                      ['instagram'],
                                  linkedin: offerData['user']
                                          ['additional_detail']['account']
                                      ['linkedin'],
                                  gmail: offerData['user']['additional_detail']
                                      ['account']['gmail']),
                        ),
                  offerData['user']['id'].toString()),
              dateOfPublication: publicationDate,
              title: offerData['title'],
              description: offerData['description'],
              image: offerData['image'] == null
                  ? null
                  : stringToFile(offerData['image'], 'jpg'),
              wage: (offerData['wage'] as int).toDouble(),
              deadLine: convertedDeadline,
              skills: offerData['skills'],
              favorite: offerData['favorite']),
        );
      });
      _freelanceOfferItem = loadedData.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  //ADD NEW OFFER
  Future<void> addOffer(FreelanceOffer freelanceOffer, UserAccount user) async {
    final url = '$ipAddress/user/add/frjob';
    print('is image null??');
    print(freelanceOffer.image == null);
    try {
      await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'user_id': int.parse(user.userId),
            'title': freelanceOffer.title,
            'description': freelanceOffer.description,
            'image': freelanceOffer.image == null
                ? null
                : fileToString(freelanceOffer.image),
            'wage': freelanceOffer.wage,
            'deadline': freelanceOffer.deadLine.toIso8601String(),
            'skills': freelanceOffer.skills,
          }));
      _freelanceOfferItem.add(freelanceOffer);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  // EDIT EXISTED OFFER
  Future<void> editOffer(String offerId, FreelanceOffer newOffer) async {
    final offerIndex =
        _freelanceOfferItem.indexWhere((offer) => offer.id == offerId);
    print(offerIndex);
    if (offerIndex >= 0) {
      try {
        final url = '$ipAddress/user/edit/frjob';
        await http.post(Uri.parse(url),
            headers: <String, String>{'Content-Type': 'application/json'},
            body: json.encode({
              'id_fr_job': int.parse(newOffer.id),
              'title': newOffer.title,
              'description': newOffer.description,
              'image':
                  newOffer.image == null ? null : fileToString(newOffer.image),
              'wage': newOffer.wage,
              'deadline': newOffer.deadLine.toIso8601String(),
              'skills': newOffer.skills
            }));
        _freelanceOfferItem[offerIndex] = newOffer;
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    } else {
      print('there is no job with this id');
    }
  }

  // FETCH OFFERS
  Future<void> fetchAndSetOffers(String urlFetchOffer, String userId) async {
    try {
      print('userID in Fetch');
      print(userId);
      final response = await http.post(Uri.parse(urlFetchOffer),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'id': userId == null ? null : int.parse(userId),
          }));
      final List<FreelanceOffer> loadedData = [];
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return [];
      }
      extractedData.forEach((offerData) {
        String datePub = offerData['date_of_publication'].substring(0, 10);
        var publicationDate = DateTime(
            int.parse(datePub.substring(0, 4)),
            int.parse(datePub.substring(5, 7)),
            int.parse(datePub.substring(8)));
        String date =
            offerData['user']['basic_detail']['birthday_date'].substring(0, 10);
        DateTime birthday = DateTime(int.parse(date.substring(0, 4)),
            int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
        // convert deadline date
        String deadline = offerData['deadline'] == null
            ? null
            : offerData['deadline'].substring(0, 16);
        DateTime convertedDeadline = deadline == null
            ? null
            : DateTime(
                int.parse(deadline.substring(0, 4)),
                int.parse(deadline.substring(5, 7)),
                int.parse(deadline.substring(8, 10)),
                int.parse(deadline.substring(11, 13)),
                int.parse(deadline.substring(14, 16)));
        print('deadline loadedData');
        loadedData.add(
          FreelanceOffer(
              id: offerData['id'].toString(),
              user: UserAccount.detailedConstructor(
                  BasicDetails(
                      id: offerData['user']['basic_detail']['id'].toString(),
                      firstName: offerData['user']['basic_detail']
                          ['first_name'],
                      lastName: offerData['user']['basic_detail']['last_name'],
                      gender: offerData['user']['basic_detail']['gender'],
                      birthday: birthday,
                      email: offerData['user']['basic_detail']['email'],
                      password: null,
                      phoneNumber: offerData['user']['basic_detail']
                          ['phone_number']),
                  offerData['user']['educational_detail'] == null
                      ? null
                      : EducationalDetails(
                          id: offerData['user']['educational_detail']['id']
                              .toString(),
                          educationLevels: offerData['user']
                              ['educational_detail']['education'],
                          specialization: offerData['user']
                              ['educational_detail']['specialization'],
                          spokenLanguage: offerData['user']
                              ['educational_detail']['languages_known'],
                          courses: offerData['user']['educational_detail']
                              ['courses'],
                          skills: offerData['user']['educational_detail']
                              ['skills'],
                          pdf: offerData['educational_detail']['c_v'] == null
                              ? null
                              : stringToFile(
                                  offerData['educational_detail']['c_v'],
                                  'jpg'),
                          isGraduated: offerData['user']['educational_detail']
                              ['graduate']),
                  offerData['user']['additional_detail'] == null
                      ? null
                      : AdditionalDetails(
                          id: offerData['user']['additional_detail']['id']
                              .toString(),
                          image: offerData['user']['additional_detail']
                                      ['image'] ==
                                  null
                              ? null
                              : stringToFile(
                                  offerData['user']['additional_detail']
                                      ['image'],
                                  'jpg'),
                          nationality: offerData['user']['additional_detail']
                              ['nationality'],
                          creditCard: offerData['user']['additional_detail']
                              ['credit_card_number'],
                          location: offerData['user']['additional_detail']
                                      ['position'] ==
                                  null
                              ? null
                              : UserLocation(
                                  offerData['user']['additional_detail']
                                          ['position']['latitude'] *
                                      1.0,
                                  offerData['user']['additional_detail']
                                          ['position']['longitude'] *
                                      1.0,
                                  offerData['user']['additional_detail']
                                      ['position']['city'],
                                  offerData['user']['additional_detail']
                                      ['position']['country']),
                          accounts: offerData['user']['additional_detail']['account'] == null
                              ? null
                              : Accounts(
                                  twitter: offerData['user']['additional_detail']
                                      ['account']['twitter'],
                                  facebook: offerData['user']['additional_detail']
                                      ['account']['facebook'],
                                  telegram: offerData['user']['additional_detail']
                                      ['account']['telegram'],
                                  instagram: offerData['user']
                                          ['additional_detail']['account']
                                      ['instagram'],
                                  linkedin: offerData['user']
                                          ['additional_detail']['account']
                                      ['linkedin'],
                                  gmail: offerData['user']['additional_detail']
                                      ['account']['gmail']),
                        ),
                  offerData['user']['id'].toString()),
              dateOfPublication: publicationDate,
              title: offerData['title'],
              description: offerData['description'],
              image: offerData['image'] == null
                  ? null
                  : stringToFile(offerData['image'], 'jpg'),
              wage: (offerData['wage'] as int).toDouble(),
              deadLine: convertedDeadline,
              skills: offerData['skills'],
              favorite: offerData['favorite']),
        );
      });
      _freelanceOfferItem = loadedData.reversed.toList();
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> addFreelanceFilter(
      String freelancerId, String date, String wage) async {
    final url = '$ipAddress/filter/frjoboffer';
    Range range;
    if (wage != null) {
      range = wage.contains('-')
          ? Range(num.parse(wage.substring(0, wage.indexOf('\$'))),
              num.parse(wage.substring(wage.indexOf('-') + 2, wage.length - 1)))
          : wage.contains('Less')
              ? Range(0, num.parse(wage.substring(10, wage.length - 1)))
              : wage.contains('More')
                  ? Range(
                      num.parse(wage.substring(10, wage.length - 1)), 100000)
                  : null;
    }

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

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(
          {
            'freelancer_id': int.parse(freelancerId),
            'publish_date': publishDate,
            'wage': range == null
                ? null
                : {
                    'from': range.from,
                    'to': range.to,
                  }
          },
        ),
      );
      final List<FreelanceOffer> loadedData = [];
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return [];
      }
      extractedData.forEach((offerData) {
        String datePub = offerData['date_of_publication'].substring(0, 10);
        var publicationDate = DateTime(
            int.parse(datePub.substring(0, 4)),
            int.parse(datePub.substring(5, 7)),
            int.parse(datePub.substring(8)));
        String date =
            offerData['user']['basic_detail']['birthday_date'].substring(0, 10);
        DateTime birthday = DateTime(int.parse(date.substring(0, 4)),
            int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
        // convert deadline date
        String deadline = offerData['deadline'].substring(0, 16);
        DateTime convertedDeadline = DateTime(
            int.parse(deadline.substring(0, 4)),
            int.parse(deadline.substring(5, 7)),
            int.parse(deadline.substring(8, 10)),
            int.parse(deadline.substring(11, 13)),
            int.parse(deadline.substring(14, 16)));
        print('deadline loadedData');
        loadedData.add(
          FreelanceOffer(
              id: offerData['id'].toString(),
              user: UserAccount.detailedConstructor(
                  BasicDetails(
                      id: offerData['user']['basic_detail']['id'].toString(),
                      firstName: offerData['user']['basic_detail']
                          ['first_name'],
                      lastName: offerData['user']['basic_detail']['last_name'],
                      gender: offerData['user']['basic_detail']['gender'],
                      birthday: birthday,
                      email: offerData['user']['basic_detail']['email'],
                      password: null,
                      phoneNumber: offerData['user']['basic_detail']
                          ['phone_number']),
                  offerData['user']['educational_detail'] == null
                      ? null
                      : EducationalDetails(
                          id: offerData['user']['educational_detail']['id']
                              .toString(),
                          educationLevels: offerData['user']
                              ['educational_detail']['education'],
                          specialization: offerData['user']
                              ['educational_detail']['specialization'],
                          spokenLanguage: offerData['user']
                              ['educational_detail']['languages_known'],
                          courses: offerData['user']['educational_detail']
                              ['courses'],
                          skills: offerData['user']['educational_detail']
                              ['skills'],
                          pdf: offerData['educational_detail']['c_v'] == null
                              ? null
                              : stringToFile(
                                  offerData['educational_detail']['c_v'],
                                  'jpg'),
                          isGraduated: offerData['user']['educational_detail']
                              ['graduate']),
                  offerData['user']['additional_detail'] == null
                      ? null
                      : AdditionalDetails(
                          id: offerData['user']['additional_detail']['id']
                              .toString(),
                          image: offerData['user']['additional_detail']
                                      ['image'] ==
                                  null
                              ? null
                              : stringToFile(
                                  offerData['user']['additional_detail']
                                      ['image'],
                                  'jpg'),
                          nationality: offerData['user']['additional_detail']
                              ['nationality'],
                          creditCard: offerData['user']['additional_detail']
                              ['credit_card_number'],
                          location: offerData['user']['additional_detail']
                                      ['position'] ==
                                  null
                              ? null
                              : UserLocation(
                                  offerData['user']['additional_detail']
                                          ['position']['latitude'] *
                                      1.0,
                                  offerData['user']['additional_detail']
                                          ['position']['longitude'] *
                                      1.0,
                                  offerData['user']['additional_detail']
                                      ['position']['city'],
                                  offerData['user']['additional_detail']
                                      ['position']['country']),
                          accounts: offerData['user']['additional_detail']['account'] == null
                              ? null
                              : Accounts(
                                  twitter: offerData['user']['additional_detail']
                                      ['account']['twitter'],
                                  facebook: offerData['user']['additional_detail']
                                      ['account']['facebook'],
                                  telegram: offerData['user']['additional_detail']
                                      ['account']['telegram'],
                                  instagram: offerData['user']
                                          ['additional_detail']['account']
                                      ['instagram'],
                                  linkedin: offerData['user']
                                          ['additional_detail']['account']
                                      ['linkedin'],
                                  gmail: offerData['user']['additional_detail']
                                      ['account']['gmail']),
                        ),
                  offerData['user']['id'].toString()),
              dateOfPublication: publicationDate,
              title: offerData['title'],
              description: offerData['description'],
              image: offerData['image'] == null
                  ? null
                  : stringToFile(offerData['image'], 'jpg'),
              wage: (offerData['wage'] as int).toDouble(),
              deadLine: convertedDeadline,
              skills: offerData['skills'],
              favorite: offerData['favorite']),
        );
      });
      print('Loaded Data');
      print(loadedData);

      _freelanceOfferItem = loadedData;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // DELETE OFFER
  Future<void> deleteOffer(String id) async {
    final url = '$ipAddress/user/delete/frjob';
    final existingOfferIndex =
        _freelanceOfferItem.indexWhere((offer) => offer.id == id);
    var existingOffer = _freelanceOfferItem[existingOfferIndex];

    _freelanceOfferItem.removeAt(existingOfferIndex);
    notifyListeners();

    final offerResponse = await http.post(Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode({
          'freelance_job_offer_id': id,
        }));

    if (offerResponse.statusCode == 400) {
      _freelanceOfferItem.insert(existingOfferIndex, existingOffer);
      notifyListeners();
      throw HttpExceptions('Could not delete this offer right now try later ');
    }

    existingOffer = null;
  }
}
