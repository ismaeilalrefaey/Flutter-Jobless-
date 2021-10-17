//@dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global_stuff.dart';
import '../models/accounts.dart';
import '../models/location.dart';
import '../providers/details.dart';

class EditCompanyDetailsScreen extends StatefulWidget {
  static const routeName = '/edit-company-details-screen';

  @override
  _EditCompanyDetailsScreenState createState() =>
      _EditCompanyDetailsScreenState();
}

class _EditCompanyDetailsScreenState extends State<EditCompanyDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String companyId;
  var _isInit = true;
  CompanyDetails companyDetails = CompanyDetails(
      id: '',
      name: '',
      email: '',
      image: null,
      password: '',
      description: '',
      specialization: '',
      rating: 0.0,
      accounts: null,
      location: null);
  UserLocation location = UserLocation(0.0, 0.0, '', '');
  var _initValue = {
    'id': '',
    'name': '',
    'email': '',
    'password': '',
    'description': '',
    'specialization': '',
    'rating': 0.0,
    'image': ''
  };
  var _initAccount = {
    'twitter': '',
    'telegram': '',
    'instagram': '',
    'gmail': '',
    'linkedin': '',
    'facebook': '',
  };
  var _initLocation = {
    'city': '',
    'country': '',
  };

  void didChangeDependencies() {
    if (_isInit) {
      companyId = ModalRoute.of(context).settings.arguments as String;
      // Provider.of<CompanyDetailsProvider>(context, listen: false)
      //     .findByCompanyId(companyId);

      companyDetails = Provider.of<CompanyDetailsProvider>(context).item;
      _initValue = {
        'id': companyDetails.id == null ? '' : companyDetails.id,
        'email': companyDetails.email == null ? '' : companyDetails.email,
        'name': companyDetails.name == null ? '' : companyDetails.name,
        'password': null,
        'description': companyDetails.description == null
            ? ''
            : companyDetails.description,
        'specialization': companyDetails.specialization == null
            ? ''
            : companyDetails.specialization,
        'rating': (0.0).toString(),
         'image':  companyDetails.image == null ? null : fileToString(companyDetails.image),
      };
      _initAccount = {
        'twitter': companyDetails.accounts == null ||
                companyDetails.accounts.twitter == null
            ? ''
            : companyDetails.accounts.twitter,
        'telegram': companyDetails.accounts == null ||
                companyDetails.accounts.telegram == null
            ? ''
            : companyDetails.accounts.telegram,
        'instagram': companyDetails.accounts == null ||
                companyDetails.accounts.instagram == null
            ? ''
            : companyDetails.accounts.instagram,
        'gmail': companyDetails.accounts == null ||
                companyDetails.accounts.gmail == null
            ? ''
            : companyDetails.accounts.gmail,
        'linkedin': companyDetails.accounts == null ||
                companyDetails.accounts.linkedin == null
            ? ''
            : companyDetails.accounts.linkedin,
        'facebook': companyDetails.accounts == null ||
                companyDetails.accounts.facebook == null
            ? ''
            : companyDetails.accounts.facebook,
      };
      _initLocation = {
        'city': companyDetails.location == null ||
                companyDetails.location.city == null
            ? ''
            : companyDetails.location.city,
        'country': companyDetails.location == null ||
                companyDetails.location.country == null
            ? ''
            : companyDetails.location.country,
      };
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget textFormField(
      String initValue,
      String labelText,
      TextInputType textInputType,
      TextInputAction textInputAction,
      Function validator,
      Function onSaved) {
    return TextFormField(
      initialValue: initValue,
      // textInputAction: textInputType == TextInputType.multiline ? null :
      //     labelText == 'Specialization' || labelText == 'Description'
      //         ? TextInputAction.newline
      //         : textInputAction,
      keyboardType: textInputType,
      decoration: InputDecoration(labelText: labelText),
      minLines: 1,
      maxLines:
          labelText == 'Specialization' || labelText == 'Description' ? 5 : 1,
      validator: validator,
      onSaved: onSaved,
      textCapitalization: TextCapitalization.words,
    );
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    Provider.of<CompanyDetailsProvider>(context, listen: false)
        .editCompanyDetails(companyDetails, companyId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Company Details Editing'),
          actions: [IconButton(icon: Icon(Icons.save), onPressed: _submit)],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                textFormField(_initValue['name'], 'Company Name',
                    TextInputType.text, TextInputAction.next, (value) {
                  if (value.isEmpty) {
                    return 'Please fill this field';
                  }
                  return null;
                }, (value) {
                  companyDetails = CompanyDetails(
                      id: companyDetails.id,
                      description: companyDetails.description == null
                          ? ''
                          : companyDetails.description,
                      specialization: companyDetails.specialization == null
                          ? ''
                          : companyDetails.specialization,
                      email: companyDetails.email == null
                          ? ''
                          : companyDetails.email,
                      name: value,
                      password: null,
                      rating: companyDetails.rating == null
                          ? '0.0'
                          : companyDetails.rating,
                      accounts: companyDetails.accounts == null
                          ? null
                          : companyDetails.accounts,
                      image: companyDetails.image == null
                          ? null
                          : companyDetails.image,
                      location: companyDetails.location == null
                          ? null
                          : companyDetails.location);
                }),
                textFormField(_initValue['email'], 'E-mail',
                    TextInputType.emailAddress, TextInputAction.next, (value) {
                  if (value.isEmpty) {
                    return 'Please fill this field';
                  }
                  return null;
                }, (value) {
                  companyDetails = CompanyDetails(
                      id: companyDetails.id,
                      description: companyDetails.description == null
                          ? ''
                          : companyDetails.description,
                      specialization: companyDetails.specialization == null
                          ? ''
                          : companyDetails.specialization,
                      email: value,
                      name: companyDetails.name,
                      password: null,
                      rating: companyDetails.rating == null
                          ? '0.0'
                          : companyDetails.rating,
                      accounts: companyDetails.accounts == null
                          ? null
                          : companyDetails.accounts,
                      image: companyDetails.image == null
                          ? null
                          : companyDetails.image,
                      location: companyDetails.location == null
                          ? null
                          : companyDetails.location);
                }),
                textFormField(_initValue['specialization'], 'Specialization',
                    TextInputType.text, TextInputAction.next, (_) {}, (value) {
                  companyDetails = CompanyDetails(
                      id: companyDetails.id,
                      description: companyDetails.description == null
                          ? ''
                          : companyDetails.description,
                      specialization: value,
                      email: companyDetails.email,
                      name: companyDetails.name,
                      password: null,
                      rating: companyDetails.rating == null
                          ? '0.0'
                          : companyDetails.rating,
                      accounts: companyDetails.accounts == null
                          ? null
                          : companyDetails.accounts,
                      image: companyDetails.image == null
                          ? null
                          : companyDetails.image,
                      location: companyDetails.location == null
                          ? null
                          : companyDetails.location);
                }),
                textFormField(_initValue['description'], 'Description',
                    TextInputType.text, TextInputAction.next, (_) {}, (value) {
                  companyDetails = CompanyDetails(
                      id: companyDetails.id,
                      description: value,
                      specialization: companyDetails.specialization == null
                          ? ''
                          : companyDetails.specialization,
                      email: companyDetails.email,
                      name: companyDetails.name,
                      password: null,
                      rating: companyDetails.rating == null
                          ? '0.0'
                          : companyDetails.rating,
                      accounts: companyDetails.accounts == null
                          ? null
                          : companyDetails.accounts,
                      image: companyDetails.image == null
                          ? null
                          : companyDetails.image,
                      location: companyDetails.location == null
                          ? null
                          : companyDetails.location);
                }),
                textFormField(_initLocation['country'], 'Country',
                    TextInputType.text, TextInputAction.next, (value) {
                  if (value.isEmpty) {
                    return 'Please fill this field';
                  }
                  return null;
                }, (value) {
                  location = UserLocation(location.latitude, location.longitude,
                      location.city, value);
                  companyDetails = CompanyDetails(
                    id: companyDetails.id,
                    description: companyDetails.description == null
                        ? ''
                        : companyDetails.description,
                    specialization: companyDetails.specialization == null
                        ? ''
                        : companyDetails.specialization,
                    email: companyDetails.email,
                    name: companyDetails.name,
                    password: null,
                    rating: companyDetails.rating == null
                        ? '0.0'
                        : companyDetails.rating,
                    accounts: companyDetails.accounts == null
                        ? null
                        : companyDetails.accounts,
                    image: companyDetails.image == null
                        ? null
                        : companyDetails.image,
                    location: location,
                  );
                }),
                textFormField(_initLocation['city'], 'City', TextInputType.text,
                    TextInputAction.next, (value) {
                  if (value.isEmpty) {
                    return 'Please fill this field';
                  }
                  return null;
                }, (value) {
                  location = UserLocation(location.latitude, location.longitude,
                      value, location.country);
                      location = location.getCityCoordinates();
                  companyDetails = CompanyDetails(
                    id: companyDetails.id,
                    description: companyDetails.description == null
                        ? ''
                        : companyDetails.description,
                    specialization: companyDetails.specialization == null
                        ? ''
                        : companyDetails.specialization,
                    email: companyDetails.email,
                    name: companyDetails.name,
                    password: null,
                    rating: companyDetails.rating == null
                        ? '0.0'
                        : companyDetails.rating,
                    accounts: companyDetails.accounts == null
                        ? null
                        : companyDetails.accounts,
                    image: companyDetails.image == null
                        ? null
                        : companyDetails.image,
                    location: location,
                  );
                }),
                textFormField(_initAccount['twitter'], 'Twitter',
                    TextInputType.text, TextInputAction.next, (_) {}, (value) {
                  companyDetails = CompanyDetails(
                    id: companyDetails.id,
                    description: companyDetails.description == null
                        ? ''
                        : companyDetails.description,
                    specialization: companyDetails.specialization == null
                        ? ''
                        : companyDetails.specialization,
                    email: companyDetails.email,
                    name: companyDetails.name,
                    password: null,
                    rating: companyDetails.rating == null
                        ? '0.0'
                        : companyDetails.rating,
                    image: companyDetails.image == null
                        ? null
                        : companyDetails.image,
                    location: companyDetails.location == null
                        ? null
                        : companyDetails.location,
                    accounts: Accounts(
                        twitter: value,
                        facebook: companyDetails.accounts == null ||
                                companyDetails.accounts.facebook == null
                            ? ''
                            : companyDetails.accounts.facebook,
                        telegram: companyDetails.accounts == null ||
                                companyDetails.accounts.telegram == null
                            ? ''
                            : companyDetails.accounts.telegram,
                        instagram: companyDetails.accounts == null ||
                                companyDetails.accounts.instagram == null
                            ? ''
                            : companyDetails.accounts.instagram,
                        linkedin: companyDetails.accounts == null ||
                                companyDetails.accounts.linkedin == null
                            ? ''
                            : companyDetails.accounts.linkedin,
                        gmail: companyDetails.accounts == null ||
                                companyDetails.accounts.gmail == null
                            ? ''
                            : companyDetails.accounts.gmail),
                  );
                }),
                textFormField(_initAccount['facebook'], 'Facebook',
                    TextInputType.text, TextInputAction.next, (_) {}, (value) {
                  companyDetails = CompanyDetails(
                    id: companyDetails.id,
                    description: companyDetails.description == null
                        ? ''
                        : companyDetails.description,
                    specialization: companyDetails.specialization == null
                        ? ''
                        : companyDetails.specialization,
                    email: companyDetails.email,
                    name: companyDetails.name,
                    password: null,
                    rating: companyDetails.rating == null
                        ? '0.0'
                        : companyDetails.rating,
                    image: companyDetails.image == null
                        ? null
                        : companyDetails.image,
                    location: companyDetails.location == null
                        ? null
                        : companyDetails.location,
                    accounts: Accounts(
                        twitter: companyDetails.accounts == null ||
                                companyDetails.accounts.twitter == null
                            ? ''
                            : companyDetails.accounts.twitter,
                        facebook: value,
                        telegram: companyDetails.accounts == null ||
                                companyDetails.accounts.telegram == null
                            ? ''
                            : companyDetails.accounts.telegram,
                        instagram: companyDetails.accounts == null ||
                                companyDetails.accounts.instagram == null
                            ? ''
                            : companyDetails.accounts.instagram,
                        linkedin: companyDetails.accounts == null ||
                                companyDetails.accounts.linkedin == null
                            ? ''
                            : companyDetails.accounts.linkedin,
                        gmail: companyDetails.accounts == null ||
                                companyDetails.accounts.gmail == null
                            ? ''
                            : companyDetails.accounts.gmail),
                  );
                }),
                textFormField(_initAccount['telegram'], 'Telegram',
                    TextInputType.text, TextInputAction.next, (_) {}, (value) {
                  companyDetails = CompanyDetails(
                    id: companyDetails.id,
                    description: companyDetails.description == null
                        ? ''
                        : companyDetails.description,
                    specialization: companyDetails.specialization == null
                        ? ''
                        : companyDetails.specialization,
                    email: companyDetails.email,
                    name: companyDetails.name,
                    password: null,
                    rating: companyDetails.rating == null
                        ? '0.0'
                        : companyDetails.rating,
                    image: companyDetails.image == null
                        ? null
                        : companyDetails.image,
                    location: companyDetails.location == null
                        ? null
                        : companyDetails.location,
                    accounts: Accounts(
                        twitter: companyDetails.accounts == null ||
                                companyDetails.accounts.twitter == null
                            ? ''
                            : companyDetails.accounts.twitter,
                        facebook: companyDetails.accounts == null ||
                                companyDetails.accounts.facebook == null
                            ? ''
                            : companyDetails.accounts.facebook,
                        telegram: value,
                        instagram: companyDetails.accounts == null ||
                                companyDetails.accounts.instagram == null
                            ? ''
                            : companyDetails.accounts.instagram,
                        linkedin: companyDetails.accounts == null ||
                                companyDetails.accounts.linkedin == null
                            ? ''
                            : companyDetails.accounts.linkedin,
                        gmail: companyDetails.accounts == null ||
                                companyDetails.accounts.gmail == null
                            ? ''
                            : companyDetails.accounts.gmail),
                  );
                }),
                textFormField(_initAccount['instagram'], 'Instagram',
                    TextInputType.text, TextInputAction.next, (_) {}, (value) {
                  companyDetails = CompanyDetails(
                    id: companyDetails.id,
                    description: companyDetails.description == null
                        ? ''
                        : companyDetails.description,
                    specialization: companyDetails.specialization == null
                        ? ''
                        : companyDetails.specialization,
                    email: companyDetails.email,
                    name: companyDetails.name,
                    password: null,
                    rating: companyDetails.rating == null
                        ? '0.0'
                        : companyDetails.rating,
                    image: companyDetails.image == null
                        ? null
                        : companyDetails.image,
                    location: companyDetails.location == null
                        ? null
                        : companyDetails.location,
                    accounts: Accounts(
                        twitter: companyDetails.accounts == null ||
                                companyDetails.accounts.twitter == null
                            ? ''
                            : companyDetails.accounts.twitter,
                        facebook: companyDetails.accounts == null ||
                                companyDetails.accounts.facebook == null
                            ? ''
                            : companyDetails.accounts.facebook,
                        telegram: companyDetails.accounts == null ||
                                companyDetails.accounts.telegram == null
                            ? ''
                            : companyDetails.accounts.telegram,
                        instagram: value,
                        linkedin: companyDetails.accounts == null ||
                                companyDetails.accounts.linkedin == null
                            ? ''
                            : companyDetails.accounts.linkedin,
                        gmail: companyDetails.accounts == null ||
                                companyDetails.accounts.gmail == null
                            ? ''
                            : companyDetails.accounts.gmail),
                  );
                }),
                textFormField(_initAccount['linkedin'], 'Linkedin',
                    TextInputType.text, TextInputAction.next, (_) {}, (value) {
                  companyDetails = CompanyDetails(
                    id: companyDetails.id,
                    description: companyDetails.description == null
                        ? ''
                        : companyDetails.description,
                    specialization: companyDetails.specialization == null
                        ? ''
                        : companyDetails.specialization,
                    email: companyDetails.email,
                    name: companyDetails.name,
                    password: null,
                    rating: companyDetails.rating == null
                        ? '0.0'
                        : companyDetails.rating,
                    image: companyDetails.image == null
                        ? null
                        : companyDetails.image,
                    location: companyDetails.location == null
                        ? null
                        : companyDetails.location,
                    accounts: Accounts(
                        twitter: companyDetails.accounts == null ||
                                companyDetails.accounts.twitter == null
                            ? ''
                            : companyDetails.accounts.twitter,
                        facebook: companyDetails.accounts == null ||
                                companyDetails.accounts.facebook == null
                            ? ''
                            : companyDetails.accounts.facebook,
                        telegram: companyDetails.accounts == null ||
                                companyDetails.accounts.telegram == null
                            ? ''
                            : companyDetails.accounts.telegram,
                        instagram: companyDetails.accounts == null ||
                                companyDetails.accounts.instagram == null
                            ? ''
                            : companyDetails.accounts.instagram,
                        linkedin: value,
                        gmail: companyDetails.accounts == null ||
                                companyDetails.accounts.gmail == null
                            ? ''
                            : companyDetails.accounts.gmail),
                  );
                }),
                textFormField(_initAccount['gmail'], 'Gmail',
                    TextInputType.text, TextInputAction.next, (_) {}, (value) {
                  companyDetails = CompanyDetails(
                    id: companyDetails.id,
                    description: companyDetails.description == null
                        ? ''
                        : companyDetails.description,
                    specialization: companyDetails.specialization == null
                        ? ''
                        : companyDetails.specialization,
                    email: companyDetails.email,
                    name: companyDetails.name,
                    password: null,
                    rating: companyDetails.rating == null
                        ? '0.0'
                        : companyDetails.rating,
                    image: companyDetails.image == null
                        ? null
                        : companyDetails.image,
                    location: companyDetails.location == null
                        ? null
                        : companyDetails.location,
                    accounts: Accounts(
                        twitter: companyDetails.accounts == null ||
                                companyDetails.accounts.twitter == null
                            ? ''
                            : companyDetails.accounts.twitter,
                        facebook: companyDetails.accounts == null ||
                                companyDetails.accounts.facebook == null
                            ? ''
                            : companyDetails.accounts.facebook,
                        telegram: companyDetails.accounts == null ||
                                companyDetails.accounts.telegram == null
                            ? ''
                            : companyDetails.accounts.telegram,
                        instagram: companyDetails.accounts == null ||
                                companyDetails.accounts.instagram == null
                            ? ''
                            : companyDetails.accounts.instagram,
                        linkedin: companyDetails.accounts == null ||
                                companyDetails.accounts.linkedin == null
                            ? ''
                            : companyDetails.accounts.linkedin,
                        gmail: value),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
