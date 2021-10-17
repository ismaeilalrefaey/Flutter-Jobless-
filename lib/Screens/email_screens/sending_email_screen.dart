//@dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/email.dart';
import '../../providers/accounts.dart';

class SendingEmailScreen extends StatefulWidget {
  static const routeName = 'sending-email';
  @override
  _SendingEmailScreenState createState() => _SendingEmailScreenState();
}

class _SendingEmailScreenState extends State<SendingEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Account account;
  String senderName;
  String destinationEmail;
  String senderEmail;
  String fromUserId, fromFreelancerId, fromCompanyId;
  var _isInit = true;
  var _initialVaue = {
    'senderEmail': '',
    'destinationEmail': '',
  };
  Email email = Email(
      id: null,
      name: '',
      title: '',
      body: '',
      dateOfSending: DateTime.now(),
      fromUserID: null,
      fromFreelancerID: null,
      fromCompanyID: null,
      destinationEmail: null);

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var data =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      destinationEmail = data == null ? '' : data['email'];
      account = data == null ? null : data['account'];
      if (account != null && account is UserAccount) {
        fromUserId = account.userId;
        senderName =
            '${(account as UserAccount).basicDetails.firstName} ${(account as UserAccount).basicDetails.lastName}';
        senderEmail = (account as UserAccount).basicDetails.email;
      } else if (account != null && account is FreelancerAccount) {
        fromFreelancerId = account.userId;
        senderName =
            '${(account as FreelancerAccount).basicDetails.firstName} ${(account as FreelancerAccount).basicDetails.lastName}';
        senderEmail = (account as FreelancerAccount).basicDetails.email;
      } else if (account != null && account is CompanyAccount) {
        fromCompanyId = account.userId;
        senderName = '${(account as CompanyAccount).companyDetails.name}';
        senderEmail = (account as CompanyAccount).companyDetails.email;
      }
      _initialVaue = {
        'senderEmail': senderEmail == null ? '' : senderEmail,
        'destinationEmail': destinationEmail == null ? '' : destinationEmail,
      };
      email = Email(
          id: null,
          name: senderName,
          title: '',
          body: '',
          dateOfSending: DateTime.now(),
          fromUserID: fromUserId,
          fromFreelancerID: fromFreelancerId,
          fromCompanyID: fromCompanyId,
          destinationEmail: destinationEmail);
    }
    super.didChangeDependencies();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred !!'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      print('Invalid!');
      return;
    }
    _formKey.currentState.save();
    try {
      // sending email to database
      Provider.of<EmailBusiness>(context, listen: false).sendEmail(email);
    } catch (error) {
      _showErrorDialog(error.toString());
    }
    Navigator.of(context, rootNavigator: true).pop(context);
  }

  Widget textField(String hint, String initialVal,
      TextInputAction textInputAction, Function validator, Function onSaved) {
    return TextFormField(
      initialValue: initialVal,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: hint == 'Subject' ? null : hint,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        hintText: hint == 'Subject' ? hint : null,
        hintStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      textInputAction: textInputAction,
      keyboardType: (hint == 'From' || hint == 'To')
          ? TextInputType.emailAddress
          : TextInputType.multiline,
      minLines: 1,
      maxLines: 40,
      validator: validator,
      onSaved: onSaved,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
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
                    Text(
                      'Compose',
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    IconButton(onPressed: _submit, icon: Icon(Icons.send))
                  ],
                ),
                textField(
                    'From', _initialVaue['senderEmail'], TextInputAction.next,
                    (value) {
                  if (value.isEmpty) return 'This field can\'t be empty !!';
                  return null;
                }, (value) {
                  email = Email(
                      id: null,
                      name: email.name,
                      title: email.title,
                      body: email.body,
                      dateOfSending: email.dateOfSending,
                      fromUserID: email.fromUserID,
                      fromFreelancerID: email.fromFreelancerID,
                      fromCompanyID: email.fromCompanyID,
                      destinationEmail: email.destinationEmail);
                }),
                Divider(),
                textField('To', _initialVaue['destinationEmail'],
                    TextInputAction.next, (value) {
                  if (value.isEmpty) return 'This field can\'t be empty !!';
                  return null;
                }, (value) {
                  email = Email(
                      id: null,
                      name: email.name,
                      title: email.title,
                      body: email.body,
                      dateOfSending: DateTime.now(),
                      fromUserID: email.fromUserID,
                      fromFreelancerID: email.fromFreelancerID,
                      fromCompanyID: email.fromCompanyID,
                      destinationEmail: value);
                }),
                Divider(),
                textField('Title', '', TextInputAction.next, (value) {
                  if (value.isEmpty) return 'This field can\'t be empty !!';
                  return null;
                }, (value) {
                  email = Email(
                      id: null,
                      name: email.name,
                      title: value,
                      body: email.body,
                      dateOfSending: email.dateOfSending,
                      fromUserID: email.fromUserID,
                      fromFreelancerID: email.fromFreelancerID,
                      fromCompanyID: email.fromCompanyID,
                      destinationEmail: email.destinationEmail);
                }),
                Divider(),
                textField('Subject', '', TextInputAction.done, (value) {
                  if (value.isEmpty) return 'This field can\'t be empty !!';
                  return null;
                }, (value) {
                  email = Email(
                      id: null,
                      name: email.name,
                      title: email.title,
                      body: value,
                      dateOfSending: email.dateOfSending,
                      fromUserID: email.fromUserID,
                      fromFreelancerID: email.fromFreelancerID,
                      fromCompanyID: email.fromCompanyID,
                      destinationEmail: email.destinationEmail);
                }),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
