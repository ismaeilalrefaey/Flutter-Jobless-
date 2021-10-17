//@dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../providers/job.dart';
import '../providers/details.dart';
import '../providers/accounts.dart';
import '../providers/freelance_offer.dart';
import 'email_screens/sending_email_screen.dart';

// ignore: must_be_immutable
class JobApplicant extends StatelessWidget {
  static const routeName = '/job-applicant';

  double rate = 0;
  Widget _title(String title, String id) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ListTile(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _listTile(String title, String subtitle) {
    return ListTile(
      title: Text(title ?? ''),
      subtitle: Text(subtitle ?? ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    var T = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    Account account = T['account'];
    var data, isFreelancer;
    var user = T['user'];
    if (user == null) {
      isFreelancer = false;
    } else if (user is UserAccount) {
      data = T;
      print(user.userId);
      isFreelancer = false;
    } else {
      data = T;
      print(data);
      isFreelancer = true;
    }
    var disapprovedUserId;
    if (user != null) {
      disapprovedUserId = user == null ? null : user.userId;
    }

    var offer;
    if (!isFreelancer) {
      print('Applicant isn\'t a Freelancer');
      offer = data['job'] as Job;
    } else {
      print('Applicant is a Freelancer');
      offer = data['job'] as FreelanceOffer;
    }
    var offerId = offer == null ? null : offer.id;

    final userData = data['user'].basicDetails as BasicDetails;
    final eduData = data['user'].educationalDetails as EducationalDetails;
    final additData = data['user'].additionalDetails as AdditionalDetails;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Flexible(
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: data['mark'] == 'Browse'
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.spaceBetween,
                      children: [
                        if (data['mark'] == 'Browse')
                          IconButton(
                            icon: Icon(Icons.forward_to_inbox),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  SendingEmailScreen.routeName,
                                  arguments: {
                                    'email': userData.email,
                                    'account': account
                                  });
                            },
                          ),
                        if (data['mark'] == 'Approval')
                          IconButton(
                            color: Colors.red,
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              print(disapprovedUserId);
                              // print(offerId);
                              if (isFreelancer) {
                                Provider.of<UserAccount>(context, listen: false)
                                    .disapproveFreelancer(
                                        disapprovedUserId, offerId);
                              } else {
                                Provider.of<CompanyAccount>(context,
                                        listen: false)
                                    .disapproveApplicant(
                                        disapprovedUserId, offerId);
                              }
                              Navigator.of(context).pop(true);
                            },
                          ),
                        if (data['mark'] == 'Approval')
                          IconButton(
                            color: Colors.green,
                            icon: Icon(Icons.check),
                            onPressed: () {
                              if (isFreelancer) {
                                Provider.of<UserAccount>(context, listen: false)
                                    .approveFreelancer(
                                        disapprovedUserId, offerId);
                              } else {
                                Provider.of<CompanyAccount>(context,
                                        listen: false)
                                    .approveApplicant(
                                        disapprovedUserId, offerId);
                              }
                              Navigator.of(context).pushReplacementNamed(
                                  SendingEmailScreen.routeName,
                                  arguments: {
                                    'email': userData.email,
                                    'account': account
                                  });
                            },
                          )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Center(
                        child: CircleAvatar(
                          radius: 50,
                          child: additData == null || additData.image == null
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                )
                              : Image.file(additData.image),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    FittedBox(
                      child: Text(
                        '${userData.firstName} ${userData.lastName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (isFreelancer)
                      GestureDetector(
                        child: Center(
                          child: Text(
                            'rate this profile',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              context: context,
                              builder: (ctx) => Container(
                                    height: deviceSize.height * 0.22,
                                    child: StatefulBuilder(
                                      builder: (ctx, setState) {
                                        return SliderTheme(
                                          data:
                                              SliderTheme.of(context).copyWith(
                                            activeTrackColor: Colors.green[700],
                                            inactiveTrackColor:
                                                Colors.green[100],
                                            trackShape:
                                                RoundedRectSliderTrackShape(),
                                            trackHeight: 4.0,
                                            thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 12.0),
                                            thumbColor: Colors.greenAccent,
                                            overlayColor:
                                                Colors.green.withAlpha(32),
                                            overlayShape:
                                                RoundSliderOverlayShape(
                                                    overlayRadius: 28.0),
                                            tickMarkShape:
                                                RoundSliderTickMarkShape(),
                                            activeTickMarkColor:
                                                Colors.green[700],
                                            inactiveTickMarkColor:
                                                Colors.green[100],
                                            valueIndicatorShape:
                                                PaddleSliderValueIndicatorShape(),
                                            valueIndicatorColor:
                                                Colors.greenAccent,
                                            valueIndicatorTextStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: Slider(
                                            min: 0,
                                            max: 100,
                                            divisions: 10,
                                            label: '$rate',
                                            value: rate,
                                            onChanged: (_) {},
                                            onChangeEnd: (selection) async {
                                              setState(() {
                                                print(rate);
                                                rate = selection;
                                              });
                                              await Provider.of<UserAccount>(
                                                          context,
                                                          listen: false)
                                                      .rate(data['user'].userId,
                                                          rate)
                                                  ? Toast.show(
                                                      'Rate Succeeded',
                                                      context,
                                                    )
                                                  : Toast.show(
                                                      'Sorry, you can\'t rate this Freelancer if you did\'n\n had business with them before',
                                                      context,
                                                      backgroundColor:
                                                          Colors.red,
                                                    );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ));
                        },
                      ),
                    SizedBox(
                      height: 20,
                    ),

                    _title('Basic Info', userData.id),
                    _listTile(
                        '${userData.birthday.year} / ${userData.birthday.month} / ${userData.birthday.day}',
                        'Worst date ever'),
                    Divider(),
                    _listTile(userData.gender, 'M / F'),
                    Divider(),
                    _listTile(userData.email, 'Some shit before an @gmail.com'),
                    Divider(),
                    _listTile(userData.phoneNumber, 'Mobile'),
                    Divider(),
                    _title('Educational Info', userData.id),
                    Divider(),
                    _listTile(
                        eduData == null || eduData.specialization == null
                            ? ''
                            : eduData.specialization,
                        'What I\'m major in'),
                    Divider(),
                    _listTile(
                        eduData == null || eduData.educationLevels == null
                            ? ''
                            : eduData.educationLevels,
                        'Baccalaureat / Bachelor / Master / P.hD. .. etc'),
                    Divider(),
                    _listTile(
                        eduData == null || eduData.skills == null
                            ? ''
                            : eduData.skills.toString(),
                        'Free writing'),
                    Divider(),
                    _listTile(
                        eduData == null || eduData.courses == null
                            ? ''
                            : eduData.courses,
                        'Either free writing course\'s title\nor attach a validation URL (like Coursera)'),
                    Divider(),
                    _listTile(
                        eduData == null || eduData.spokenLanguage == null
                            ? ''
                            : eduData.spokenLanguage,
                        'This thing gotta be multiple selection :/'),
                    // Divider(),
                    // _listTile(
                    //     eduData.isGraduated ? 'Yes' : 'No', 'Am i graduated??'),
                    // Divider(),
                    // _listTile(
                    //     eduData.pdf.toString(),
                    //     'Either "Not submitted yet" \nor we show an icon to edit an existing one',
                    //     userData.id,
                    //     EditEducationalDetailsScreen.routeName),
                    Divider(),
                    _title('Additional Info', userData.id),
                    Divider(),
                    _listTile(
                        additData == null || additData.nationality == null
                            ? ''
                            : additData.nationality,
                        'That lucky country'),
                    Divider(),
                    _listTile(
                        additData == null || additData.creditCard == null
                            ? ''
                            : additData.creditCard,
                        'Credit Card'),
                    // if (isFreelancer) Divider(),
                    // if (isFreelancer) _listTile(data['user'].portfolio, 'Portfolio'),
                    // if (isFreelancer) Divider(),
                    // if (isFreelancer) _listTile(data['user'].rate.toString(), 'Rate'),
                    SizedBox(height: 100)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
