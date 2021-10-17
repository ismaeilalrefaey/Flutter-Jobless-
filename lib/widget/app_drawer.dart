//@dart=2.9

import 'package:flutter/material.dart';
import '../Screens/add_details_screens/add_new_company_job.dart';
import '../global_stuff.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../providers/auth.dart';
import '../providers/accounts.dart';
import '../Screens/favorite_user.dart';
import '../profiles/user_profile.dart';
import '../profiles/company_profile.dart';
import '../Screens/favorite_freelancer.dart';
import '../Screens/chosen_account_screen.dart';
import '../profiles/freelancer_profile.dart.dart';
import '../Screens/email_screens/emails_screen.dart';
import '../Screens/jobs_posted_by_user.dart';
import '../Screens/requests_screen/user_requests.dart';
import '../Screens/requests_screen/freelancer_requests.dart';

// ignore: must_be_immutable
class AppDrawer extends StatefulWidget with ChangeNotifier {
  final Account account;
  @override
  _AppDrawerState createState() => _AppDrawerState();
  AppDrawer(this.account);
}

class _AppDrawerState extends State<AppDrawer> {
  String accountType;

  Widget listTile(Icon icon, String title, Function function) {
    return ListTile(leading: icon, title: Text(title), onTap: function);
  }

  @override
  Widget build(BuildContext context) {
    AccountType type = Provider.of<Authentication>(context).type;
    return Drawer(
      child: ListView(
        children: <Widget>[
          widget.account == null
              ? listTile(Icon(Icons.login), 'Login', () {
                  Navigator.of(context).pushNamed(ChosenAccount.routeName);
                })
              : UserAccountsDrawerHeader(
                  accountName: type == AccountType.User
                      ? Text(
                          '${(widget.account as UserAccount).basicDetails.firstName} ${(widget.account as UserAccount).basicDetails.lastName}')
                      : type == AccountType.Freelancer
                          ? Text(
                              '${(widget.account as FreelancerAccount).basicDetails.firstName} ${(widget.account as FreelancerAccount).basicDetails.lastName}')
                          : Text((widget.account as CompanyAccount)
                              .companyDetails
                              .name),
                  accountEmail: type == AccountType.User
                      ? Text(
                          '${(widget.account as UserAccount).basicDetails.email}')
                      : type == AccountType.Freelancer
                          ? Text(
                              '${(widget.account as FreelancerAccount).basicDetails.email}')
                          : Text((widget.account as CompanyAccount)
                              .companyDetails
                              .email),
                  currentAccountPicture: GestureDetector(
                    child: CircleAvatar(
                      child: type == AccountType.User
                          ? (widget.account as UserAccount).additionalDetails ==
                                      null ||
                                  (widget.account as UserAccount)
                                          .additionalDetails
                                          .image ==
                                      null
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                )
                              : Image.file((widget.account as UserAccount)
                                  .additionalDetails
                                  .image)
                          : type == AccountType.Freelancer
                              ? (widget.account as FreelancerAccount)
                                              .additionalDetails ==
                                          null ||
                                      (widget.account as FreelancerAccount)
                                              .additionalDetails
                                              .image ==
                                          null
                                  ? Icon(
                                      Icons.person,
                                      size: 50,
                                    )
                                  : Image.file(
                                      (widget.account as CompanyAccount)
                                          .companyDetails
                                          .image)
                              : (widget.account as CompanyAccount)
                                              .companyDetails ==
                                          null ||
                                      (widget.account as CompanyAccount)
                                              .companyDetails
                                              .image ==
                                          null
                                  ? Icon(
                                      Icons.person,
                                      size: 50,
                                    )
                                  : Image.file((widget.account as FreelancerAccount).additionalDetails.image),
                    ),
                    onTap: () {
                      type == AccountType.User
                          ? Navigator.of(context).pushNamed(
                              UserProfile.routeName,
                              arguments: widget.account)
                          : type == AccountType.Freelancer
                              ? Navigator.of(context).pushNamed(
                                  FreelancerProfile.routeName,
                                  arguments: widget.account)
                              : Navigator.of(context).pushNamed(
                                  CompanyProfile.routeName,
                                  arguments: widget.account);
                    },
                  ),
                  otherAccountsPictures: <Widget>[
                    IconButton(
                        onPressed: () {
                          currentTheme.switchTheme();
                        },
                        icon: currentTheme.themeMode
                            ? Icon(Icons.light_mode)
                            : Icon(Icons.dark_mode)),
                  ],
                ),
          widget.account == null
              ? SizedBox()
              : listTile(Icon(Icons.inbox), 'Inbox', () {
                  if (type == AccountType.User) {
                    accountType = 'user';
                  } else if (type == AccountType.Freelancer) {
                    accountType = 'freelancer';
                  } else if (type == AccountType.Company) {
                    accountType = 'company';
                  }
                  Navigator.of(context)
                      .pushNamed(EmailsScreen.routeName, arguments: {
                    'account_type': accountType,
                    'account': widget.account,
                  });
                }),
          if (type == AccountType.User)
            listTile(Icon(Icons.star), 'Favorites', () {
              Navigator.of(context)
                  .pushNamed(UserFavorite.routeName, arguments: widget.account);
            }),
          if (type == AccountType.User)
            listTile(Icon(Icons.plus_one), 'Requests', () {
              Navigator.of(context)
                  .pushNamed(UserRequest.routeName, arguments: widget.account);
            }),
          if (type == AccountType.User)
            listTile(Icon(Icons.people), 'My timeline', () {
              Navigator.of(context)
                  .pushNamed(JobsPostedByUser.routeName, arguments: {
                'is_user': true,
                'account': widget.account,
              });
            }),
          if (type == AccountType.User)
            listTile(
              Icon(Icons.payment),
              'Pay a Freelancer',
              () {},
            ),
          if (type == AccountType.Freelancer)
            if (type == AccountType.Freelancer)
              listTile(Icon(Icons.star), 'Favorites', () {
                Navigator.of(context).pushNamed(FreelancerFavorite.routeName,
                    arguments: widget.account);
              }),
          if (type == AccountType.Freelancer)
            listTile(Icon(Icons.plus_one), 'Requests', () {
              Navigator.of(context).pushNamed(FreelancerRequests.routeName,
                  arguments: widget.account);
            }),
          if (type == AccountType.Company)
            listTile(Icon(Icons.post_add), 'post new job', () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddNewCompanyJob(widget.account),
                ),
              );
            }),
          widget.account == null
              ? SizedBox()
              : ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Log out'),
                  onTap: () async {
                    await Provider.of<Authentication>(context, listen: false)
                        .logout();
                  },
                ),
          widget.account == null
              ? SizedBox()
              : ListTile(
                  leading: Icon(Icons.person_remove),
                  title: Text('Delete my account'),
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: Text('Delete my account'),
                              content: GestureDetector(
                                child: Text(
                                    'Do you really want to delete your account ?'),
                              ),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop(false);
                                    },
                                    child: Text('No')),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.of(ctx).pop(true);
                                      String url = '';
                                      if (type == AccountType.Company) {
                                        url =
                                            '$ipAddress/company/delete_account';
                                      } else if (type == AccountType.User) {
                                        url = '$ipAddress/user/delete_account';
                                      } else if (type ==
                                          AccountType.Freelancer) {
                                        url =
                                            '$ipAddress/freelancer/delete_account';
                                      }
                                      await Provider.of<Authentication>(context,
                                              listen: false)
                                          .deactivateAccount(
                                              url, widget.account.userId);
                                    },
                                    child: Text('Yes')),
                              ],
                            ));
                  },
                ),
        ],
      ),
    );
  }
}
