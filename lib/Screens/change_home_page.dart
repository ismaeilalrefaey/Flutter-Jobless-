//@dart=2.9
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../Screens/all_freelancers_screen.dart';
import '../providers/accounts.dart';
import '../Screens/jobs_overview_screen.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  static const routeName = 'home-screen';
  Account account;
  HomePage({this.account});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> pages = [];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    pages = [JobOverviewScreen(widget.account), AllFreelancers()];
    return Scaffold(
      body: pages[selectedIndex],
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Theme.of(context).primaryColor,
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
        items: [
          Icon(Icons.home, color: Colors.grey[800], size: 45),
          Icon(Icons.verified_user_sharp, color: Colors.grey[800], size: 45),
        ],
      ),
    );
  }
}
