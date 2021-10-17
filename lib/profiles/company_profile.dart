// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/details.dart';
import '../providers/accounts.dart';
import '../editing_screens/edit_company_details_screen.dart';

class CompanyProfile extends StatefulWidget {
  static const routeName = '/company-profile';
  @override
  _CompanyProfileState createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  var _isInit = true;
  var _isLoading = false;
  Account account;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      account = ModalRoute.of(context).settings.arguments as CompanyAccount;
      await Provider.of<CompanyDetailsProvider>(context, listen: false)
          .findByCompanyId(account.userId)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget _title(String title, String id, String routeName) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ListTile(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        trailing: title == 'Accounts'
            ? null
            : IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.black87,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(routeName, arguments: account.userId);
                },
              ),
      ),
    );
  }

  Widget _listTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    CompanyDetails companyData =
        Provider.of<CompanyDetailsProvider>(context).item;
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
                    child: companyData.image == null
                        ? Icon(Icons.person)
                        : Image.file(companyData.image),
                  ),
                ),
              ),
              title: Text('${companyData.name}'),
            ),
            body: SingleChildScrollView(
              child: Container(
                width: deviceSize.width,
                height: deviceSize.height,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: ListView(
                        children: <Widget>[
                          _title('Basic Info', companyData.id,
                              EditCompanyDetailsScreen.routeName),
                          _listTile(
                              '${companyData.name}', 'Name of this company'),
                          Divider(),
                          _listTile(companyData.email, 'Company\'s email'),
                          Divider(),
                          _listTile(
                              companyData.dateOfAaccountCreation.toString(),
                              'Company\'s account\'s date of creation'),
                          Divider(),
                          _listTile(
                              companyData.specialization == null
                                  ? ''
                                  : companyData.specialization,
                              'Company\'s specialization'),
                          Divider(),
                          _listTile(
                              companyData.description == null
                                  ? ''
                                  : companyData.description,
                              'About this company'),
                          Divider(),
                          _listTile(
                              companyData.location == null ||
                                      companyData.location.country == null
                                  ? ''
                                  : companyData.location.country,
                              'Country'),
                          Divider(),
                          _listTile(
                              companyData.location == null ||
                                      companyData.location.city == null
                                  ? ''
                                  : companyData.location.city,
                              'City'),
                          Divider(),
                          _title('Accounts', companyData.id, ''),
                          _listTile(
                              companyData.accounts == null ||
                                      companyData.accounts.twitter == null
                                  ? ''
                                  : companyData.accounts.twitter,
                              'Twitter'),
                          Divider(),
                          _listTile(
                              companyData.accounts == null ||
                                      companyData.accounts.telegram == null
                                  ? ''
                                  : companyData.accounts.telegram,
                              'Telegram'),
                          Divider(),
                          _listTile(
                              companyData.accounts == null ||
                                      companyData.accounts.instagram == null
                                  ? ''
                                  : companyData.accounts.instagram,
                              'Instagram'),
                          Divider(),
                          _listTile(
                              companyData.accounts == null ||
                                      companyData.accounts.facebook == null
                                  ? ''
                                  : companyData.accounts.facebook,
                              'Facebook'),
                          Divider(),
                          _listTile(
                              companyData.accounts == null ||
                                      companyData.accounts.linkedin == null
                                  ? ''
                                  : companyData.accounts.linkedin,
                              'Linkedin'),
                          Divider(),
                          _listTile(
                              companyData.accounts == null ||
                                      companyData.accounts.gmail == null
                                  ? ''
                                  : companyData.accounts.gmail,
                              'Gmail'),
                          Divider(),
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
