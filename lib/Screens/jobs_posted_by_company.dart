//@dart=2.9

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widget/app_drawer.dart';
import 'package:provider/provider.dart';

import '../global_stuff.dart';
import '../providers/job.dart';
import '../providers/accounts.dart';
import '../providers/job_business.dart';
import 'add_details_screens/add_new_company_job.dart';
import 'applicants_for_a_job.dart';

class JobsPostedByCompany extends StatefulWidget {
  static const routeName = 'home-page-company';
  final CompanyAccount account;
  JobsPostedByCompany(this.account);

  @override
  _JobsPostedByCompanyState createState() => _JobsPostedByCompanyState();
}

class _JobsPostedByCompanyState extends State<JobsPostedByCompany> {
  var _isInit = true;
  var _isLoading = false;
  var data;
  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<JobBusiness>(context, listen: false)
          .fetchAndSetJobs('$ipAddress/company/get_all_its_job_offers',
              widget.account.userId)
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
    Provider.of<JobBusiness>(context, listen: false)
        .fetchAndSetJobs(
            '$ipAddress/company/get_all_its_job_offers', widget.account.userId)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Job> _jobsData = Provider.of<JobBusiness>(context).jobsItem;
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobless?'),
      ),
      drawer: AppDrawer(widget.account),
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
                      subtitle: Text(DateFormat('yMMMd')
                          .format(_jobsData[index].dateOfPublication)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ApplicantsForAJob(
                                false, _jobsData[index], widget.account),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        radius: 40,
                        child: _jobsData[index].image != null
                            ? Image.file(_jobsData[index].image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,)
                            : Icon(
                                Icons.person,
                                size: 40,
                              ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: Text('Delete this offer'),
                                    content: GestureDetector(
                                      child: Text('Are you sure'),
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
                                            Provider.of<JobBusiness>(context,
                                                    listen: false)
                                                .deleteJob(_jobsData[index].id);
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
                                          AddNewCompanyJob.routeName,
                                          arguments: _jobsData[index].id);
                                    },
                                  ),
                                ));
                      },
                    );
                  },
                ),
              ),
            ),
    );
  }
}
