//@dart=2.9

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../global_stuff.dart';
import '../providers/accounts.dart';
import '../services/world_locations.dart';

enum AccountType {
  User,
  Admin,
  Company,
  Freelancer,
}

class Authentication with ChangeNotifier {
  Account object;
  Timer _expiryTimer;
  DateTime _expiryDate;
  String _token, _userId;
  AccountType type;
  Map<String, dynamic> responseData = {
    // 'token': randomAlphaNumeric(10),
    // 'userId': randomNumeric(10),
    // 'object': {
    //   'previous_works': [],
    //   'date_of_account_creation': DateTime.now().toString(),
    //   'portfolio': null,
    //   'rate': Random().nextDouble() * 100,
    //   'basic_detail': {
    //     'id': randomAlpha(10),
    //     'email': randomAlpha(10),
    //     'gender': randomAlpha(10),
    //     'password': randomAlpha(10),
    //     'last_name': randomAlpha(10),
    //     'first_name': randomAlpha(10),
    //     'phone_number': randomAlpha(10),
    //     'birthday_date': DateTime.now().toString(),
    //   },
    //   'educational_detail': {
    //     'graduate': true,
    //     'id': randomAlpha(10),
    //     'c_v': null, // randomAlpha(10),
    //     'skills': randomAlpha(10),
    //     'courses': randomAlpha(10),
    //     'education': randomAlpha(10),
    //     'specialization': randomAlpha(10),
    //     'languages_known': randomAlpha(10),
    //   },
    //   'additional_detail': {
    //     'accounts': null,
    //     'id': randomAlpha(10),
    //     'nationality': randomAlpha(10),
    //     'image': [6, 7, 3, 2].toString(),
    //     'credit_card_number': randomAlpha(10),
    //     'location': {
    //       'city': randomAlpha(10),
    //       'country': randomAlpha(10),
    //       'latitude': Random().nextDouble() * 180,
    //       'longitude': Random().nextDouble() * 360,
    //     },
    //   },
    // }
  };

  String get userId => _userId;
  AccountType get accountType => type;
  bool get isAuthenticated => token != null;
  Account get authenticatedAccount => object;
  Map<String, dynamic> get response => responseData;

  String get token {
    if (_expiryDate != null &&
        _token != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_expiryTimer != null) {
      _expiryTimer.cancel();
      _expiryTimer = null;
    }
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  void autoLogout() {
    if (_expiryTimer != null) _expiryTimer.cancel();
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _expiryTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<Account> _authenticate(
      Map<String, String> data, String modeSegment, String choice) async {
    getLocations();
    final url = '$ipAddress$modeSegment';
    print('URL: $url');
    try {
      var body = {};
      if (modeSegment.contains('login')) {
        if (data['email'] != null) {
          body = {
            'email': data['email'],
            'password': data['password'],
          };
        } else {
          body = {
            'login_id': data['login_id'],
            'password': data['password'],
          };
        }
      } else {
        body = {
          'email': data['email'],
          'password': data['password'],
        };
        if (modeSegment.contains('company')) {
          body['name'] = data['name'];
        } else {
          body['first_name'] = data['first_name'];
          body['last_name'] = data['last_name'];
          body['birthday'] = '${data['year']}-${data['month']}-${data['day']}';
          body['gender'] = data['gender'];
        }
      }
      print('Credentials');
      print(body);
      var jsonData = json.encode(body);
      print('JSON Data: $jsonData');
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonData,
      );
      print('\n\n\nResponse');
      // print(response.body);
      print(choice);
      if (response.statusCode == 201) {
        if (choice == 'Company') {
          throw Exception('Wait for the Admin to approve');
        }
      }
      if (response.statusCode == 400) {
        throw Exception('Already exists');
      }

      responseData = json.decode(response.body);

      print('No errors');
      _token = responseData['token'];
      _userId = responseData['userId'].toString();
      var temp = responseData['type_of_account'];
      type = temp == 4
          ? AccountType.User
          : temp == 2
              ? AccountType.Company
              : temp == 1
                  ? AccountType.Freelancer
                  : AccountType.Admin;
      this.responseData = responseData;
      object = type == AccountType.Freelancer
          ? FreelancerAccount(json.encode(responseData))
          : type == AccountType.Company
              ? CompanyAccount(json.encode(responseData))
              : type == AccountType.User
                  ? UserAccount(json.encode(responseData))
                  : null;
      print('No Errors Again');
      _expiryDate = DateTime.now().add(Duration(
          seconds: /*10*/ 3600 * 24 /*int.parse(responseData['expiresIn'])*/));
      autoLogout();
      notifyListeners();
      final preferences = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId.toString(),
        'expiryDate': _expiryDate.toIso8601String()
      });
      preferences.setString('User_Data', userData);
      print('Returned response');
      print(responseData);
      return object;
    } catch (error) {
      print('Error found in Auth');
      print(error);
      throw error;
    }
  }

  Future<void> signup(
          Map<String, String> data, String modeSegment, String choice) async =>
      _authenticate(data, modeSegment, choice);

  Future<void> login(Map<String, String> data, String modeSegment) async =>
      _authenticate(data, modeSegment, '');

  Future<bool> tryAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('User_Data')) return false;
    print('Found some local user data !!');
    final extractedData =
        json.decode(preferences.getString('User_Data')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return false;
    print('Haven\'t reached the expiry date yet');
    _expiryDate = expiryDate;
    _token = extractedData['Token'];
    _userId = extractedData['userId'];
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> deactivateAccount(String url, String accountId) async {
    try {
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'id': int.parse(accountId),
          }));
      if (response.statusCode == 200) {
        logout();
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }
}
