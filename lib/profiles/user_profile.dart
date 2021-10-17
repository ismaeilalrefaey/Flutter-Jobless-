// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global_stuff.dart';
import '../providers/details.dart';
import '../providers/accounts.dart';
import '../Screens/employment_details_screen.dart';
import '../editing_screens/edit_basic_details_screen.dart';
import '../editing_screens/edit_additional_details_screen.dart';
import '../editing_screens/edit_educational_details_screen.dart';

class UserProfile extends StatefulWidget {
  static const routeName = '/user-profile';

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var _isinit = true;
  var _isLoading = true;
  Widget _title(String title, String id, String routeName) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.edit,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(routeName, arguments: account);
          },
        ),
      ),
    );
  }

  Widget _listTile(String title, String subtitle) {
    return ListTile(
      title: Text(title ?? ''),
      subtitle: Text(subtitle ?? ''),
    );
  }

  BasicDetails userData;
  EducationalDetails eduData;
  AdditionalDetails additData;

  Account account;

  @override
  Future<void> didChangeDependencies() async {
    // setState(() {
    //   _isLoading = true;
    // });
    if (_isinit) {
      account = ModalRoute.of(context).settings.arguments as UserAccount;
      await Provider.of<BasicDetailsProvider>(context, listen: false)
          .findByUserId(account.userId, '$ipAddress/get/user');
      await Provider.of<AdditionalDetailsProvider>(context, listen: false)
          .findByUserId(account.userId, '$ipAddress/get/user');
      await Provider.of<EducationalDetailsProvider>(context, listen: false)
          .findByUserId(account.userId, '$ipAddress/get/user');
    }
    _isinit = false;
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // init();

    userData = Provider.of<BasicDetailsProvider>(context).item;
    additData = Provider.of<AdditionalDetailsProvider>(context).item;
    eduData = Provider.of<EducationalDetailsProvider>(context).item;

    final deviceSize = MediaQuery.of(context).size;

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
                    backgroundImage: NetworkImage(
                        'https://www.incimages.com/uploaded_files/image/1920x1080/getty_655998316_2000149920009280219_363765.jpg'),
                  ),
                ),
              ),
              title: Text('${userData.firstName} ${userData.lastName}'),
            ),
            body: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Container(
                      height: deviceSize.height,
                      width: deviceSize.width,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Flexible(
                            child: ListView(
                              children: <Widget>[
                                _title('Basic Info', account.userId,
                                    EditBasicDetailsScreen.routeName),
                                _listTile(
                                    '${userData.firstName} ${userData.lastName}',
                                    'Full name of this user'),
                                Divider(),
                                _listTile(
                                    '${userData.birthday.year} / ${userData.birthday.month} / ${userData.birthday.day}',
                                    'birthday'),
                                Divider(),
                                _listTile(userData.gender, 'M / F'),
                                Divider(),
                                _listTile(userData.email,
                                    'Some shit before an @gmail.com'),
                                Divider(),
                                _listTile(
                                    userData.phoneNumber == null
                                        ? ''
                                        : userData.phoneNumber,
                                    'Mobile'),
                                Divider(),
                                _title('Educational Info', userData.id,
                                    EditEducationalDetailsScreen.routeName),
                                Divider(),
                                _listTile(
                                    eduData == null ||
                                            eduData.specialization == null
                                        ? ''
                                        : eduData.specialization,
                                    'Specialization'),
                                Divider(),
                                _listTile(
                                    eduData == null ||
                                            eduData.educationLevels == null
                                        ? ''
                                        : eduData.educationLevels,
                                    'Baccalaureat / Bachelor / Master / P.hD. .. etc'),
                                Divider(),
                                _listTile(
                                    eduData == null || eduData.skills == null
                                        ? ''
                                        : eduData.skills,
                                    'Skills'),
                                Divider(),
                                _listTile(
                                    eduData == null || eduData.courses == null
                                        ? ''
                                        : eduData.courses,
                                    'Courses'),
                                Divider(),
                                _listTile(
                                    eduData == null ||
                                            eduData.spokenLanguage == null
                                        ? ''
                                        : eduData.spokenLanguage,
                                    'Languages'),
                                Divider(),
                                _listTile(
                                    eduData == null ||
                                            eduData.isGraduated == null
                                        ? ''
                                        : eduData.isGraduated
                                            ? 'Yes'
                                            : 'No',
                                    'graduated??'),
                                Divider(),
                                _listTile('this will be visible to others',
                                    'CV file '),
                                Divider(),
                                _title('Additional Info', userData.id,
                                    EditAdditionalDetailsScreen.routeName),
                                Divider(),
                                _listTile(
                                    additData == null ||
                                            additData.nationality == null
                                        ? ''
                                        : additData.nationality,
                                    'Nationality'),
                                Divider(),
                                _listTile(
                                    additData == null ||
                                            additData.creditCard == null
                                        ? ''
                                        : additData.creditCard,
                                    'Credit Card'),
                                Divider(),
                                _listTile(
                                    additData == null ||
                                            additData.location.country == null
                                        ? ''
                                        : additData.location.country,
                                    'Country'),
                                Divider(),
                                _listTile(
                                    additData == null ||
                                            additData.location.city == null
                                        ? ''
                                        : additData.location.city,
                                    'City'),
                                Divider(),
                                _listTile(
                                    additData == null ||
                                            additData.accounts == null ||
                                            additData.accounts.twitter == null
                                        ? ''
                                        : additData.accounts.twitter,
                                    'Twitter'),
                                Divider(),
                                _listTile(
                                    additData == null ||
                                            additData.accounts == null ||
                                            additData.accounts.facebook == null
                                        ? ''
                                        : additData.accounts.facebook,
                                    'Facebook'),
                                Divider(),
                                _listTile(
                                    additData == null ||
                                            additData.accounts == null ||
                                            additData.accounts.telegram == null
                                        ? ''
                                        : additData.accounts.telegram,
                                    'Telegram'),
                                Divider(),
                                _listTile(
                                    additData == null ||
                                            additData.accounts == null ||
                                            additData.accounts.instagram == null
                                        ? ''
                                        : additData.accounts.instagram,
                                    'Instagram'),
                                Divider(),
                                _listTile(
                                    additData == null ||
                                            additData.accounts == null ||
                                            additData.accounts.linkedin == null
                                        ? ''
                                        : additData.accounts.linkedin,
                                    'Linkedin'),
                                Divider(),
                                _listTile(
                                    additData == null ||
                                            additData.accounts == null ||
                                            additData.accounts.gmail == null
                                        ? ''
                                        : additData.accounts.gmail,
                                    'Gmail'),
                                Divider(),
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        EmploymentDetailsScreen.routeName,
                                        arguments: {
                                          'user_id': account.userId,
                                          'is_user': true,
                                        });
                                  },
                                  title: Text('User\'s Previous Work'),
                                ),
                                SizedBox(height: 100)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
  }
}
