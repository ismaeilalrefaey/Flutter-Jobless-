//@dart=2.9

import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/accounts.dart';
import '../Screens/job_applicant.dart';
import '../providers/freelance_offer.dart';

class FreelancerOfferDetail extends StatefulWidget {
  static const routeName = 'freelancer-offer-details';

  @override
  _FreelancerOfferDetailState createState() => _FreelancerOfferDetailState();
}

class _FreelancerOfferDetailState extends State<FreelancerOfferDetail> {
  FreelanceOffer offer;
  String offerId;
  var _isInit = true;
  var isGuest;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _isInit = false;
      var data =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      offerId = data['id'];
      offer = Provider.of<FreelanceOfferBusiness>(context, listen: false)
          .findById(offerId);
      isGuest = data['guest'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: CircleAvatar(
              radius: 4,
              child: offer.image != null
                  ? Image.file(offer.image)
                  : Icon(Icons.person, size: 20),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(
                JobApplicant.routeName,
                arguments: {'user': offer.user, 'job': offer, 'mark': 'Browse'},
              );
            },
          ),
        ), //child: Image.file(job.image),
        title: Text(offer.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Freelance Offer details:',
                style: TextStyle(fontSize: 22, color: Colors.blue),
              ),
              Text(
                '\u2022 Date of Publication: ${offer.dateOfPublication}',
                style: TextStyle(fontSize: 17),
              ),
              Text(
                offer.deadLine == null
                    ? '\u2022 deadline: Not set'
                    : '\u2022 deadline: ${offer.deadLine}',
                style: TextStyle(fontSize: 17),
              ),
              Text(
                offer.wage == null
                    ? '\u2022 Wage: Not set'
                    : '\u2022 Wage: ${offer.wage}\$',
                style: TextStyle(fontSize: 17),
              ),
              Divider(),
              offer.description == null
                  ? Text('')
                  : Text(
                      'Full details:',
                      style: TextStyle(fontSize: 22, color: Colors.blue),
                    ),
              offer.description == null
                  ? Text('')
                  : Text(
                      '${offer.description}',
                      style: TextStyle(fontSize: 17),
                    ),
              Divider(),
              offer.skills == null
                  ? Text('')
                  : Text(
                      'Qualification:',
                      style: TextStyle(fontSize: 22, color: Colors.blue),
                    ),
              offer.skills == null
                  ? Text('')
                  : Text(
                      '${offer.skills}',
                      style: TextStyle(fontSize: 17),
                    ),
              SizedBox(height: 17),
              if (!isGuest)
                Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 300),
                    child: ElevatedButton(
                      child: Text('Apply Now'),
                      onPressed: () {
                        Provider.of<FreelancerAccount>(context, listen: false)
                            .applyForAJob(offerId);
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
