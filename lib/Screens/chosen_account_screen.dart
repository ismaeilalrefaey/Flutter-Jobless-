import 'package:flutter/material.dart';
import 'sign_up_screens/sign_up_company_screen.dart';
import 'sign_up_screens/sign_up_screen.dart';

class ChosenAccount extends StatelessWidget {
  static const routeName = '/chosen-account';

  Widget _button(String textLabel, BuildContext ctx, String routeName) {
    return Container(
      height: 50,
      child: ElevatedButton(
        child: Text(textLabel, style: TextStyle(fontSize: 20)),
        onPressed: () {
          Navigator.of(ctx).pushNamed(routeName, arguments: textLabel);
        },
        style: ElevatedButton.styleFrom(
          elevation: 10.0,
          primary: Colors.white,
          onPrimary: Colors.green,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _button('Company', context, SignUpCompany.routeName),
            SizedBox(height: 10),
            _button('User', context, SignUp.routeName),
            SizedBox(height: 10),
            _button('Freelancer', context, SignUp.routeName),
          ],
        ),
      ),
    );
  }
}
