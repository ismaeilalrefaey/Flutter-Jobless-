//@dart=2.9
import 'package:flutter/material.dart';
import '../Screens/company_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../providers/job.dart';
import '../providers/accounts.dart';
import '../providers/job_business.dart';

class JobDetails extends StatefulWidget {
  static const routeName = 'job-details';

  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  Job job;
  String jobId;
  String mark;
  var _isInit = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _isInit = false;
      var data =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      jobId = data['id'];
      mark = data['mark'];
      print(mark);
      if (mark == null) {
        job = Provider.of<JobBusiness>(context, listen: false).findById(jobId);
      } else {
        job = data['job'];
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: CircleAvatar(radius: 4),
            onTap: () {
              Navigator.of(context).pushNamed(
                CompanyProfileScreen.routeName,
                arguments: job.company,
                // arguments: CompanyAccount.detailsConstructor(job.company),
              );
              // Navigator.of(context).pushNamed(JobApplicant.routeName,
              //     arguments: {
              //       'user': job.company,
              //       'job': job,
              //       'mark': 'Browsing'
              //     });
            },
          ),
        ), //child: Image.file(job.image),
        title: Text(job.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Job Details:',
                style: TextStyle(fontSize: 22, color: Colors.blue),
              ),
              job.jobCondition == null
                  ? Text('')
                  : Text(
                      '\u2022 Required age: ${(job.jobCondition.age == null ? '' : job.jobCondition.age)} \n\u2022 Gender: ${(job.jobCondition.gender == null ? '' : job.jobCondition.gender)} \n\u2022 Job country:${(job.jobCondition.country == null ? '' : job.jobCondition.country)} \n\u2022 ${(job.durationOfJob)} hours \n\u2022 ${(job.salary)}\$',
                      style: TextStyle(fontSize: 17)),
              job.jobCondition == null
                  ? Text('')
                  : Text(
                      '\u2022 Years Of experience: ${(job.jobCondition.yearsOfExperience == null ? '' : job.jobCondition.yearsOfExperience)}',
                      style: TextStyle(fontSize: 17)),
              Divider(),
              Text(
                'Job Type:',
                style: TextStyle(fontSize: 22, color: Colors.blue),
              ),
              Text('\u2022 ${(job.shift)}', style: TextStyle(fontSize: 17)),
              Divider(),
              Text(
                'Full details:',
                style: TextStyle(fontSize: 22, color: Colors.blue),
              ),
              Text(job.description, style: TextStyle(fontSize: 17)),
              //SizedBox(height: 17),
              Divider(),
              Text('Qualifications: ',
                  style: TextStyle(fontSize: 22, color: Colors.blue)),
              job.jobCondition == null
                  ? Text('')
                  : Text(
                      '\u2022 ${(job.jobCondition.educationLevel == null ? '' : job.jobCondition.educationLevel)} \n\u2022 ${(job.jobCondition.skills == null ? '' : job.jobCondition.skills)} \n\u2022 ${(job.jobCondition.specialization == null ? '' : job.jobCondition.specialization)} \n\u2022  ${(job.jobCondition.languages)}',
                      style: TextStyle(fontSize: 17)),
              SizedBox(height: 17),
              if (mark == 'Approval')
                Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 300),
                    child: ElevatedButton(
                      child: Text('Apply Now'),
                      onPressed: () {
                        Provider.of<UserAccount>(context, listen: false)
                            .applyForAJob(jobId);
                        Toast.show(
                          'Applied Successfully',
                          context,
                          duration: 2,
                          gravity: Toast.BOTTOM,
                          backgroundRadius: 10,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
