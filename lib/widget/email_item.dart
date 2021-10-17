//@dart=2.9
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../providers/accounts.dart';
import 'package:provider/provider.dart';
import '../providers/email.dart';
import '../Screens/email_screens/email_details_screen.dart';

class EmailItem extends StatefulWidget {
  final Email email;
  final Account account;

  EmailItem(this.email, this.account);

  @override
  _EmailItemState createState() => _EmailItemState();
}

class _EmailItemState extends State<EmailItem> {
  var type;
  @override
  Widget build(BuildContext context) {
    type = widget.account is CompanyAccount
        ? (widget.account as CompanyAccount).companyDetails.email
        : widget.account is FreelancerAccount
            ? '${(widget.account as FreelancerAccount).basicDetails.email}'
            : '${(widget.account as UserAccount).basicDetails.email}';
    return Container(
      // margin: EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 2),
      child: Container(
        color: widget.email.destinationEmail == 'null'
            ? Colors.white
            : Colors.grey[300],
        child: ListTile(
            title: Text(
              widget.email.name == null ? '' : widget.email.name,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: !widget.email.isRead ? FontWeight.bold : null),
            ),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    FittedBox(
                        child: Text(
                      widget.email.title.length > 40
                          ? widget.email.title.substring(0, 35)
                          : widget.email.title,
                    )),
                  ]),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                      '${DateFormat('yMMMd').format(widget.email.dateOfSending)}'),
                ]),
            onTap: () {
              print('Tap');
              Provider.of<EmailBusiness>(context, listen: false)
                  .read(widget.email.id);
              setState(() {
                widget.email.isRead = true;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EmailDetails(widget.email, widget.account)));
            },
            trailing: !widget.email.isRead
                ? CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.blue,
                  )
                : null,
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        content: GestureDetector(
                          child: widget.email.isRead
                              ? Text('Mark as Unread')
                              : Text('Mark as read'),
                          onTap: () {
                            Provider.of<EmailBusiness>(context, listen: false)
                                .read(widget.email.id);
                            setState(() {
                              widget.email.isRead = !widget.email.isRead;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ));
            }),
      ),
    );
  }
}
