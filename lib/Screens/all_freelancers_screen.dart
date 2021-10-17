//@dart=2.9
import 'package:flutter/material.dart';
import '../Screens/job_applicant.dart';
import '../providers/accounts.dart';
import 'package:provider/provider.dart';

class AllFreelancers extends StatefulWidget {
  static const routeName = 'all-freelancers';
  @override
  _AllFreelancersState createState() => _AllFreelancersState();
}

class _AllFreelancersState extends State<AllFreelancers> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<FreelancerAccount>(context, listen: false)
          .getAllFreelancerAccount()
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
    Provider.of<FreelancerAccount>(context, listen: false)
        .getAllFreelancerAccount()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<FreelancerAccount> freelancerAccount =
        Provider.of<FreelancerAccount>(context).allFreelancerAccounts;
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobless?'),
      ),
      body: _isLoading
          ? LinearProgressIndicator()
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                  itemCount: freelancerAccount.length,
                  itemBuilder: (_, index) => ListTile(
                        leading: CircleAvatar(
                          child: freelancerAccount[index].additionalDetails ==
                                      null ||
                                  freelancerAccount[index]
                                          .additionalDetails
                                          .image ==
                                      null
                              ? Icon(Icons.person)
                              : Image.file(freelancerAccount[index]
                                  .additionalDetails
                                  .image),
                        ),
                        title: Text(
                          '${freelancerAccount[index].basicDetails.firstName} ${freelancerAccount[index].basicDetails.lastName}',
                          style: TextStyle(fontSize: 25),
                        ),
                        subtitle: Text('${freelancerAccount[index].rate}%'),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            JobApplicant.routeName,
                            arguments: {
                              'user': freelancerAccount[index],
                              'job': null,
                              'mark': 'Browse'
                            },
                          );
                        },
                      )),
            ),
    );
  }
}
