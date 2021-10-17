// @dart= 2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../global_stuff.dart';
import '../../providers/job.dart';
import '../../widget/job_item.dart';
import '../../providers/accounts.dart';
import '../../providers/job_business.dart';

class UserRequest extends StatefulWidget {
  static const routeName = 'user-request';
  @override
  _UserRequestState createState() => _UserRequestState();
}

class _UserRequestState extends State<UserRequest> {
  List<Job> jobs;
  Account user;
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      user = ModalRoute.of(context).settings.arguments as Account;
      await Provider.of<JobBusiness>(context, listen: false)
          .specificJobs('$ipAddress/user/get_applied_job', user.userId);
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<JobBusiness>(context, listen: false)
        .specificJobs('$ipAddress/user/get_applied_job', user.userId);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    jobs = Provider.of<JobBusiness>(context).getRequests;
    return Scaffold(
        appBar: AppBar(
          title: Text('My requests'),
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : jobs.isEmpty
                  ? Center(child: Text('You haven\'t send any request yet'))
                  : Scrollbar(
                      child: ListView.builder(
                          itemCount: jobs.length,
                          itemBuilder: (ctx, index) =>
                              JobItem(jobs[index], user, 1,false)),
                    ),
        ));
  }
}
