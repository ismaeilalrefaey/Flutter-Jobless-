//@dart=2.9
import 'package:flutter/material.dart';
import '../../Screens/wait_company_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';

class SignUpCompany extends StatefulWidget {
  static const routeName = '/sign-up-company';

  @override
  _SignUpCompanyState createState() => _SignUpCompanyState();
}

class _SignUpCompanyState extends State<SignUpCompany> {
  Map<String, String> _signData = {'name': '', 'email': '', 'password': ''};
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: message == 'Exception: Wait for the Admin to approve'
            ? Text('Submitted')
            : Text('An Error Occurred !!'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
              if (message == 'Exception: Wait for the Admin to approve') {
                Navigator.of(context)
                    .pushReplacementNamed(WaitComapanyScreen.routeName);
              }
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
    try {
      await Provider.of<Authentication>(context, listen: false)
          .signup(_signData, '/signup/company', 'Company');
    } catch (error) {
      _signData = {'name': '', 'email': '', 'password': ''};
      _showErrorDialog(error.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 50),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Sign Up', style: TextStyle(fontSize: 30)),
                SizedBox(height: 10),
                Text('Enter your basic information',
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Company Name',
                  ),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) return 'This field can\'t be empty !!';
                    return null;
                  },
                  onSaved: (value) {
                    _signData['name'] = value;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-mail',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@'))
                      return 'Invalid email!';
                    return null;
                  },
                  onSaved: (value) {
                    _signData['email'] = value;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 8)
                      return 'Password is too short!';
                    return null;
                  },
                  onSaved: (value) {
                    _signData['password'] = value;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value != _passwordController.text)
                      return 'Passwords do not match!';
                    return null;
                  },
                ),
                SizedBox(height: deviceSize.height * 0.27),
                Align(
                  alignment: Alignment.bottomRight,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          child: Text('Sign Up'),
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            textStyle: TextStyle(fontSize: 18),
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
