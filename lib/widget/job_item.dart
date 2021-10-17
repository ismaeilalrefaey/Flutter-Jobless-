// @dart=2.9

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/job.dart';
import '../providers/accounts.dart';
import '../Screens/job_details.dart';
import '../providers/job_business.dart';

class JobItem extends StatefulWidget {
  final Job job;
  final Account user;
  final int mark;
  final bool isGuest;
  JobItem(this.job, this.user, this.mark, this.isGuest);

  @override
  _JobItemState createState() => _JobItemState();
}

class _JobItemState extends State<JobItem> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final deviceSize = MediaQuery.of(context).size;
    final scaffold = ScaffoldMessenger.of(context);
    return Container(
      height: !isLandscape ? deviceSize.height * 0.2 : deviceSize.height * 0.35,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: GestureDetector(
            child: CircleAvatar(
              child: widget.job.image == null ? Icon(Icons.person) : Image.file(widget.job.image,
                                width: 100,
                                height: 100,fit: BoxFit.fill,),
            ),
          ), //child: Image.file(freelanceOffer.image),
          onTap: () {
            // Navigator.of(context)
            //     .pushNamed(JobDetails.routeName, arguments: widget.job.id);
            Navigator.of(context).pushNamed(JobDetails.routeName, arguments: {
              'id': widget.job.id,
              // yroro
              // 'mark': widget.mark == null ? 'Approval' : 'Browse',
              'mark': !widget.isGuest && widget.mark == null
                  ? 'Approval'
                  : 'Browse',
              'job': widget.job,
            });
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FittedBox(
                child: Text(
                  widget.job.title,
                  // style: TextStyle(fontSize: 16),
                ),
              ),
              // Spacer(),
              widget.isGuest
                  ? Text('')
                  : IconButton(
                      onPressed: widget.mark == null
                          ? () {
                              Provider.of<JobBusiness>(context, listen: false)
                                  .toggle(widget.user.userId, widget.job.id);
                              setState(() {
                                widget.job.favorite = !widget.job.favorite;
                              });
                              scaffold.showSnackBar(
                                SnackBar(
                                  content: widget.job.favorite
                                      ? Text('Removed from favorites')
                                      : Text('Added to favorites'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          : () {
                              return showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Are you sure?'),
                                  content: Text(
                                      'Do you really want to cancel this job request ? '),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop(false);
                                        },
                                        child: Text('No')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop(true);
                                          Provider.of<JobBusiness>(context,
                                                  listen: false)
                                              .deleteRequest(widget.user.userId,
                                                  widget.job.id);
                                        },
                                        child: Text('Yes')),
                                  ],
                                ),
                              );
                            },
                      icon: widget.mark == null
                          ? Icon(widget.job.favorite
                              ? Icons.favorite
                              : Icons.favorite_border)
                          : Icon(Icons.cancel),
                    ),
            ],
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${widget.job.salary}\$' ?? '',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    widget.job.jobCondition == null ||
                            widget.job.jobCondition.country == null
                        ? ''
                        : widget.job.jobCondition.country,
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    '${(widget.job.durationOfJob)} Hours' ?? '',
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'pubplication date: ${(DateFormat('yMMMd').format(widget.job.dateOfPublication))}' ??
                        '',
                    // 'Published ${DateTime.now().difference(other) ago}',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
