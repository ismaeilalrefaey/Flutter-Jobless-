//@dart=2.9
import 'package:flutter/material.dart';
import '../Screens/job_applicant.dart';
import '../providers/accounts.dart';

class UserItem extends StatelessWidget {
  final UserAccount userAccount;
  final Account account;
  final job;
  UserItem(this.userAccount, this.account, this.job);

  @override
  Widget build(BuildContext context) {
    print('object');
    print(userAccount.toString());
    return ListTile(
      leading: CircleAvatar(
        child: userAccount.additionalDetails == null ||
                userAccount.additionalDetails.image == null
            ? Icon(Icons.person)
            : Image.file(userAccount.additionalDetails.image),
      ),
      title: Text(
        '${userAccount.basicDetails.firstName} ${userAccount.basicDetails.lastName}',
        style: TextStyle(fontSize: 25),
      ),
      subtitle: Text('${userAccount.basicDetails.email}%'),
      onTap: () {
        Navigator.of(context).pushNamed(
          JobApplicant.routeName,
          arguments: {
            'user': userAccount,
            'job': job,
            'account': account,
            'mark': 'Approval'
          },
        );
      },
    );
  }
}
