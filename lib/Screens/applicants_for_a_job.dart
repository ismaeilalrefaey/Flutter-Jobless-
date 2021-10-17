//@dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/userItem.dart';
import '../providers/accounts.dart';
import '../widget/freelance_item.dart';
import '../providers/job_business.dart';

// ignore: must_be_immutable
class ApplicantsForAJob extends StatefulWidget {
  var job;
  Account account;
  bool isFreelancer;

  ApplicantsForAJob(this.isFreelancer, this.job, this.account);
  @override
  _ApplicantsForAJobState createState() => _ApplicantsForAJobState();
}

class _ApplicantsForAJobState extends State<ApplicantsForAJob> {
  var _isInit = true;
  var _isLoading = false;
  var _applicants;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      // fetsh all freelancer applied
      if (widget.isFreelancer) {
        print(widget.job.id);
        Provider.of<FreelancerAccount>(context, listen: false)
            .getFreelancersAppliedForAJob(widget.job.id)
            .then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      }
      // fetsh all user applied
      else {
        Provider.of<JobBusiness>(context, listen: false)
            .getAllUsersAppliedForAJob(widget.job.id)
            .then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      }
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  // refresh
  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });
    if (widget.isFreelancer) {
      await Provider.of<FreelancerAccount>(context, listen: false)
          .getFreelancersAppliedForAJob(widget.job.id)
          .then((value) {
        setState(() {
          _applicants =
              Provider.of<FreelancerAccount>(context).allFreelancersApplied;
          _isLoading = false;
        });
      });
    } else {
      Provider.of<JobBusiness>(context, listen: false)
          .getAllUsersAppliedForAJob(widget.job.id)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  // company filter its job requests
  Future<void> addCompanyJobFilter(
      String age, String gender, String graduate) async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<JobBusiness>(context, listen: false)
        .filterUsersApplied(widget.job.id, age, gender, graduate)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  // user filter his offer requests
  Future<void> addUserOfferFilter(String rate) async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<FreelancerAccount>(context, listen: false)
        .filterFreelancerApplied(widget.job.id, rate)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget _dropDowmButton(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFreelancer) {
      _applicants =
          Provider.of<FreelancerAccount>(context).allFreelancersApplied;
    } else {
      _applicants = Provider.of<JobBusiness>(context).usersApplied;
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.job.title)),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'filter by:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      if (!widget.isFreelancer)
                        // 1
                        _dropDowmButton(100, 'Gender', [
                          'Female',
                          'Male',
                        ], (value) {
                          addCompanyJobFilter(null, value, null);
                        }),
                      if (!widget.isFreelancer)
                        SizedBox(
                          width: 15,
                        ),
                      if (!widget.isFreelancer)
                        _dropDowmButton(180, 'age', [
                          '20 - 25',
                          '25 - 30',
                          '30 - 40',
                          'More than 40'
                        ], (value) {
                          addCompanyJobFilter(value, null, null);
                        }),
                      if (!widget.isFreelancer)
                        SizedBox(
                          width: 15,
                        ),
                      if (!widget.isFreelancer)
                        _dropDowmButton(150, 'graduated', [
                          'Yes',
                          'No',
                        ], (value) {
                          addCompanyJobFilter(null, null, value);
                        }),
                      if (widget.isFreelancer)
                        _dropDowmButton(
                          200,
                          'rate',
                          [
                            'More than 30 %',
                            'More than 60 %',
                            'More than 90 %',
                          ],
                          (value) {
                            addUserOfferFilter(value);
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
          Scrollbar(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : widget.isFreelancer
                    ? RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _applicants.length,
                          itemBuilder: (ctx, index) => FreelancerItem(
                            _applicants[index],
                            widget.account,
                            widget.job,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _applicants.length,
                          itemBuilder: (ctx, index) => UserItem(
                            _applicants[index],
                            widget.account,
                            widget.job,
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
