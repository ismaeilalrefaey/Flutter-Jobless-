//@dart=2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global_stuff.dart';
import '../providers/details.dart';
import '../providers/accounts.dart';
import '../PDF_bussiness/PDFApi.dart';
import '../PDF_bussiness/PDF_view.dart';

class EditEducationalDetailsScreen extends StatefulWidget {
  static const routeName = '/edit-eduational-details-screen';
  @override
  _EditEducationalDetailsScreenState createState() =>
      _EditEducationalDetailsScreenState();
}

class _EditEducationalDetailsScreenState
    extends State<EditEducationalDetailsScreen> {
  Account account;
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isInit = true;
  bool isSwitched = false;
  File file;
  EducationalDetails educationalDetails = EducationalDetails(
      id: null,
      educationLevels: '',
      specialization: '',
      spokenLanguage: '',
      courses: '',
      skills: '',
      pdf: null,
      isGraduated: false);
  var _initValue = {
    'educationLevels': '',
    'specialization': '',
    'spokenLanguage': '',
    'courses': '',
    'skills': '',
    'pdf': null,
    'isGraduated': false
  };

  void toggleSwitch(bool i) {
    setState(() {
      isSwitched = !isSwitched;
    });
  }

  void didChangeDependencies() async {
    if (_isInit) {
      account = ModalRoute.of(context).settings.arguments as Account;
      educationalDetails =
          Provider.of<EducationalDetailsProvider>(context).item;
      // .findByUserId(userId);
      _initValue = {
        'skills':
            educationalDetails == null || educationalDetails.skills == null
                ? ''
                : educationalDetails.skills,
        'isGraduated':
            educationalDetails == null || educationalDetails.isGraduated == null
                ? ''
                : educationalDetails.isGraduated,
        'courses':
            educationalDetails == null || educationalDetails.courses == null
                ? ''
                : educationalDetails.courses,
        'pdf': null, //fileToString(educationalDetails.pdf),
        'specialization': educationalDetails == null ||
                educationalDetails.specialization == null
            ? ''
            : educationalDetails.specialization,
        'spokenLanguage': educationalDetails == null ||
                educationalDetails.spokenLanguage == null
            ? ''
            : educationalDetails.spokenLanguage,
        'educationLevels': educationalDetails == null ||
                educationalDetails.educationLevels == null
            ? ''
            : educationalDetails.educationLevels,
      };
      educationalDetails == null || educationalDetails.isGraduated == null
          ? isSwitched = false
          : isSwitched = educationalDetails.isGraduated;
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    var temp = '';
    if (account is UserAccount) {
      temp = '$ipAddress/edit/user/educationaldetails';
    } else {
      temp = '$ipAddress/edit/freelancer/educationaldetails';
    }
    Provider.of<EducationalDetailsProvider>(context, listen: false)
        .editEducationDetails(educationalDetails, account.userId, temp);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    educationalDetails =
        Provider.of<EducationalDetailsProvider>(context, listen: false).item;
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Educational Details Editing'),
          actions: [IconButton(icon: Icon(Icons.save), onPressed: _submit)],
        ),
        body: _isInit
            ? LinearProgressIndicator()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValue['specialization'],
                        textInputAction: TextInputAction.next,
                        decoration:
                            InputDecoration(labelText: 'Specialization'),
                        onSaved: (value) {
                          educationalDetails = EducationalDetails(
                            id: '',
                            isGraduated: isSwitched,
                            courses: educationalDetails == null
                                ? null
                                : educationalDetails.courses,
                            educationLevels: educationalDetails == null
                                ? null
                                : educationalDetails.educationLevels,
                            pdf: educationalDetails == null
                                ? null
                                : educationalDetails.pdf,
                            skills: educationalDetails == null
                                ? null
                                : educationalDetails.skills,
                            specialization: value,
                            spokenLanguage: educationalDetails == null
                                ? null
                                : educationalDetails.spokenLanguage,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['educationLevels'],
                        textInputAction: TextInputAction.next,
                        decoration:
                            InputDecoration(labelText: 'Eucation Levels'),
                        onSaved: (value) {
                          educationalDetails = EducationalDetails(
                            id: '',
                            isGraduated: isSwitched,
                            courses: educationalDetails == null
                                ? null
                                : educationalDetails.courses,
                            educationLevels: value,
                            pdf: educationalDetails == null
                                ? null
                                : educationalDetails.pdf,
                            skills: educationalDetails == null
                                ? null
                                : educationalDetails.skills,
                            specialization: educationalDetails == null
                                ? null
                                : educationalDetails.specialization,
                            spokenLanguage: educationalDetails == null
                                ? null
                                : educationalDetails.spokenLanguage,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['skills'],
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: 'Skills'),
                        onSaved: (value) {
                          educationalDetails = EducationalDetails(
                            id: '',
                            isGraduated: isSwitched,
                            courses: educationalDetails == null
                                ? null
                                : educationalDetails.courses,
                            educationLevels: educationalDetails == null
                                ? null
                                : educationalDetails.educationLevels,
                            pdf: educationalDetails == null
                                ? null
                                : educationalDetails.pdf,
                            skills: value,
                            specialization: educationalDetails == null
                                ? null
                                : educationalDetails.specialization,
                            spokenLanguage: educationalDetails == null
                                ? null
                                : educationalDetails.spokenLanguage,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['courses'],
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: 'Courses'),
                        onSaved: (value) {
                          educationalDetails = EducationalDetails(
                            id: '',
                            isGraduated: isSwitched,
                            courses: value,
                            educationLevels: educationalDetails == null
                                ? null
                                : educationalDetails.educationLevels,
                            pdf: educationalDetails == null
                                ? null
                                : educationalDetails.pdf,
                            skills: educationalDetails == null
                                ? null
                                : educationalDetails.skills,
                            specialization: educationalDetails == null
                                ? null
                                : educationalDetails.specialization,
                            spokenLanguage: educationalDetails == null
                                ? null
                                : educationalDetails.spokenLanguage,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['spokenLanguage'],
                        textInputAction: TextInputAction.done,
                        decoration:
                            InputDecoration(labelText: 'Spoken Languages'),
                        onSaved: (value) {
                          educationalDetails = EducationalDetails(
                            id: '',
                            isGraduated: isSwitched,
                            courses: educationalDetails == null
                                ? null
                                : educationalDetails.courses,
                            educationLevels: educationalDetails == null
                                ? null
                                : educationalDetails.educationLevels,
                            pdf: educationalDetails == null
                                ? null
                                : educationalDetails.pdf,
                            skills: educationalDetails == null
                                ? null
                                : educationalDetails.skills,
                            specialization: educationalDetails == null
                                ? null
                                : educationalDetails.specialization,
                            spokenLanguage: value,
                          );
                        },
                      ),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Are you graduated ?'),
                            Switch(
                              onChanged: toggleSwitch,
                              value: isSwitched,
                              activeColor: Colors.green,
                              inactiveThumbColor: Colors.redAccent,
                            ),
                          ]),
                      Divider(),
                      Container(
                          height: 60,
                          width: double.infinity,
                          child: DropdownButton(
                            icon: Icon(Icons.feed_outlined),
                            hint: Text('CV file',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                            items: ['Upload new CV', 'View my CV']
                                .map<DropdownMenuItem<String>>((value) =>
                                    DropdownMenuItem<String>(
                                        value: value, child: Text(value)))
                                .toList(),
                            onChanged: (value) async {
                              if (value == 'Upload new CV') {
                                file = await PDFApi.pickFile();
                                educationalDetails = EducationalDetails(
                                  id: '',
                                  isGraduated: isSwitched,
                                  courses: educationalDetails == null
                                      ? null
                                      : educationalDetails.courses,
                                  educationLevels: educationalDetails == null
                                      ? null
                                      : educationalDetails.educationLevels,
                                  pdf: file,
                                  skills: educationalDetails == null
                                      ? null
                                      : educationalDetails.skills,
                                  specialization: educationalDetails == null
                                      ? null
                                      : educationalDetails.specialization,
                                  spokenLanguage: educationalDetails == null
                                      ? null
                                      : educationalDetails.spokenLanguage,
                                );
                              } else {
                                if (educationalDetails.pdf == null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('You don\'t pin your CV'),
                                    duration: Duration(seconds: 2),
                                  ));
                                  return;
                                }
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PDFViewer(file: file)));
                              }
                            },
                          )),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
