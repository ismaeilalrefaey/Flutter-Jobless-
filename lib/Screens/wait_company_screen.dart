// @dart=2.9

import 'package:flutter/material.dart';

class WaitComapanyScreen extends StatelessWidget {
  static const routeName = 'wait-company-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jonbless?'),
      ),
      body: Center(
        child: Text('please wait for the admin to approve your request'),
      ),
    );
  }
}
