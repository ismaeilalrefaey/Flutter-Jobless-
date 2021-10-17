//@dart=2.9
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/accounts.dart';
import '../Screens/job_applicant.dart';
import '../providers/freelance_offer.dart';
import '../Screens/freelancer_offer_detail.dart';

class FreelanceOfferItem extends StatefulWidget {
  final FreelanceOffer freelanceOffer;
  final Account user;
  final int mark;
  final bool isGuest;

  FreelanceOfferItem(this.freelanceOffer, this.user, this.mark, this.isGuest);

  @override
  _FreelanceOfferItemState createState() => _FreelanceOfferItemState();
}

class _FreelanceOfferItemState extends State<FreelanceOfferItem> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final deviceSize = MediaQuery.of(context).size;
    final scaffold = ScaffoldMessenger.of(context);
    return Container(
      height: !isLandscape ? deviceSize.height * 0.25 : deviceSize.height * 0.4,
      child: Card(
        margin: EdgeInsets.all(8),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: GestureDetector(
            child: CircleAvatar(
              child: widget.freelanceOffer.image == null ? Icon(Icons.person) : Image.file(widget.freelanceOffer.image,
                                width: 100,
                                height: 100,fit: BoxFit.fill,),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(JobApplicant.routeName,
                  arguments: {
                    'user': widget.user,
                    'job': widget.freelanceOffer,
                    'mark': 'Browsing'
                  });
            },
          ), //child: Image.file(freelanceOffer.image),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.freelanceOffer.title,
                style: TextStyle(fontSize: 25),
              ),
              // Spacer(),
              widget.isGuest
                  ? Text('')
                  : IconButton(
                      icon: widget.mark == null
                          ? Icon(widget.freelanceOffer.favorite
                              ? Icons.favorite
                              : Icons.favorite_border)
                          : Icon(
                              Icons.cancel), // FittedBox(child: Text('Cancel'))
                      onPressed: widget.mark == null
                          ? () {
                              Provider.of<FreelanceOfferBusiness>(context,
                                      listen: false)
                                  .toggle(widget.user.userId,
                                      widget.freelanceOffer.id);
                              setState(() {
                                widget.freelanceOffer.favorite =
                                    !widget.freelanceOffer.favorite;
                              });
                              scaffold.showSnackBar(
                                SnackBar(
                                  content: widget.freelanceOffer.favorite
                                      ? Text('Removed from favorite ')
                                      : Text('Added to favorite '),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          : () {
                              return showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Are you sure'),
                                  content: Text(
                                      'Do you want to cancel this offer request ? '),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop(false);
                                        },
                                        child: Text('No')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop(true);
                                          Provider.of<FreelanceOfferBusiness>(
                                                  context,
                                                  listen: false)
                                              .deleteRequest(widget.user.userId,
                                                  widget.freelanceOffer.id);
                                        },
                                        child: Text('Yes')),
                                  ],
                                ),
                              );
                            },
                    ),
            ],
          ),
          subtitle: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '\$${(widget.freelanceOffer.wage)}',
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.freelanceOffer.deadLine == null
                        ? ''
                        : 'Deadline:\n${(widget.freelanceOffer.deadLine)}',
                    style: TextStyle(fontSize: 17),
                  ),
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'pubplication date: ${(DateFormat('yMMMd').format(widget.freelanceOffer.dateOfPublication))}',
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
          ]),

          onTap: () {
            Navigator.of(context)
                .pushNamed(FreelancerOfferDetail.routeName, arguments: {
              'id': widget.freelanceOffer.id,
              'guest': widget.isGuest,
            });
          },
        ),
      ),
    );
  }
}
