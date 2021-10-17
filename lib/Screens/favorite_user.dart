//@dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global_stuff.dart';
import '../providers/job.dart';
import '../widget/job_item.dart';
import '../providers/accounts.dart';
import '../providers/job_business.dart';

class UserFavorite extends StatefulWidget {
  static const routeName = 'user-favorite';
  @override
  _UserFavoriteState createState() => _UserFavoriteState();
}

class _UserFavoriteState extends State<UserFavorite> {
  List<Job> jobs;
  Account user;
  var _isInit = true;
  var _isLoading = true;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      user = ModalRoute.of(context).settings.arguments as Account;
      await Provider.of<JobBusiness>(context, listen: false)
          .specificJobs('$ipAddress/user/favorite_job_offer', user.userId);
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
        .specificJobs('$ipAddress/user/favorite_job_offer', user.userId);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    jobs = Provider.of<JobBusiness>(context, listen: false).getFavorite;
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Favorite'),
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : jobs.isEmpty
                  ? Center(
                      child: Text('You haven\'t add any job to favorite yet'))
                  : Scrollbar(
                      child: ListView.builder(
                          itemCount: jobs.length,
                          itemBuilder: (ctx, index) =>
                              JobItem(jobs[index], user, null,false)),
                    ),
        ));
  }
}
