// @dart=2.9

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global_stuff.dart';
import '../providers/details.dart';
import '../providers/accounts.dart';
import '../PDF_bussiness/PDFApi.dart';
import '../PDF_bussiness/PDF_view.dart';
import '../Screens/employment_details_screen.dart';
import '../editing_screens/edit_basic_details_screen.dart';
import '../editing_screens/edit_additional_details_screen.dart';
import '../editing_screens/edit_educational_details_screen.dart';

class FreelancerProfile extends StatefulWidget {
  static const routeName = '/freelancer-profile';

  @override
  _FreelancerProfileState createState() => _FreelancerProfileState();
}

class _FreelancerProfileState extends State<FreelancerProfile> {
  Account account;
  BasicDetails userData;
  EducationalDetails eduData;
  AdditionalDetails additData;
  var _isinit = true;
  var _isLoading = false;
  File file;

  Widget _title(String title, String id, String routeName) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ListTile(
        title: Text(
          title ?? 'null',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.edit,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(
              routeName,
              arguments: routeName == EmploymentDetailsScreen.routeName
                  ? {'is_user': false, 'user_id': id}
                  : account,
            );
          },
        ),
      ),
    );
  }

  Widget _listTile(String title, String subtitle) {
    return ListTile(
      title: Text(title ?? 'null'),
      subtitle: Text(subtitle ?? 'null'),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    setState(() {
      _isLoading = true;
    });
    if (_isinit) {
      account = ModalRoute.of(context).settings.arguments as FreelancerAccount;
      await Provider.of<BasicDetailsProvider>(context, listen: false)
          .findByUserId(account.userId, '$ipAddress/get/freelancer');
      await Provider.of<AdditionalDetailsProvider>(context, listen: false)
          .findByUserId(account.userId, '$ipAddress/get/freelancer');
      await Provider.of<EducationalDetailsProvider>(context, listen: false)
          .findByUserId(account.userId, '$ipAddress/get/freelancer');
    }
    _isinit = false;
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final freelancerData = Provider.of<BasicDetailsProvider>(context).item;
    final eduData = Provider.of<EducationalDetailsProvider>(context).item;
    final additData = Provider.of<AdditionalDetailsProvider>(context).item;

    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(6.0),
                child: GestureDetector(
                  child: CircleAvatar(
                    child: CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
              ),
              title: Text(
                  '${freelancerData.firstName} ${freelancerData.lastName}'),
            ),
            body: SingleChildScrollView(
              child: Container(
                height: deviceSize.height,
                width: deviceSize.width,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: ListView(children: <Widget>[
                        _title('Basic Info', account.userId,
                            EditBasicDetailsScreen.routeName),
                        _listTile(
                            '${freelancerData.firstName} ${freelancerData.lastName}',
                            'Full name of this freelancer'),
                        Divider(),
                        _listTile(
                            '${freelancerData.birthday.year} / ${freelancerData.birthday.month} / ${freelancerData.birthday.day}',
                            'Worst date ever'),
                        Divider(),
                        _listTile(freelancerData.gender, 'M / F'),
                        Divider(),
                        _listTile(freelancerData.email,
                            'Some shit before an @gmail.com'),
                        Divider(),
                        _listTile(
                            freelancerData.phoneNumber == null
                                ? 'Not provided yet'
                                : freelancerData.phoneNumber,
                            'Mobile'),
                        Divider(),
                        _title('Educational Info', account.userId,
                            EditEducationalDetailsScreen.routeName),
                        Divider(),
                        _listTile(
                            eduData == null || eduData.specialization == null
                                ? 'Not provided yet'
                                : eduData.specialization,
                            'What I\'m major in'),
                        Divider(),
                        _listTile(
                            eduData == null || eduData.educationLevels == null
                                ? 'Not provided yet'
                                : eduData.educationLevels,
                            'Baccalaureat / Bachelor / Master / P.hD. .. etc'),
                        Divider(),
                        _listTile(
                            eduData == null || eduData.skills == null
                                ? 'Not provided yet'
                                : eduData.skills,
                            'Skills'),
                        Divider(),
                        _listTile(
                            eduData == null || eduData.courses == null
                                ? 'Not provided yet'
                                : eduData.courses,
                            'Courses'),
                        Divider(),
                        _listTile(
                            eduData == null || eduData.spokenLanguage == null
                                ? 'Not provided yet'
                                : eduData.spokenLanguage,
                            'Languages :/'),
                        Divider(),
                        _listTile(
                            eduData == null || eduData.isGraduated == null
                                ? 'Not provided yet'
                                : eduData.isGraduated
                                    ? 'Yes'
                                    : 'No',
                            'Am i graduated??'),
                        Divider(),
                        _listTile('this will be visible to others', 'CV file '),
                        Divider(),
                        _title('Additional Info', account.userId,
                            EditAdditionalDetailsScreen.routeName),
                        _listTile(
                            additData == null || additData.nationality == null
                                ? 'Not provided yet'
                                : additData.nationality,
                            'Nationality'),
                        Divider(),
                        _listTile(
                            additData == null || additData.creditCard == null
                                ? 'Not provided yet'
                                : additData.creditCard,
                            'Credit Card'),
                        Divider(),
                        _listTile(
                            additData == null ||
                                    additData.location == null ||
                                    additData.location.country == null
                                ? 'Not provided yet'
                                : additData.location.country,
                            'Country'),
                        Divider(),
                        _listTile(
                            additData == null ||
                                    additData.location == null ||
                                    additData.location.city == null
                                ? 'Not provided yet'
                                : additData.location.city,
                            'City'),
                        Divider(),
                        _listTile(
                            additData == null ||
                                    additData.accounts.twitter == null
                                ? 'Not provided yet'
                                : additData.accounts.twitter,
                            'Twitter'),
                        Divider(),
                        _listTile(
                            additData == null ||
                                    additData.accounts.facebook == null
                                ? 'Not provided yet'
                                : additData.accounts.facebook,
                            'Facebook'),
                        Divider(),
                        _listTile(
                            additData == null ||
                                    additData.accounts.telegram == null
                                ? 'Not provided yet'
                                : additData.accounts.telegram,
                            'Telegram'),
                        Divider(),
                        _listTile(
                            additData == null ||
                                    additData.accounts.instagram == null
                                ? 'Not provided yet'
                                : additData.accounts.instagram,
                            'Instagram'),
                        Divider(),
                        _listTile(
                            additData == null ||
                                    additData.accounts.linkedin == null
                                ? 'Not provided yet'
                                : additData.accounts.linkedin,
                            'Linkedin'),
                        Divider(),
                        _listTile(
                            additData == null ||
                                    additData.accounts.gmail == null
                                ? 'Not provided yet'
                                : additData.accounts.gmail,
                            'Gmail'),
                        Divider(),
                        Container(
                            height: 60,
                            width: double.infinity,
                            child: DropdownButton(
                              icon: Icon(Icons.feed_outlined),
                              hint: Text('Portfolio file',
                                  style: TextStyle(
                                    color: Colors.black,
                                  )),
                              items: [
                                'Upload new portfolio',
                                'View my portfolio'
                              ]
                                  .map<DropdownMenuItem<String>>((value) =>
                                      DropdownMenuItem<String>(
                                          value: value, child: Text(value)))
                                  .toList(),
                              onChanged: (value) async {
                                if (value == 'Upload new portfolio') {
                                  file = await PDFApi.pickFile();
                                  (account as FreelancerAccount).portfolio =
                                      file;
                                } else {
                                  if ((account as FreelancerAccount)
                                          .portfolio ==
                                      null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text('You didn\'t upload your portfolio'),
                                      duration: Duration(seconds: 2),
                                    ));
                                    return;
                                  }
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          PDFViewer(file: file)));
                                }
                              },
                            )),
                        _title('Previous Works', account.userId,
                            EmploymentDetailsScreen.routeName),
                        SizedBox(height: 100)
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
