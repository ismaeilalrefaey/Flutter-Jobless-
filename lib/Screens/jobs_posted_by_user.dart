//@dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global_stuff.dart';
import '../providers/job_business.dart';
import '../providers/freelance_offer.dart';
import '../Screens/applicants_for_a_job.dart';
import '../Screens/add_details_screens/add_new_freelance_offer_screen.dart';

class JobsPostedByUser extends StatefulWidget {
  static const routeName = '/jobs-listed-by-company-screen';

  @override
  _JobsListedByCompanyScreenState createState() =>
      _JobsListedByCompanyScreenState();
}

class _JobsListedByCompanyScreenState extends State<JobsPostedByUser> {
  var _isInit = true;
  var _isLoading = false;
  var data;

  /// I need the number of users applied for each job

  // var isUser;
  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      print(
          'i\'m in didChange, current account\'s id is: ${data['account'].userId}');
      Provider.of<FreelanceOfferBusiness>(context, listen: false)
          .fetchAndSetOffers('$ipAddress/user/get_all_its_frjob_offers',
              data['account'].userId)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<FreelanceOfferBusiness>(context, listen: false)
        .fetchAndSetOffers(
            '$ipAddress/user/get_all_its_frjob_offers', data['account'].userId)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _jobsData;
    if (!data['is_user']) {
      _jobsData = Provider.of<JobBusiness>(context).jobsItem;
    } else {
      _jobsData = Provider.of<FreelanceOfferBusiness>(context).freeLanceItem;
    }
    _jobsData.forEach((job) {
      print('job id');
      print(job.id);
    });
    var object = data['account'];
    // var isUser = true;
    return Scaffold(
      // drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Current Freelance Offers'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddFreelanceOfferScreen.routeName,
                  arguments: null);
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: _jobsData.length,
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      title: Text(_jobsData[index].title),
                      subtitle:
                          Text(_jobsData[index].dateOfPublication.toString()),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ApplicantsForAJob(
                                true, _jobsData[index], object),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        radius: 40,
                        child: _jobsData[index].image != null
                            ? Image.file(
                                _jobsData[index].image,
                                // width: 100,
                                // height: 100,
                                fit: BoxFit.fill,
                              )
                            : Icon(
                                Icons.person,
                                size: 40,
                              ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        // delete this offer
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: Text('Delete this offer'),
                                    content: GestureDetector(
                                      child: Text('Are you sure'),
                                      // onTap: () {},
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop(false);
                                          },
                                          child: Text('No')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop(true);
                                            Provider.of<FreelanceOfferBusiness>(
                                                    context,
                                                    listen: false)
                                                .deleteOffer(
                                                    _jobsData[index].id);
                                          },
                                          child: Text('Yes')),
                                    ],
                                  ));
                        },
                      ),
                      // Edit this offer
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            content: GestureDetector(
                              child: Text('Edit this offer'),
                              onTap: () {
                                Navigator.of(ctx).pop(true);
                                Navigator.of(context).pushNamed(
                                    AddFreelanceOfferScreen.routeName,
                                    arguments: _jobsData[index].id);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
    );
  }
}
