//@dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Notification {
  final String title, body, id;
  final DateTime dateOfSending;
  bool isSeen = false;
  Notification(this.id, this.title, this.body, this.dateOfSending);
}

class NotificationProvider with ChangeNotifier {
  List<Notification> _notifications = [
    Notification('1', 'title1', 'body1', DateTime.now()),
    Notification('2', 'title2', 'body2', DateTime.now()),
    Notification('3', 'title3', 'body3', DateTime.now()),
    Notification('4', 'title4', 'body4', DateTime.now()),
  ];

  List<Notification> get notifications => _notifications;

  Future<void> seen(String id) async {
    final url = '';
    try {
      await http.post(Uri.parse(url),
          body: json.encode({
            'id': id,
          }));

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> fetchAndSetNotifications(String id) async {
    final urlSend = '';
    final urlRecieve = '';
    try {
      await http.post(Uri.parse(urlSend), body: json.encode({'id': id}));
      final response = await http.get(Uri.parse(urlRecieve));
      final List<Notification> loadedNotifications = [];
      final extractedNotifications =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedNotifications == null) return;
      extractedNotifications.forEach((notificationId, notification) {
        loadedNotifications.add(
          Notification(
            notification.id,
            notification.title,
            notification.body,
            notification.dateOfSending,
          ),
        );
      });
      _notifications = loadedNotifications.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
