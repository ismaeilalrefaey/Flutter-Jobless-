//@dart=2.9
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../global_stuff.dart';
import 'dart:convert';

import '../models/http_exceptions.dart';

class Email with ChangeNotifier {
  final String id;
  final String name;
  final String title;
  final String body;
  final DateTime dateOfSending;
  //from
  final String fromUserID;
  final String fromFreelancerID;
  final String fromCompanyID;
  //to
  final String destinationEmail;
  bool isRead = false;

  Email(
      {@required this.id,
      @required this.name,
      @required this.title,
      @required this.body,
      @required this.dateOfSending,
      @required this.fromUserID,
      @required this.fromFreelancerID,
      @required this.fromCompanyID,
      @required this.destinationEmail,
      this.isRead});
}

class EmailBusiness with ChangeNotifier {
  List<Email> _emails = [];

  List<Email> get emails {
    return [..._emails];
  }

  Future<void> read(String emailId) async {
    final url = '$ipAddress/change_read';
    try {
      await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'id': int.parse(emailId),
          }));
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> sendEmail(Email email) async {
    final url = '$ipAddress/new_message';
    print(email.body);
    print(email.dateOfSending);
    print(email.fromCompanyID);
    print(email.fromFreelancerID);
    print(email.fromUserID);
    try {
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'name': email.name,
            'title': email.title,
            'body': email.body,
            'email': email.destinationEmail,
            'from_user_id':
                email.fromUserID == null ? null : int.parse(email.fromUserID),
            'from_company_id': email.fromCompanyID == null
                ? null
                : int.parse(email.fromCompanyID),
            'from_freelancer_id': email.fromFreelancerID == null
                ? null
                : int.parse(email.fromFreelancerID),
            // 'date_of_sending': email.dateOfSending.toIso8601String()
          }));
      if (response.statusCode == 404) {
        throw HttpExceptions('something went wrong');
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // FETCH A MESSAGE
  Future<void> fetchMessage(String userId, String accountType) async {
    print('user id: $userId');
    print('account type: $accountType');
    final url = '$ipAddress/get_all_messages';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode({
          'id': int.parse(userId),
          'type_of_account': accountType,
        }),
      );
      final extractedEmails = json.decode(response.body);
      print(extractedEmails.toString());
      final List<Email> loadedEmails = [];
      if (extractedEmails == null || extractedEmails.isEmpty) {
        return [];
      }
      extractedEmails.forEach((email) {
        String date = email['date_of_send'].substring(0, 10);
        var dateOfSending = DateTime(int.parse(date.substring(0, 4)),
            int.parse(date.substring(5, 7)), int.parse(date.substring(8)));
        loadedEmails.add(
          Email(
            id: email['id'].toString(),
            name: email['name'],
            body: email['body'],
            title: email['title'],
            isRead: email['is_read'],
            dateOfSending: dateOfSending,
            fromUserID: email['fromUserID'].toString(),
            fromCompanyID: email['fromCompanyID'].toString(),
            fromFreelancerID: email['fromFreelancerID'].toString(),
            destinationEmail: email['toEmail'].toString(),
          ),
        );
      });
      _emails = loadedEmails.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
