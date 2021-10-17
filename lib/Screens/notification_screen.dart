//@dart=2.9
import 'package:flutter/material.dart';
import '../providers/notification.dart';
import '../widget/notification_item.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  static const routeName = '/notifications-screen';

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  var _isInit = true;
  var _isLoading = false;
  String id;
  @override
  void didChangeDependencies() {
    // if (_isInit) {
    //   setState(() async {
    //     _isLoading = true;
    //     id = ModalRoute.of(context).settings.arguments as String;
    //     Provider.of<NotificationProvider>(context).fetchAndSetNotifications(id).then((_) {
    //       setState(() {
    //         _isLoading = false;
    //       });
    //     });
    //   });
    // }
    // _isInit = false;
    // super.didChangeDependencies();
  }

  Future<void> _refreshEmails(BuildContext context) async {
    // setState(() {
    //   _isLoading = true;
    // });
    // Provider.of<NotificationProvider>(context).fetchAndSetNotifications(id).then((_) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    var notifications =
        Provider.of<NotificationProvider>(context).notifications;
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (ctx, index) => Dismissible(
            key: UniqueKey(),
            child: NotificationItem(notifications[index]),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete, size: 40, color: Colors.white),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            ),
            onDismissed: (direction) {
              var temp;
              setState(() {
                temp = notifications.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item dismissed'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      setState(() {
                        notifications.insert(index, temp);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
