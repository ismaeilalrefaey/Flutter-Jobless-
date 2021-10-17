//@dart=2.9
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../providers/notification.dart' as not;

class NotificationItem extends StatefulWidget {
  // RemoteMessage message;
  final not.Notification notification;

  const NotificationItem(this.notification);
  
  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.notification.title),
      subtitle: Text(widget.notification.body),
      onTap: () {
        setState(() {
          widget.notification.isSeen = true;
        });
        // Navigator.of(context).pushReplacementNamed(
        //   widget.message.messageType,
        //   arguments: widget.message.messageId,
        // );
      },
      trailing: !widget.notification.isSeen
          ? CircleAvatar(radius: 5, backgroundColor: Colors.blue)
          : null,
    );
  }
}
