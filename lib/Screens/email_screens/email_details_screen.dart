//@dart=2.9
import 'package:flutter/material.dart';
import '../../providers/accounts.dart';

import 'sending_email_screen.dart';
import '../../providers/email.dart';

class EmailDetails extends StatelessWidget {
  final Email _email;
  final Account account;

  EmailDetails(this._email, this.account);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back)),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            SendingEmailScreen.routeName,
                            arguments: {
                              'account': account,
                              'email': _email.destinationEmail
                            });
                      },
                      child: Text('Reply', style: TextStyle(fontSize: 18))),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: <Widget>[
                  SizedBox(width: 10),
                  FittedBox(
                      child: Text(
                    '${_email.name}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                ],
              ),
              SizedBox(height: 20),
              Text(_email.title, style: TextStyle(fontSize: 22)),
              SizedBox(height: 10),
              Text(
                _email.body,
                style: TextStyle(fontSize: 17),
                maxLines: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
