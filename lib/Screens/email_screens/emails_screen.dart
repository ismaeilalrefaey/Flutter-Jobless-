//@dart=2.9
import 'package:flutter/material.dart';
import '../../Screens/email_screens/sending_email_screen.dart';
import '../../providers/accounts.dart';
import 'package:provider/provider.dart';

import '../../providers/email.dart';
import '../../widget/email_item.dart';

class EmailsScreen extends StatefulWidget {
  static const routeName = 'email-screen';
  @override
  _EmailsScreenState createState() => _EmailsScreenState();
}

class _EmailsScreenState extends State<EmailsScreen> {
  var _isInit = true;
  var _isLoading = false;
  Account account;
  String accountType;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      var data =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      account = data['account'];
      accountType = data['account_type'];
      Provider.of<EmailBusiness>(context, listen: false)
          .fetchMessage(account.userId, accountType)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshEmails(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<EmailBusiness>(context, listen: false)
        .fetchMessage(account.userId, accountType)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _emails = Provider.of<EmailBusiness>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Inbox'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(SendingEmailScreen.routeName,
                      arguments: {'account': account});
                },
                icon: Icon(Icons.forward_to_inbox))
          ],
        ),
        body: _isLoading
            ? LinearProgressIndicator()
            : RefreshIndicator(
                onRefresh: () => _refreshEmails(context),
                child: Scrollbar(
                  child: ListView.builder(
                      itemCount: _emails.emails.length,
                      itemBuilder: (ctx, index) => Column(children: <Widget>[
                            EmailItem(_emails.emails[index], account),
                            Divider()
                          ])),
                ),
              ));
  }
}
