// @dart=2.9
import 'package:provider/provider.dart';

import '../global_stuff.dart';
import 'package:flutter/material.dart';
import '../providers/employment_details.dart';

class EmploymentDetailsItem extends StatelessWidget {
  final EmploymentDetails emp;
  EmploymentDetailsItem(this.emp);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
      ),
      // onDismissed: (direction) async {
      //   Provider.of<EmploymentDetailsProvider>(context, listen: false)
      //       .delete(emp.id);
      // },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure'),
            content:
                Text('Do you want to remove the experience from the list '),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text('No')),
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                    Provider.of<EmploymentDetailsProvider>(context,
                            listen: false)
                        .delete(emp.id);
                  },
                  child: Text('Yes')),
            ],
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          leading: CircleAvatar(child: null), // Company's image
          title: Text(emp.jobTitle),
          trailing: Text('${emp.jobLocation.city}, ${emp.jobLocation.country}'),
          subtitle:
              Text('From: ${dateParser(emp.from)}\nTo: ${dateParser(emp.to)}'),
        ),
      ),
    );
  }
}
