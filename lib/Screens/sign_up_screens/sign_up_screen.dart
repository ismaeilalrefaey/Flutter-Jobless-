//@dart=2.9

import 'package:flutter/material.dart';
import '../jobs_overview_screen.dart';
import '../../providers/accounts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import '../../models/http_exceptions.dart';

enum dropdownButtonType {
  day,
  month,
  year,
  gender,
}

class SignUp extends StatefulWidget {
  static const routeName = '/Sign-up';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var deviceSize;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  List<String> _months = [
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
      ],
      _days = [],
      _years = [];
  Map<String, int> _correctMonthDays = {
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
  final List<String> _genders = ['Male', 'Female'];
  var _isLoading = false;
  Map<String, String> _signData = {
    'first_name': '',
    'last_name': '',
    'day': '',
    'month': '',
    'year': '',
    'gender': '',
    'email': '',
    'password': ''
  };

  Map<String, int> _monthsNumbers = {
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
  String _month, _day, _year;
  String _gender;

  @override
  void initState() {
    if (_month != null) {
      for (int i = 1; i <= _correctMonthDays[_month]; i++) {
        _days.add(i.toString());
      }
    }
    for (int i = DateTime.now().year; i > DateTime.now().year - 100; i--) {
      _years.add(i.toString());
    }
    super.initState();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred !!'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      print('Invalid!');
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final String choice = ModalRoute.of(context)
        .settings
        .arguments; 
    try {
      var account = await Provider.of<Authentication>(context, listen: false)
              .signup(_signData, '/signup/${choice.toLowerCase()}', choice)
          as Account;
      Navigator.of(context).pushReplacementNamed(JobOverviewScreen.routeName,
          arguments: account);
    } on HttpExceptions catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog(error.toString());
      _signData = {
        'first_name': '',
        'last_name': '',
        'day': '',
        'month': '',
        'year': '',
        'gender': '',
        'email': '',
        'password': ''
      };
      _day = null;
      _month = null;
      _year = null;
      _gender = null;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget dropdownButton(
    dropdownButtonType type,
    List<String> items,
    String hint,
  ) {
    return Container(
      width: type != dropdownButtonType.gender
          ? deviceSize.width * 0.27
          : deviceSize.width * 95,
      height: deviceSize.height * 0.085,
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
              child: Text(value, style: TextStyle(color: Colors.black)),
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
            if (type == dropdownButtonType.month) {
              if (_monthsNumbers[value] < 10) {
                _signData[hint.toLowerCase()] =
                    '0${_monthsNumbers[value].toString()}';
              } else
                _signData[hint.toLowerCase()] =
                    _monthsNumbers[value].toString();
            } else if (type == dropdownButtonType.day) {
              if (int.parse(value) < 10) {
                _signData[hint.toLowerCase()] = '0$value';
              } else
                _signData[hint.toLowerCase()] = value;
            } else
              _signData[hint.toLowerCase()] = value;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_month != null) {
      _days.clear();
      for (int i = 1; i <= _correctMonthDays[_month]; i++) {
        _days.add(i.toString());
      }
    }
    deviceSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 50),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Sign in', style: TextStyle(fontSize: 30)),
                SizedBox(height: 10),
                Text('Enter your basic information',
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // First Name
                      Container(
                        width: deviceSize.width * 0.40,
                        height: deviceSize.width * 0.20,
                        child: TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2)),
                            border: OutlineInputBorder(),
                            labelText: 'First Name',
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            _signData['first_name'] = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Eneter your First Name';
                            }
                            return null;
                          },
                        ),
                      ),

                      // Last Name
                      Container(
                        width: deviceSize.width * 0.40,
                        height: deviceSize.width * 0.20,
                        child: TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2)),
                            border: OutlineInputBorder(),
                            labelText: 'Last Name',
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            _signData['last_name'] = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter your Last Name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    dropdownButton(dropdownButtonType.month, _months, 'Month'),
                    dropdownButton(dropdownButtonType.day, _days, 'Day'),
                    dropdownButton(dropdownButtonType.year, _years, 'Year'),
                  ],
                ),
                dropdownButton(dropdownButtonType.gender, _genders, 'Gender'),
                SizedBox(height: 15),

                // Email
                TextFormField(
                  decoration: InputDecoration(
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide(width: 2)),
                    border: OutlineInputBorder(),
                    labelText: 'E-mail',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _signData['email'] = value;
                  },
                ),
                SizedBox(height: 15),

                // Password
                TextFormField(
                  decoration: InputDecoration(
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide(width: 2)),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 8) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _signData['password'] = value;
                  },
                ),
                SizedBox(height: 15),

                // Confirm Password
                TextFormField(
                  decoration: InputDecoration(
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide(width: 2)),
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),

                // Sign up button
                Align(
                  alignment: Alignment.bottomRight,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          child: Text('Sign Up'),
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
