//@dart=2.9

import 'package:flutter/material.dart';
import '../widget/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../global_stuff.dart';
import '../widget/job_item.dart';
import '../providers/job_business.dart';
import '../providers/freelance_offer.dart';
import '../widget/freelance_offer_item.dart';

class GuestScreen extends StatefulWidget {
  static const routeName = '/guest-screen';

  @override
  _GuestScreenState createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  List<Widget> pages = [NewFreelanceOffers(), NewJobs()];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jobless?',
        ),
      ),
      drawer: AppDrawer(null),
      body: pages[selectedIndex],
      backgroundColor: Colors.blue,
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.blue,
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
        items: [
          Icon(Icons.work, color: Colors.black, size: 25),
          Icon(Icons.home_work, color: Colors.black, size: 25),
        ],
      ),
    );
  }
}

class NewFreelanceOffers extends StatefulWidget {
  @override
  _NewFreelanceOffers createState() => _NewFreelanceOffers();
}

class _NewFreelanceOffers extends State<NewFreelanceOffers> {
  var _isInit = true;
  var _isLoading = false;
  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<FreelanceOfferBusiness>(context, listen: false)
          .fetchAndSetOffers(
        '$ipAddress/guest/get_all_frjob',
        null,
      )
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshJobs(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<FreelanceOfferBusiness>(context, listen: false)
        .fetchAndSetOffers(
      '$ipAddress/guest/get_all_frjob',
      null,
    )
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    final _freelanceOfferData = Provider.of<FreelanceOfferBusiness>(context);
    return Container(
      padding: EdgeInsets.all(8),
      child: _isLoading
          ? LinearProgressIndicator()
          : RefreshIndicator(
              onRefresh: () => _refreshJobs(context),
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: _freelanceOfferData.freeLanceItem.length,
                  itemBuilder: (_, index) => Column(
                    children: <Widget>[
                      FreelanceOfferItem(
                          _freelanceOfferData.freeLanceItem[index],
                          null,
                          null,
                          true)
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class NewJobs extends StatefulWidget {
  @override
  _NewJobsState createState() => _NewJobsState();
}

class _NewJobsState extends State<NewJobs> {
  var _isInit = true;
  var _isLoading = false;
  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<JobBusiness>(context, listen: false)
          .fetchAndSetJobs(
        '$ipAddress/guest/get_all_job',
        null,
      )
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshJobs(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<JobBusiness>(context, listen: false)
        .fetchAndSetJobs(
      '$ipAddress/guest/get_all_job',
      null,
    )
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _jobsData = Provider.of<JobBusiness>(context);
    return Container(
      padding: EdgeInsets.all(8),
      child: _isLoading
          ? LinearProgressIndicator()
          : RefreshIndicator(
              onRefresh: () => _refreshJobs(context),
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: _jobsData.jobsItem.length,
                  itemBuilder: (_, index) =>
                      // yroro
                      JobItem(_jobsData.jobsItem[index], null, null, true),
                      // JobItem(_jobsData.jobsItem[index], null, 1, true),
                ),
              ),
            ),
    );
  }
}
