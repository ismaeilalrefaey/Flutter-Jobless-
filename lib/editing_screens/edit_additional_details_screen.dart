//@dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global_stuff.dart';
import '../models/accounts.dart';
import '../models/location.dart';
import '../providers/details.dart';
import '../providers/accounts.dart';

class EditAdditionalDetailsScreen extends StatefulWidget {
  static const routeName = '/edit-additional-details-screen';
  @override
  _EditAdditionalDetailsScreenState createState() =>
      _EditAdditionalDetailsScreenState();
}

class _EditAdditionalDetailsScreenState
    extends State<EditAdditionalDetailsScreen> {
  Account account;
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isInit = true;
  var _additionalDetails = AdditionalDetails(
      id: null,
      image: null,
      nationality: '',
      creditCard: '',
      location: null,
      accounts: null);
  var location = UserLocation(0.0, 0.0, '', '');
  var _initLocation = {
    'latitude': '',
    'longitude': '',
    'city': '',
    'country': ''
  };
  var _initAccounts = {
    'twitter': '',
    'facebook': '',
    'instagram': '',
    'gmail': '',
    'telegram': '',
    'linkedin': ''
  };
  var _initValue = {
    'nationality': '',
    'creditCard': '',
    'image': null,
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      account = ModalRoute.of(context).settings.arguments as Account;
      _additionalDetails = Provider.of<AdditionalDetailsProvider>(context).item;
      _initValue = {
        'nationality':
            _additionalDetails == null || _additionalDetails.nationality == null
                ? ''
                : _additionalDetails.nationality,
        'creditCard':
            _additionalDetails == null || _additionalDetails.creditCard == null
                ? ''
                : _additionalDetails.creditCard,
        'image': _additionalDetails.image == null ? null : fileToString(_additionalDetails.image),
      };
      _initLocation = {
        'latitude':
            _additionalDetails == null || _additionalDetails.location == null
                ? ''
                : _additionalDetails.location.latitude.toString(),
        'longitude':
            _additionalDetails == null || _additionalDetails.location == null
                ? ''
                : _additionalDetails.location.longitude.toString(),
        'city':
            _additionalDetails == null || _additionalDetails.location == null
                ? ''
                : _additionalDetails.location.city,
        'country':
            _additionalDetails == null || _additionalDetails.location == null
                ? ''
                : _additionalDetails.location.country
      };
      _initAccounts = {
        'twitter': _additionalDetails == null ||
                _additionalDetails.accounts == null ||
                _additionalDetails.accounts.twitter == null
            ? ''
            : _additionalDetails.accounts.twitter,
        'facebook': _additionalDetails == null ||
                _additionalDetails.accounts == null ||
                _additionalDetails.accounts.facebook == null
            ? ''
            : _additionalDetails.accounts.facebook,
        'instagram': _additionalDetails == null ||
                _additionalDetails.accounts == null ||
                _additionalDetails.accounts.instagram == null
            ? ''
            : _additionalDetails.accounts.instagram,
        'gmail': _additionalDetails == null ||
                _additionalDetails.accounts == null ||
                _additionalDetails.accounts.gmail == null
            ? ''
            : _additionalDetails.accounts.gmail,
        'telegram': _additionalDetails == null ||
                _additionalDetails.accounts == null ||
                _additionalDetails.accounts.telegram == null
            ? ''
            : _additionalDetails.accounts.telegram,
        'linkedin': _additionalDetails == null ||
                _additionalDetails.accounts == null ||
                _additionalDetails.accounts.linkedin == null
            ? ''
            : _additionalDetails.accounts.linkedin
      };
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  Widget textField(String initValue, TextInputType textInputType,
      String labelText, TextInputAction textInputAction, Function onSaved) {
    return TextFormField(
        initialValue: initValue,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        decoration: InputDecoration(labelText: labelText),
        onSaved: onSaved);
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    var temp = '';
    if (account is UserAccount) {
      temp = '$ipAddress/edit/user/additionaldetails';
    } else {
      temp = '$ipAddress/edit/freelancer/additionaldetails';
    }
    Provider.of<AdditionalDetailsProvider>(context, listen: false)
        .editAdditionalDetails(_additionalDetails, account.userId, temp);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Additional Details Editing'),
          actions: [IconButton(icon: Icon(Icons.save), onPressed: _submit)],
        ),
        body: _isInit
            ? LinearProgressIndicator()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            child: CircleAvatar(
                                child: _additionalDetails == null ||
                                        _additionalDetails.image == null
                                    ? Icon(
                                        Icons.person,
                                        //size: 60,
                                      )
                                    : Image.file(_additionalDetails.image)),
                            onTap: () {
                              print('photo');
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            child: Text('Add Photo'),
                            onTap: () {
                              print('photo');
                            },
                          )
                        ],
                      ),
                      textField(_initValue['nationality'], TextInputType.text,
                          'Nationality', TextInputAction.next, (value) {
                        _additionalDetails = AdditionalDetails(
                          id: '',
                          image: _additionalDetails == null ||
                                  _additionalDetails.image == null
                              ? null
                              : _additionalDetails.image,
                          nationality: value,
                          creditCard: _additionalDetails == null ||
                                  _additionalDetails.creditCard == null
                              ? ''
                              : _additionalDetails.creditCard,
                          accounts: _additionalDetails == null ||
                                  _additionalDetails.accounts == null
                              ? null
                              : _additionalDetails.accounts,
                          location: _additionalDetails == null ||
                                  _additionalDetails.location == null
                              ? null
                              : _additionalDetails.location,
                        );
                      }),
                      textField(_initValue['creditCard'], TextInputType.number,
                          'Credit Card', TextInputAction.next, (value) {
                        _additionalDetails = AdditionalDetails(
                          id: '',
                          image: _additionalDetails == null ||
                                  _additionalDetails.image == null
                              ? null
                              : _additionalDetails.image,
                          nationality: _additionalDetails.nationality,
                          creditCard: value,
                          accounts: _additionalDetails == null ||
                                  _additionalDetails.accounts == null
                              ? null
                              : _additionalDetails.accounts,
                          location: _additionalDetails == null ||
                                  _additionalDetails.location == null
                              ? null
                              : _additionalDetails.location,
                        );
                      }),
                      textField(_initLocation['country'], TextInputType.text,
                          'Country', TextInputAction.next, (value) {
                        location = UserLocation(location.latitude,
                            location.longitude, location.city, value);
                        _additionalDetails = AdditionalDetails(
                          id: '',
                          image: _additionalDetails == null ||
                                  _additionalDetails.image == null
                              ? null
                              : _additionalDetails.image,
                          nationality: _additionalDetails == null ||
                                  _additionalDetails.nationality == null
                              ? ''
                              : _additionalDetails.nationality,
                          creditCard: _additionalDetails == null ||
                                  _additionalDetails.creditCard == null
                              ? ''
                              : _additionalDetails.creditCard,
                          accounts: _additionalDetails == null ||
                                  _additionalDetails.accounts == null
                              ? null
                              : _additionalDetails.accounts,
                          location: location,
                        );
                      }),
                      textField(_initLocation['city'], TextInputType.text,
                          'City', TextInputAction.next, (value) {
                        location = UserLocation(location.latitude,
                            location.longitude, value, location.country);
                        _additionalDetails = AdditionalDetails(
                          id: '',
                          image: _additionalDetails == null ||
                                  _additionalDetails.image == null
                              ? null
                              : _additionalDetails.image,
                          nationality: _additionalDetails == null ||
                                  _additionalDetails.nationality == null
                              ? ''
                              : _additionalDetails.nationality,
                          creditCard: _additionalDetails == null ||
                                  _additionalDetails.creditCard == null
                              ? ''
                              : _additionalDetails.creditCard,
                          accounts: _additionalDetails == null ||
                                  _additionalDetails.accounts == null
                              ? null
                              : _additionalDetails.accounts,
                          location: location,
                        );
                      }),
                      textField(
                          _initAccounts['twitter'],
                          TextInputType.emailAddress,
                          'Twitter',
                          TextInputAction.next, (value) {
                        _additionalDetails = AdditionalDetails(
                          id: '',
                          image: _additionalDetails == null ||
                                  _additionalDetails.image == null
                              ? null
                              : _additionalDetails.image,
                          nationality: _additionalDetails == null ||
                                  _additionalDetails.nationality == ''
                              ? null
                              : _additionalDetails.nationality,
                          creditCard: _additionalDetails == null ||
                                  _additionalDetails.creditCard == null
                              ? ''
                              : _additionalDetails.creditCard,
                          accounts: Accounts(
                              twitter: value,
                              facebook: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.facebook ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.facebook,
                              telegram: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.telegram ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.telegram,
                              instagram: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.instagram ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.instagram,
                              linkedin: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.linkedin ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.linkedin,
                              gmail: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.gmail == null
                                  ? ''
                                  : _additionalDetails.accounts.gmail),
                          location: _additionalDetails.location,
                        );
                      }),
                      textField(
                          _initAccounts['facebook'],
                          TextInputType.emailAddress,
                          'Facebook',
                          TextInputAction.next, (value) {
                        _additionalDetails = AdditionalDetails(
                          id: '',
                          image: _additionalDetails == null ||
                                  _additionalDetails.image == null
                              ? null
                              : _additionalDetails.image,
                          nationality: _additionalDetails == null ||
                                  _additionalDetails.nationality == ''
                              ? null
                              : _additionalDetails.nationality,
                          creditCard: _additionalDetails == null ||
                                  _additionalDetails.creditCard == null
                              ? ''
                              : _additionalDetails.creditCard,
                          accounts: Accounts(
                              twitter: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.twitter ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.twitter,
                              facebook: value,
                              telegram: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.telegram ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.telegram,
                              instagram: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.instagram ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.instagram,
                              linkedin: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.linkedin ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.linkedin,
                              gmail:
                                  _additionalDetails == null || _additionalDetails.accounts == null || _additionalDetails.accounts.gmail == null
                                      ? ''
                                      : _additionalDetails.accounts.gmail),
                          location: _additionalDetails.location,
                        );
                      }),
                      textField(
                          _initAccounts['telegram'],
                          TextInputType.emailAddress,
                          'Telegram',
                          TextInputAction.next, (value) {
                        _additionalDetails = AdditionalDetails(
                          id: '',
                          image: _additionalDetails == null ||
                                  _additionalDetails.image == null
                              ? null
                              : _additionalDetails.image,
                          nationality: _additionalDetails == null ||
                                  _additionalDetails.nationality == ''
                              ? null
                              : _additionalDetails.nationality,
                          creditCard: _additionalDetails == null ||
                                  _additionalDetails.creditCard == null
                              ? ''
                              : _additionalDetails.creditCard,
                          accounts: Accounts(
                              twitter: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.twitter ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.twitter,
                              facebook: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.facebook ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.facebook,
                              telegram: value,
                              instagram: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.instagram ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.instagram,
                              linkedin: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.linkedin ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.linkedin,
                              gmail:
                                  _additionalDetails == null || _additionalDetails.accounts == null || _additionalDetails.accounts.gmail == null
                                      ? ''
                                      : _additionalDetails.accounts.gmail),
                          location: _additionalDetails.location,
                        );
                      }),
                      textField(
                          _initAccounts['instagram'],
                          TextInputType.emailAddress,
                          'Instagram',
                          TextInputAction.next, (value) {
                        _additionalDetails = AdditionalDetails(
                          id: '',
                          image: _additionalDetails == null ||
                                  _additionalDetails.image == null
                              ? null
                              : _additionalDetails.image,
                          nationality: _additionalDetails == null ||
                                  _additionalDetails.nationality == ''
                              ? null
                              : _additionalDetails.nationality,
                          creditCard: _additionalDetails == null ||
                                  _additionalDetails.creditCard == null
                              ? ''
                              : _additionalDetails.creditCard,
                          accounts: Accounts(
                              twitter: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.twitter ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.twitter,
                              facebook: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.facebook ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.facebook,
                              telegram: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.telegram ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.telegram,
                              instagram: value,
                              linkedin: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.linkedin ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.linkedin,
                              gmail: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.gmail == null
                                  ? ''
                                  : _additionalDetails.accounts.gmail),
                          location: _additionalDetails.location,
                        );
                      }),
                      textField(
                          _initAccounts['linkedin'],
                          TextInputType.emailAddress,
                          'Linkedin',
                          TextInputAction.next, (value) {
                        _additionalDetails = AdditionalDetails(
                          id: '',
                          image: _additionalDetails == null ||
                                  _additionalDetails.image == null
                              ? null
                              : _additionalDetails.image,
                          nationality: _additionalDetails == null ||
                                  _additionalDetails.nationality == ''
                              ? null
                              : _additionalDetails.nationality,
                          creditCard: _additionalDetails == null ||
                                  _additionalDetails.creditCard == null
                              ? ''
                              : _additionalDetails.creditCard,
                          accounts: Accounts(
                              twitter: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.twitter ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.twitter,
                              facebook: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.facebook ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.facebook,
                              telegram: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.telegram ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.telegram,
                              instagram: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.instagram ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.instagram,
                              linkedin: value,
                              gmail: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.gmail == null
                                  ? ''
                                  : _additionalDetails.accounts.gmail),
                          location: _additionalDetails.location,
                        );
                      }),
                      textField(
                          _initAccounts['gmail'],
                          TextInputType.emailAddress,
                          'Gmail',
                          TextInputAction.next, (value) {
                        _additionalDetails = AdditionalDetails(
                          id: '',
                          image: _additionalDetails == null ||
                                  _additionalDetails.image == null
                              ? null
                              : _additionalDetails.image,
                          nationality: _additionalDetails == null ||
                                  _additionalDetails.nationality == ''
                              ? null
                              : _additionalDetails.nationality,
                          creditCard: _additionalDetails == null ||
                                  _additionalDetails.creditCard == null
                              ? ''
                              : _additionalDetails.creditCard,
                          accounts: Accounts(
                              twitter: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.twitter ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.twitter,
                              facebook: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.facebook ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.facebook,
                              telegram: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.telegram ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.telegram,
                              instagram: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.instagram ==
                                          null
                                  ? ''
                                  : _additionalDetails.accounts.instagram,
                              linkedin: _additionalDetails == null ||
                                      _additionalDetails.accounts == null ||
                                      _additionalDetails.accounts.linkedin == null
                                  ? ''
                                  : _additionalDetails.accounts.linkedin,
                              gmail: value),
                          location: _additionalDetails.location,
                        );
                      })
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
