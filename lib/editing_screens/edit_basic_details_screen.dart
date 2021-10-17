//@dart=2.9
import 'package:flutter/material.dart';
import '../global_stuff.dart';
import '../providers/accounts.dart';
import 'package:provider/provider.dart';
import '../providers/details.dart';

enum dropdownButtonType {
  day,
  month,
  year,
  gender,
}

class EditBasicDetailsScreen extends StatefulWidget {
  static const routeName = '/edit-basic-details-screen';
  @override
  _EditMyBasicInfomationState createState() => _EditMyBasicInfomationState();
}

class _EditMyBasicInfomationState extends State<EditBasicDetailsScreen> {
  Account account;
  final GlobalKey<FormState> _formKey = GlobalKey();
  BasicDetails _data = BasicDetails(
      id: '',
      firstName: '',
      lastName: '',
      gender: '',
      birthday: null,
      phoneNumber: '',
      email: '',
      password: '');
  var _initValue = {
    'first_name': '',
    'lastName': '',
    'gender': '',
    'birthday': '',
    'phoneNumber': '',
    'email': '',
    'password': ''
  };
  var _isInit = true;
  String _month, _day, _year;
  String _gender;
  final List<String> _genders = ['Male', 'Female'];
  List<String> _days = [],
      _years = [],
      _months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];

  Map<String, int> _monthStrings = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12
  };

  Map<String, int> correctMonthDays = {
    'January': 31,
    'February': 28,
    'March': 31,
    'April': 30,
    'May': 31,
    'June': 30,
    'July': 31,
    'August': 31,
    'September': 30,
    'October': 31,
    'November': 30,
    'December': 30,
  };

  @override
  void initState() {
    if (_month != null) {
      for (int i = 1; i <= correctMonthDays[_month]; i++) {
        _days.add(i.toString());
      }
    }
    for (int i = DateTime.now().year; i > DateTime.now().year - 100; i--) {
      _years.add(i.toString());
    }
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      account = ModalRoute.of(context).settings.arguments as Account;
      _data = Provider.of<BasicDetailsProvider>(context).item;
      print(_data.birthday);
      print(_data.birthday.day);
      print(_data.birthday.month);
      print(_data.birthday.year);
      _initValue = {
        'first_name': _data.firstName,
        'lastName': _data.lastName,
        'gender': _data.gender,
        'birthday':
            '${_data.birthday.year}-${_data.birthday.month}-${_data.birthday.day}',
        'phoneNumber': _data.phoneNumber,
        'email': _data.email,
        'password': _data.password
      };
      _gender = _data.gender;
      _day = _data.birthday.day.toString();
      String temp;
      _monthStrings.forEach((key, value) {
        if (value == _data.birthday.month) {
          temp = key;
        }
      });
      _month = temp;
      _year = _data.birthday.year.toString();
      setState(() {
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  void _submit() {
    _formKey.currentState.save();
    var temp = '';
    if (account is UserAccount) {
      temp = '$ipAddress/edit/user/basicdetails';
    } else {
      temp = '$ipAddress/edit/freelancer/basicdetails';
    }
    Provider.of<BasicDetailsProvider>(context, listen: false)
        .editBasicDetailsProvider(_data, account.userId, temp);
    Navigator.of(context).pop();
  }

  Size _deviceSize;

  BasicDetails noChange() {
    return _data = BasicDetails(
      id: _data.id,
      firstName: _data.firstName,
      lastName: _data.lastName,
      gender: _data.gender,
      birthday: _data.birthday,
      email: _data.email,
      password: _data.password,
      phoneNumber: _data.phoneNumber,
    );
  }

  Widget textField(
      String initValue,
      TextInputType textInputType,
      String labelText,
      TextInputAction textInputAction,
      Function validator,
      Function onSaved) {
    print(initValue);
    return TextFormField(
      initialValue: initValue.toString(),
      keyboardType: textInputType,
      decoration: InputDecoration(labelText: labelText),
      textInputAction: textInputAction,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget dropdownButton(
    dropdownButtonType type,
    List<String> items,
    String hint,
  ) {
    return Container(
      width: type != dropdownButtonType.gender
          ? _deviceSize.width * 0.27
          : _deviceSize.width * 95,
      height: _deviceSize.height * 0.085,
      margin: EdgeInsets.only(bottom: 10.7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
            color: Colors.black54, style: BorderStyle.solid, width: 3.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: DropdownButton<String>(
          isExpanded: true,
          focusColor: Colors.white,
          value: type == dropdownButtonType.day
              ? _day
              : type == dropdownButtonType.month
                  ? _month
                  : type == dropdownButtonType.year
                      ? _year
                      : _gender,
          style: TextStyle(color: Colors.white),
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          hint: Text(hint),
          onChanged: (String value) {
            setState(() {
              type == dropdownButtonType.day
                  ? _day = value
                  : type == dropdownButtonType.month
                      ? _month = value
                      : type == dropdownButtonType.year
                          ? _year = value
                          : _gender = value;
            });
            type == dropdownButtonType.year
                ? _data = BasicDetails(
                    id: _data.id,
                    firstName: _data.firstName,
                    lastName: _data.lastName,
                    email: _data.email,
                    password: _data.password,
                    phoneNumber: _data.phoneNumber,
                    birthday: DateTime(
                      int.parse(value),
                      _data.birthday.month,
                      _data.birthday.day,
                    ),
                    gender: _data.gender,
                  )
                : type == dropdownButtonType.month
                    ? _data = BasicDetails(
                        id: _data.id,
                        firstName: _data.firstName,
                        lastName: _data.lastName,
                        email: _data.email,
                        password: _data.password,
                        phoneNumber: _data.phoneNumber,
                        birthday: DateTime(
                          _data.birthday.year,
                          value == 'December' ? 12 : 7,
                          _data.birthday.day,
                        ),
                        gender: _data.gender,
                      )
                    : type == dropdownButtonType.day
                        ? _data = BasicDetails(
                            id: _data.id,
                            firstName: _data.firstName,
                            lastName: _data.lastName,
                            email: _data.email,
                            password: _data.password,
                            phoneNumber: _data.phoneNumber,
                            birthday: DateTime(
                              _data.birthday.year,
                              _data.birthday.month,
                              int.parse(value),
                            ),
                            gender: _data.gender,
                          )
                        : type == dropdownButtonType.gender
                            ? _data = BasicDetails(
                                id: _data.id,
                                firstName: _data.firstName,
                                lastName: _data.lastName,
                                email: _data.email,
                                password: _data.password,
                                phoneNumber: _data.phoneNumber,
                                birthday: _data.birthday,
                                gender: value,
                              )
                            : print('Somthing is not right');
            type == dropdownButtonType.year
                ? _initValue['birthday'] = DateTime(
                    int.parse(value),
                    _data.birthday.month,
                    _data.birthday.day,
                  ).toIso8601String()
                : type == dropdownButtonType.month
                    ? _initValue['birthday'] = DateTime(
                        _data.birthday.year,
                        _monthStrings[value],
                        _data.birthday.day,
                      ).toIso8601String()
                    : type == dropdownButtonType.day
                        ? _initValue['birthday'] = DateTime(
                            _data.birthday.year,
                            _data.birthday.month,
                            int.parse(value),
                          ).toIso8601String()
                        : type == dropdownButtonType.gender
                            ? _initValue['gender'] = value
                            : print('Something went wrong');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_month != null) {
      _days.clear();
      for (int i = 1; i <= correctMonthDays[_month]; i++) {
        _days.add(i.toString());
      }
    }
    _deviceSize = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Basic Information'),
          actions: [IconButton(icon: Icon(Icons.save), onPressed: _submit)],
        ),
        body: _isInit
            ? LinearProgressIndicator()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      textField(_initValue['first_name'], TextInputType.text,
                          'First Name', TextInputAction.next, (value) {
                        if (value.isEmpty) {
                          return 'Please fill this field';
                        }
                        return null;
                      }, (value) {
                        print(value);
                        if (value.isEmpty) {
                          noChange();
                        } else {
                          _data = BasicDetails(
                            id: _data.id,
                            firstName: value,
                            lastName: _data.lastName,
                            gender: _data.gender,
                            birthday: _data.birthday,
                            email: _data.email,
                            password: _data.password,
                            phoneNumber: _data.phoneNumber,
                          );
                        }
                      }),
                      textField(_initValue['lastName'], TextInputType.text,
                          'Last Name', TextInputAction.next, (value) {
                        if (value.isEmpty) {
                          return 'Please fill this field';
                        }
                        return null;
                      }, (value) {
                        if (value.isEmpty) {
                          noChange();
                        } else {
                          _data = BasicDetails(
                            id: _data.id,
                            firstName: _data.firstName,
                            lastName: value,
                            gender: _data.gender,
                            birthday: _data.birthday,
                            email: _data.email,
                            password: _data.password,
                            phoneNumber: _data.phoneNumber,
                          );
                        }
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          dropdownButton(
                              dropdownButtonType.month, _months, 'Month'),
                          dropdownButton(dropdownButtonType.day, _days, 'Day'),
                          dropdownButton(
                              dropdownButtonType.year, _years, 'Year'),
                        ],
                      ),
                      dropdownButton(
                          dropdownButtonType.gender, _genders, 'Gender'),
                      SizedBox(
                        height: 10,
                      ),
                      textField(
                          _initValue['phoneNumber'],
                          TextInputType.number,
                          'Phone Number',
                          TextInputAction.done,
                          (_) {}, (value) {
                        print(value);
                        _data = BasicDetails(
                          id: _data.id,
                          firstName: _data.firstName,
                          lastName: _data.lastName,
                          gender: _data.gender,
                          birthday: _data.birthday,
                          email: _data.email,
                          password: _data.password,
                          phoneNumber: value,
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
