//@dart=2.9

import '../temp.dart';
import '../temp/Trie.dart';
import '../global_stuff.dart';
import '../providers/job.dart';
import '../providers/auth.dart';
import '../widget/job_item.dart';
import '../models/location.dart';
import '../widget/app_drawer.dart';
import '../providers/accounts.dart';
import '../Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/job_business.dart';
import '../Screens/select_location.dart';
import '../services/world_locations.dart';
import '../providers/freelance_offer.dart';
import '../Screens/notification_screen.dart';
import '../services/GPS_access_service.dart';
import '../widget/freelance_offer_item.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class JobOverviewScreen extends StatefulWidget {
  static const routeName = 'job-overview';
  final Account account;
  @override
  _JobOverviewScreenState createState() => _JobOverviewScreenState();
  JobOverviewScreen(this.account);
}

class _JobOverviewScreenState extends State<JobOverviewScreen> {
  var _user;
  String selectedCity, selectedCountry;
  // Map<String, List<UserLocation>> map;
  final searchController = TextEditingController();
  var _isSearching = false;
  var _isInit = true;
  var _isLoading = false;

  void assigning(String city, String country) {
    selectedCity = city;
    selectedCountry = country;
  }

  void _search(value) {
    setState(() {
      print('search');
      _isLoading = true;
    });
    if (_user) {
      Provider.of<JobBusiness>(context, listen: false)
          .searchAboutJobs(value, widget.account.userId)
          .then((_) {
        setState(() {
          _isSearching = false;
          _isLoading = false;
        });
      });
    } else {
      Provider.of<FreelanceOfferBusiness>(context, listen: false)
          .searchAboutOffers(value, widget.account.userId)
          .then((_) {
        setState(() {
          _isSearching = false;
          _isLoading = false;
        });
      });
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _user = Provider.of<Authentication>(context, listen: false).type ==
              AccountType.User
          ? true
          : false;
      if (_user) {
        Provider.of<JobBusiness>(context, listen: false)
            .fetchAndSetJobs(
          '$ipAddress/user/all_job_offers',
          widget.account.userId,
        )
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        Provider.of<FreelanceOfferBusiness>(context, listen: false)
            .fetchAndSetOffers(
          '$ipAddress/freelancer/all_frJob_offers',
          widget.account.userId,
        )
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshJobs(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    if (_user) {
      Provider.of<JobBusiness>(context, listen: false)
          .fetchAndSetJobs(
        '$ipAddress/user/all_job_offers',
        widget.account.userId,
      )
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      Provider.of<FreelanceOfferBusiness>(context, listen: false)
          .fetchAndSetOffers(
        '$ipAddress/freelancer/all_frJob_offers',
        widget.account.userId,
      )
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Future<void> addFilterForUser(
    String date,
    String country,
    String city,
    String gender,
    String salary,
    String shift,
    String yearsOfExperience,
    UserLocation position,
  ) async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<JobBusiness>(context, listen: false)
        .addUserFilter(widget.account.userId, date, country, city, gender,
            salary, shift, yearsOfExperience, position)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> addFreelanceFilter(String date, String wage) async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<FreelanceOfferBusiness>(context, listen: false)
        .addFreelanceFilter(widget.account.userId, date, wage)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget _dropDowmButtonForJob(
      double width, String hint, List<String> item, Function function) {
    return Container(
        height: 60,
        width: width,
        margin: EdgeInsets.only(top: 3.0),
        padding: EdgeInsets.all(4.0),
        child: DropdownButton(
          hint: Text(hint),
          items: item
              .map<DropdownMenuItem<String>>((value) =>
                  DropdownMenuItem<String>(value: value, child: Text(value)))
              .toList(),
          onChanged: function,
        ));
  }

  Widget _dropDowmButtonForFreelance(
      double width, String hint, List<String> item, Function function) {
    return Container(
        height: 60,
        width: width,
        margin: EdgeInsets.only(top: 3.0),
        padding: EdgeInsets.all(4.0),
        child: DropdownButton(
          hint: Text(hint),
          items: item
              .map<DropdownMenuItem<String>>((value) =>
                  DropdownMenuItem<String>(value: value, child: Text(value)))
              .toList(),
          onChanged: function,
        ));
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<Authentication>(context).accountType == AccountType.User
        ? true
        : false;
    final deviceSize = MediaQuery.of(context).size;
    final _jobsData = Provider.of<JobBusiness>(context);
    final _freelanceOfferData = Provider.of<FreelanceOfferBusiness>(context);
    return Scaffold(
      drawer: AppDrawer(widget.account),
      appBar: AppBar(
        title: !_isSearching
            // ? TextField(
            //     textInputAction: TextInputAction.search,
            //     controller: searchController,
            //     onSubmitted: (value) => _search(value),
            //     decoration: InputDecoration(
            //         disabledBorder: InputBorder.none,
            //         hintText: _user ? 'Specialization' : 'Job Title'),
            //   )
            ? Text('Jobless?')
            : TypeAheadField(
                hideOnEmpty: true,
                hideOnLoading: true,
                hideSuggestionsOnKeyboardHide: true,
                animationDuration: Duration(milliseconds: 500),
                textFieldConfiguration: TextFieldConfiguration(
                  style: TextStyle(fontSize: 20),
                  textCapitalization: TextCapitalization.words,
                  // DefaultTextStyle.of(context).style.copyWith(fontSize: 20),
                  // decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                suggestionsCallback: (pattern) {
                  return [
                    pattern,
                    ...Trie().getAllWithPrefix(pattern),
                    ...dictionary
                        .where((element) =>
                            element.contains(pattern) &&
                            !element.startsWith(pattern))
                        .toList()
                  ]..sort((a, b) => a.compareTo(b));
                  // NearbyWords nearbyWords = NearbyWords(DictionaryHashSet());
                  // return nearbyWords.distanceOne(pattern, true);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: Icon(Icons.search),
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _search(suggestion);
                },
              ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              widget.account == null
                  ? Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName)
                  : Navigator.of(context).pushNamed(
                      NotificationsScreen.routeName,
                      arguments: widget.account.userId,
                    );
            },
          ),
        ],
      ),
      body: _user
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'filter by:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          //shrinkWrap: true,
                          child: ListView(
                            padding: EdgeInsets.all(8.0),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: <Widget>[
                              // 1 - Publication Date
                              _dropDowmButtonForJob(
                                170,
                                'Publication Date',
                                [
                                  'last 24 hours',
                                  'last week',
                                  'last 15 days',
                                  'last month'
                                ],
                                (value) {
                                  addFilterForUser(
                                    value,
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                  );
                                },
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              // 2-3 - Location
                              _dropDowmButtonForJob(
                                190,
                                'Location',
                                [
                                  'Manual selection', // country and city
                                  'Auto detect via GPS',
                                ],
                                (value) async {
                                  if (value == 'Manual selection') {
                                    //select
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectLocation(
                                                    assigning, locationsV2)));
                                    if (selectedCountry != null) {
                                      addFilterForUser(
                                        null,
                                        selectedCountry,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                      );
                                      if (selectedCity != null) {
                                        addFilterForUser(
                                          null,
                                          null,
                                          selectedCity,
                                          null,
                                          null,
                                          null,
                                          null,
                                          null,
                                        );
                                      }
                                    }
                                  } else {
                                    // GPS
                                    UserLocation userLocation =
                                        await GPSAccessService()
                                            .getCurrentLocation();
                                    userLocation.setToNearestKnownLocation();
                                    print(userLocation);
                                    addFilterForUser(
                                      null,
                                      null,
                                      null,
                                      null,
                                      null,
                                      null,
                                      null,
                                      userLocation,
                                    );
                                  }
                                },
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              // 4 - Salary
                              _dropDowmButtonForJob(170, 'Salary', [
                                'Less than 1000\$',
                                '1000\$ - 2000\$',
                                '2000\$ - 5000\$',
                                'More than 5000\$',
                              ], (value) {
                                addFilterForUser(
                                  null,
                                  null,
                                  null,
                                  null,
                                  value,
                                  null,
                                  null,
                                  null,
                                );
                              }),
                              SizedBox(
                                width: 15,
                              ),
                              // 5 - Gender
                              _dropDowmButtonForJob(100, 'Gender', [
                                'Female',
                                'Male',
                              ], (value) {
                                addFilterForUser(
                                  null,
                                  null,
                                  null,
                                  value,
                                  null,
                                  null,
                                  null,
                                  null,
                                );
                              }),
                              SizedBox(
                                width: 15,
                              ),
                              // 6 - Shift
                              _dropDowmButtonForJob(120, 'Shift',
                                  ['Daytime', 'Evening', 'Midnight'], (value) {
                                addFilterForUser(
                                  null,
                                  null,
                                  null,
                                  null,
                                  null,
                                  value,
                                  null,
                                  null,
                                );
                              }),
                              SizedBox(
                                width: 15,
                              ),
                              // 7 - Years of experience
                              _dropDowmButtonForJob(
                                  200, 'Years of experience', [
                                'Less than 3 years',
                                '3 - 5 years',
                                'More than 5 years'
                              ], (value) {
                                addFilterForUser(
                                  null,
                                  null,
                                  null,
                                  null,
                                  null,
                                  null,
                                  value,
                                  null,
                                );
                              }),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  _isLoading
                      ? LinearProgressIndicator()
                      : RefreshIndicator(
                          onRefresh: () => _refreshJobs(context),
                          child: Container(
                              height: deviceSize.height * 0.78,
                              padding: EdgeInsets.all(8.0),
                              child: Scrollbar(
                                child: ListView.builder(
                                  itemCount: _jobsData.jobsItem.length,
                                  itemBuilder: (_, index) => JobItem(
                                      _jobsData.jobsItem[index],
                                      widget.account,
                                      null,
                                      false),
                                ),
                              )),
                        ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'filter by:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          //shrinkWrap: true,
                          child: ListView(
                            padding: EdgeInsets.all(8.0),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: <Widget>[
                              // 1 - publication date
                              _dropDowmButtonForFreelance(
                                  150, 'Publication Date', [
                                'last 24 hours',
                                'last week',
                                'last 15 days',
                                'last month'
                              ], (value) {
                                addFreelanceFilter(value, null);
                              }),
                              SizedBox(
                                width: 15,
                              ),
                              // 2 - wage
                              _dropDowmButtonForFreelance(
                                180,
                                'Wage',
                                [
                                  'Less than 200\$',
                                  '200\$ - 500\$',
                                  '500\$ - 1000\$',
                                  'More than 1000\$',
                                ],
                                (value) {
                                  addFreelanceFilter(null, value);
                                },
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  _isLoading
                      ? LinearProgressIndicator()
                      : RefreshIndicator(
                          onRefresh: () => _refreshJobs(context),
                          child: Container(
                            height: deviceSize.height * 0.78,
                            padding: EdgeInsets.all(8.0),
                            child: Scrollbar(
                              child: ListView.builder(
                                itemCount:
                                    _freelanceOfferData.freeLanceItem.length,
                                itemBuilder: (_, index) => Column(
                                  children: <Widget>[
                                    FreelanceOfferItem(
                                        _freelanceOfferData
                                            .freeLanceItem[index],
                                        widget.account,
                                        null,
                                        false)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
