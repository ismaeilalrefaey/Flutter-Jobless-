//@dart=2.9
import 'package:flutter/material.dart';
import '../Screens/guest_screen.dart';
import '../Screens/jobs_overview_screen.dart';
import '../providers/auth.dart';
import 'chosen_account_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    print(deviceSize);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      // Outside
      body: Container(
        height: deviceSize.height,
        width: deviceSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 1),
            // Logo
            Expanded(child: LoginCard()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text('Sign up', style: TextStyle(fontSize: 16)),
                  onPressed: () {
                    Navigator.of(context).pushNamed(ChosenAccount.routeName);
                  },
                ),
                TextButton(
                  child: Text('Skip', style: TextStyle(fontSize: 16)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => GuestScreen(),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LoginCard extends StatefulWidget {
  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard>
    with SingleTickerProviderStateMixin {
  final _passwordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _loginData = {
    'email': '',
    'username': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

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
    var body = {'password': _loginData['password']};
    _loginData['email'] != ''
        ? body['email'] = _loginData['email']
        : body['login_id'] = _loginData['username'].toString();
    try {
      // Try to login <=> Authenticate from Database
      print('Trying to Login...');
      await Provider.of<Authentication>(context, listen: false).login(body,
          _loginData['email'] != '' ? '/login/byemail' : '/login/byloginid');
    } catch (error) {
      _showErrorDialog(error.toString());
      _loginData = {
        'email': '',
        'username': '',
        'password': '',
      };
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 1),
            Column(
              children: [
                // Welcoming the User
                Container(
                  child: Text(
                    'Welcome back !!',
                    style: TextStyle(fontSize: 40, color: Colors.black),
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  child: Text(
                    'Enter your credentials to login',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                Container(
                  height: 240,
                  constraints: BoxConstraints(minHeight: 280),
                  width: deviceSize.width * 0.85,
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        // Email
                        TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3)),
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          onFieldSubmitted: (value) {
                            !value.contains('@')
                                ? _loginData['username'] = value
                                : _loginData['email'] = value;
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.contains(RegExp(r'[a-zA-Z]')) &&
                                (!value.contains('.') || !value.contains('@')))
                              return 'Invalid email !!';
                            if (value.isEmpty)
                              return 'This field can\'t be empty !!';
                            return null;
                          },
                          onSaved: (value) {
                            !value.contains('@')
                                ? _loginData['username'] = value
                                : _loginData['email'] = value;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 15),
                        // Password
                        TextFormField(
                          focusNode: _passwordFocusNode,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3)),
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          controller: _passwordController,
                          validator: (value) {
                            if (value.isEmpty || value.length < 8)
                              return 'password is too short!';
                            return null;
                          },
                          onSaved: (value) {
                            _loginData['password'] = value;
                          },
                          // onFieldSubmitted: (_) => _submit,
                        ),
                        SizedBox(height: 20),
                        if (_isLoading)
                          CircularProgressIndicator()
                        else
                          // Login button
                          ElevatedButton(
                            child: Text('LOGIN'),
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 8.0,
                              ),
                              primary: Theme.of(context).primaryColor,
                              textStyle: TextStyle(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .color,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Spacer(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     TextButton(
            //       child: Text('Sign up', style: TextStyle(fontSize: 16)),
            //       onPressed: () {
            //         Navigator.of(context).pushNamed(ChosenAccount.routeName);
            //       },
            //     ),
            //     TextButton(
            //       child: Text('Skip', style: TextStyle(fontSize: 16)),
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (ctx) => JobOverviewScreen(null),
            //           ),
            //         );
            //       },
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
