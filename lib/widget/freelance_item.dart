//@dart=2.9
import 'package:flutter/material.dart';
import '../Screens/job_applicant.dart';
import '../providers/accounts.dart';

class FreelancerItem extends StatelessWidget {
  final FreelancerAccount freelancerAccount;
  final Account account;
  final offer;
  FreelancerItem(this.freelancerAccount, this.account, this.offer);

  @override
  Widget build(BuildContext context) {
    print('object');
    print(freelancerAccount.toString());
    return ListTile(
      leading: CircleAvatar(
        child: freelancerAccount.additionalDetails == null ||
                freelancerAccount.additionalDetails.image == null
            ? Icon(Icons.person)
            : Image.file(freelancerAccount.additionalDetails.image),
      ),
      title: Text(
        '${freelancerAccount.basicDetails.firstName} ${freelancerAccount.basicDetails.lastName}',
        style: TextStyle(fontSize: 25),
      ),
      subtitle: Text('${freelancerAccount.rate}%'),
      onTap: () {
        Navigator.of(context).pushNamed(
          JobApplicant.routeName,
          arguments: {
            'user': freelancerAccount,
            'job': offer,
            'account': account,
            'mark': 'Approval'
          },
        );
      },
    );
  }
}
