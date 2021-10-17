//@dart=2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../global_stuff.dart';
import '../../providers/accounts.dart';
import '../../providers/details.dart';
import 'package:provider/provider.dart';

import '../../providers/job_business.dart';
import '../../providers/job.dart';

enum dropdownButtonType { shift, gender }

// ignore: must_be_immutable
class AddNewCompanyJob extends StatefulWidget {
  final CompanyAccount companyAccount;

  AddNewCompanyJob(this.companyAccount);
  static const routeName = '/add-new-company-job';

  @override
  _AddNewCompanyJobState createState() => _AddNewCompanyJobState();
}

class _AddNewCompanyJobState extends State<AddNewCompanyJob> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  File _image;
  // ignore: unused_field
  CompanyDetails _companyDetails;
  JobCondition condition = JobCondition(
      id: null,
      country: '',
      gender: '',
      nationality: '',
      languages: '',
      age: '',
      skills: '',
      educationLevel: '',
      specialization: '',
      yearsOfExperience: '');
  Job job = Job(
      jobCondition: null,
      company: null,
      id: null,
      title: '',
      description: '',
      salary: 0,
      shift: '',
      durationOfJob: 0,
      dateOfPublication: DateTime.now(),
      numberOfVacancies: 0,
      image: null);
  var _jobOfferDetails = {
    'company id': '',
    'title': '',
    'description': '',
    'salary': '',
    'shift': '',
    'durationOfJob': '',
    'numberOfVacancies': '',
    'dateOfPublication': '',
    'image': null
  };
  var _jobConditionDetails = {
    'country': '',
    'gender': '',
    'nationality': '',
    'languages': '',
    'age': '',
    'skills': '',
    'educationLevel': '',
    'specialization': '',
    'yearsOfExperience': ''
  };

  var deviceSize;
  final _genders = ['Male', 'Female'];
  final _shifts = ['Daytime', 'Evening', 'Midnight'];
  String _shift, _gender;
  var _isInit = true;

  bool _isLoading = false;

  CompanyDetails initilize() {
    return _companyDetails = CompanyDetails(
      id: widget.companyAccount.userId,
      name: widget.companyAccount.companyDetails.name,
      email: widget.companyAccount.companyDetails.email,
      password: widget.companyAccount.companyDetails.password,
      specialization: widget.companyAccount.companyDetails.specialization,
      description: widget.companyAccount.companyDetails.description,
      image: widget.companyAccount.companyDetails.image,
      accounts: widget.companyAccount.companyDetails.accounts,
      location: widget.companyAccount.companyDetails.location,
    );
  }

  void didChangeDependencies() {
    if (_isInit) {
      final jobId = ModalRoute.of(context).settings.arguments as String;
      print(jobId);
      if (jobId != null) {
        job = Provider.of<JobBusiness>(context, listen: false).findById(jobId);
        print('inside if');
        _jobOfferDetails = {
          'company id': job.company.id,
          'title': job.title,
          'description': job.description,
          'salary': job.salary.toString(),
          'shift': job.shift,
          'durationOfJob': job.durationOfJob.toString(),
          'numberOfVacancies': job.numberOfVacancies == null
              ? '0'
              : job.numberOfVacancies.toString(),
          'dateOfPublication': job.dateOfPublication.toString(),
          'image':  job.image == null ? null : fileToString(job.image),
        };
        _jobConditionDetails = {
          'country': job.jobCondition.country,
          'gender': job.jobCondition.gender,
          'nationality': job.jobCondition.nationality,
          'languages': job.jobCondition.languages,
          'age': job.jobCondition.age,
          'skills': job.jobCondition.skills,
          'educationLevel': job.jobCondition.educationLevel,
          'specialization': job.jobCondition.specialization,
          'yearsOfExperience': job.jobCondition.yearsOfExperience == 'null'
              ? '0'
              : job.jobCondition.yearsOfExperience
        };
        _gender = job.jobCondition.gender == '' ? null : job.jobCondition.gender;
        _shift = job.shift == '' ? null : job.shift;
        

        print(_shift);
        print(_gender);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _imgFromGallery() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
  }

  void _showErrorDialog(String message) {
    print('object');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: message == 'Wait for the Admin to approve'
            ? Text('Submitted')
            : Text('An Error Occurred !!'),
        content: Text(message),
        actions: [
          TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              }),
        ],
      ),
    );
    print('after dialog');
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });
    if (!_formKey.currentState.validate()) {
      print('Invalid!');
      return;
    }
    _formKey.currentState.save();
    if (job.id != null) {
      print('if');
      try {
        //provider .. edit job
        Provider.of<JobBusiness>(context, listen: false)
            .editJob(job.id, job, condition);
      } catch (error) {
        _showErrorDialog(error.toString());
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      try {
        // Sending _jobOfferDetails to Database
        await Provider.of<JobBusiness>(context, listen: false)
            .addJobs(job, condition, widget.companyAccount.userId);
      } on Exception catch (message) {
        print('1');
        _showErrorDialog(message.toString());
        print('11');
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        print('2');
        _showErrorDialog(error.toString());
        print('22');
        setState(() {
          _isLoading = false;
        });
      }
    }
    Navigator.of(context).pop(context);
  }

  Widget dropdownButton(
    dropdownButtonType type,
    List<String> items,
    String hint,
  ) {
    return Container(
      width: (deviceSize.width - 60) / 2,
      height: deviceSize.height * 0.085,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
            color: Colors.black54, style: BorderStyle.solid, width: 3.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: DropdownButton<String>(
          isExpanded: true,
          focusColor: Colors.white,
          value: type == dropdownButtonType.shift ? _shift : _gender,
          style: TextStyle(color: Colors.white),
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.black)),
            );
          }).toList(),
          hint: Text(hint),
          onChanged: (String value) {
            setState(() {
              if (type == dropdownButtonType.shift) {
                condition = JobCondition(
                    id: condition.id,
                    country: condition.country,
                    gender: condition.gender,
                    nationality: condition.nationality,
                    languages: condition.languages,
                    age: condition.age,
                    skills: condition.skills,
                    educationLevel: condition.educationLevel,
                    specialization: condition.specialization,
                    yearsOfExperience: condition.yearsOfExperience);
                job = Job(
                    company: initilize(),
                    jobCondition: condition,
                    id: job.id,
                    title: job.title,
                    description: job.description,
                    salary: job.salary,
                    shift: value,
                    durationOfJob: job.durationOfJob,
                    dateOfPublication: job.dateOfPublication,
                    numberOfVacancies: job.numberOfVacancies,
                    image: job.image);
                _shift = value;
              } else {
                condition = JobCondition(
                    id: condition.id,
                    country: condition.country,
                    gender: value,
                    nationality: condition.nationality,
                    languages: condition.languages,
                    age: condition.age,
                    skills: condition.skills,
                    educationLevel: condition.educationLevel,
                    specialization: condition.specialization,
                    yearsOfExperience: condition.yearsOfExperience);
                job = Job(
                    company: initilize(),
                    jobCondition: condition,
                    id: job.id,
                    title: job.title,
                    description: job.description,
                    salary: job.salary,
                    shift: job.shift,
                    durationOfJob: job.durationOfJob,
                    dateOfPublication: job.dateOfPublication,
                    numberOfVacancies: job.numberOfVacancies,
                    image: job.image);
                _gender = value;
              }
            });
          },
        ),
      ),
    );
  }

  Widget textFormField(String initialVal, String labelText,
      TextInputType textInputType, Function onSaved, Function validator) {
    return TextFormField(
      initialValue: initialVal,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
      ),
      minLines: 1,
      maxLines: labelText == 'description' ? 30 : 1,
      keyboardType: textInputType,
      textInputAction: labelText == 'Years of Experience'
          ? TextInputAction.done
          : labelText == 'description'
              ? TextInputAction.newline
              : TextInputAction.next,
      onSaved: onSaved,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add a new job offer'),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                textFormField(
                    _jobOfferDetails['title'], 'Job title', TextInputType.text,
                    (value) {
                  condition = JobCondition(
                      id: condition.id,
                      country: condition.country,
                      gender: condition.gender,
                      nationality: condition.nationality,
                      languages: condition.languages,
                      age: condition.age,
                      skills: condition.skills,
                      educationLevel: condition.educationLevel,
                      specialization: condition.specialization,
                      yearsOfExperience: condition.yearsOfExperience);
                  job = Job(
                    company: initilize(),
                    jobCondition: condition,
                    id: job.id,
                    title: value,
                    description: job.description,
                    salary: job.salary,
                    shift: job.shift,
                    durationOfJob: job.durationOfJob,
                    dateOfPublication: job.dateOfPublication,
                    numberOfVacancies: job.numberOfVacancies,
                    image: job.image,
                  );
                }, (value) {
                  if (value.isEmpty) return 'This field can\'t be empty !!';
                  return null;
                }),
                SizedBox(height: 15),

                textFormField(_jobOfferDetails['description'],
                    'Job Description', TextInputType.text, (value) {
                  if (value.isNotEmpty) {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: condition.languages,
                        age: condition.age,
                        skills: condition.skills,
                        educationLevel: condition.educationLevel,
                        specialization: condition.specialization,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                      company: initilize(),
                      jobCondition: condition,
                      id: job.id,
                      title: job.title,
                      description: value,
                      salary: job.salary,
                      shift: job.shift,
                      durationOfJob: job.durationOfJob,
                      dateOfPublication: job.dateOfPublication,
                      numberOfVacancies: job.numberOfVacancies,
                      image: job.image,
                    );
                  } else {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: condition.languages,
                        age: condition.age,
                        skills: condition.skills,
                        educationLevel: condition.educationLevel,
                        specialization: condition.specialization,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                      company: initilize(),
                      jobCondition: condition,
                      id: job.id,
                      title: job.title,
                      description: 'No description provided for this offer',
                      salary: job.salary,
                      shift: job.shift,
                      durationOfJob: job.durationOfJob,
                      dateOfPublication: job.dateOfPublication,
                      numberOfVacancies: job.numberOfVacancies,
                      image: job.image,
                    );
                  }
                }, (_) {}),
                SizedBox(height: 15),

                textFormField(
                    _jobOfferDetails['salary'], 'Salary', TextInputType.number,
                    (value) {
                  condition = JobCondition(
                      id: condition.id,
                      country: condition.country,
                      gender: condition.gender,
                      nationality: condition.nationality,
                      languages: condition.languages,
                      age: condition.age,
                      skills: condition.skills,
                      educationLevel: condition.educationLevel,
                      specialization: condition.specialization,
                      yearsOfExperience: condition.yearsOfExperience);
                  job = Job(
                    company: initilize(),
                    jobCondition: condition,
                    id: job.id,
                    title: job.title,
                    description: job.description,
                    salary: int.parse(value),
                    shift: job.shift,
                    durationOfJob: job.durationOfJob,
                    dateOfPublication: job.dateOfPublication,
                    numberOfVacancies: job.numberOfVacancies,
                    image: job.image,
                  );
                }, (value) {
                  if (value.isEmpty) return 'This field can\'t by empty';
                  return null;
                }),
                SizedBox(height: 15),

                textFormField(_jobOfferDetails['durationOfJob'],
                    'Duration of job (hours)*', TextInputType.number, (value) {
                  condition = JobCondition(
                      id: condition.id,
                      country: condition.country,
                      gender: condition.gender,
                      nationality: condition.nationality,
                      languages: condition.languages,
                      age: condition.age,
                      skills: condition.skills,
                      educationLevel: condition.educationLevel,
                      specialization: condition.specialization,
                      yearsOfExperience: condition.yearsOfExperience);
                  job = Job(
                      company: initilize(),
                      jobCondition: condition,
                      id: job.id,
                      title: job.title,
                      description: job.description,
                      salary: job.salary,
                      shift: job.shift,
                      durationOfJob: double.parse(value),
                      dateOfPublication: job.dateOfPublication,
                      numberOfVacancies: job.numberOfVacancies,
                      image: job.image);
                }, (value) {
                  if (value.isEmpty) return 'This field can\'t be empty !!';
                  return null;
                }),
                SizedBox(height: 15),

                // Gender and Shift
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    dropdownButton(
                        dropdownButtonType.gender, _genders, 'Gender'),
                    dropdownButton(dropdownButtonType.shift, _shifts, 'Shift'),
                  ],
                ),
                SizedBox(height: 15),

                textFormField(_jobOfferDetails['numberOfVacancies'],
                    'Number of Vacancies', TextInputType.number, (value) {
                  if (value.isNotEmpty) {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: condition.languages,
                        age: condition.age,
                        skills: condition.skills,
                        educationLevel: condition.educationLevel,
                        specialization: condition.specialization,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: value == null ? 0 : int.parse(value),
                        image: job.image);
                  } else {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: condition.languages,
                        age: condition.age,
                        skills: condition.skills,
                        educationLevel: condition.educationLevel,
                        specialization: condition.specialization,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: 1,
                        image: job.image);
                  }
                }, (_) {}),
                SizedBox(height: 15),

                textFormField(_jobConditionDetails['country'],
                    'Current Country', TextInputType.text, (value) {
                  if (value.isNotEmpty) {
                    condition = JobCondition(
                        id: condition.id,
                        country: value,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: condition.languages,
                        age: condition.age,
                        skills: condition.skills,
                        educationLevel: condition.educationLevel,
                        specialization: condition.specialization,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: job.numberOfVacancies,
                        image: job.image);
                  } else {
                    condition = JobCondition(
                        id: condition.id,
                        country: 'USA',
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: condition.languages,
                        age: condition.age,
                        skills: condition.skills,
                        educationLevel: condition.educationLevel,
                        specialization: condition.specialization,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: job.numberOfVacancies,
                        image: job.image);
                  }
                }, (_) {}),
                SizedBox(height: 15),

                textFormField(_jobConditionDetails['nationality'],
                    'Nationality', TextInputType.text, (value) {
                  if (value.isNotEmpty) {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: value,
                        languages: condition.languages,
                        age: condition.age,
                        skills: condition.skills,
                        educationLevel: condition.educationLevel,
                        specialization: condition.specialization,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: job.numberOfVacancies,
                        image: job.image);
                  } else {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: 'No specific nationality needed',
                        languages: condition.languages,
                        age: condition.age,
                        skills: condition.skills,
                        educationLevel: condition.educationLevel,
                        specialization: condition.specialization,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: job.numberOfVacancies,
                        image: job.image);
                  }
                }, (_) {}),
                SizedBox(height: 15),

                textFormField(
                    _jobConditionDetails['age'], 'Age', TextInputType.number,
                    (value) {
                  if (value.isNotEmpty) {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: condition.languages,
                        age: value,
                        skills: condition.skills,
                        educationLevel: condition.educationLevel,
                        specialization: condition.specialization,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: job.numberOfVacancies,
                        image: job.image);
                  } else {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: condition.languages,
                        age: 'No specific age',
                        skills: condition.skills,
                        educationLevel: condition.educationLevel,
                        specialization: condition.specialization,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: job.numberOfVacancies,
                        image: job.image);
                  }
                }, (_) {}),
                SizedBox(height: 15),

                textFormField(_jobConditionDetails['languages'],
                    'Required Languages', TextInputType.text, (value) {
                  if (value.isNotEmpty) {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: value,
                        age: condition.age,
                        skills: condition.skills,
                        educationLevel: condition.educationLevel,
                        specialization: condition.specialization,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: job.numberOfVacancies,
                        image: job.image);
                  } else {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: 'No specific languages needed',
                        age: condition.age,
                        skills: condition.skills,
                        educationLevel: condition.educationLevel,
                        specialization: condition.specialization,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: job.numberOfVacancies,
                        image: job.image);
                  }
                }, (_) {}),
                SizedBox(height: 15),

                textFormField(_jobConditionDetails['educationLevel'],
                    'Level of Education', TextInputType.text, (value) {
                  if (value.isNotEmpty) {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: condition.languages,
                        age: condition.age,
                        skills: condition.skills,
                        educationLevel: value,
                        specialization: condition.specialization,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: job.numberOfVacancies,
                        image: job.image);
                  } else {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: condition.languages,
                        age: condition.age,
                        skills: condition.skills,
                        educationLevel: 'No minimum Level of Education needed',
                        specialization: condition.specialization,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: job.numberOfVacancies,
                        image: job.image);
                  }
                }, (_) {}),
                SizedBox(height: 15),

                textFormField(_jobConditionDetails['skills'], 'Required Skills',
                    TextInputType.text, (value) {
                  if (value.isNotEmpty) {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: condition.languages,
                        age: condition.age,
                        skills: value,
                        educationLevel: condition.educationLevel,
                        specialization: condition.specialization,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: job.numberOfVacancies,
                        image: job.image);
                  } else {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: condition.languages,
                        age: condition.age,
                        skills: 'No specific skills needed',
                        educationLevel: condition.educationLevel,
                        specialization: condition.specialization,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: job.numberOfVacancies,
                        image: job.image);
                  }
                }, (_) {}),
                SizedBox(height: 15),

                textFormField(_jobConditionDetails['specialization'],
                    'Specialization', TextInputType.text, (value) {
                  if (value.isNotEmpty) {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: condition.languages,
                        age: condition.age,
                        skills: condition.skills,
                        educationLevel: condition.educationLevel,
                        specialization: value,
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: job.numberOfVacancies,
                        image: job.image);
                  } else {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: condition.languages,
                        age: condition.age,
                        skills: condition.skills,
                        educationLevel: condition.educationLevel,
                        specialization: 'No specific Specialization needed',
                        yearsOfExperience: condition.yearsOfExperience);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: job.numberOfVacancies,
                        image: job.image);
                  }
                }, (_) {}),
                SizedBox(height: 15),

                textFormField(_jobConditionDetails['yearsOfExperience'],
                    'Years of Experience', TextInputType.number, (value) {
                  if (value.isNotEmpty) {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: condition.languages,
                        age: condition.age,
                        skills: condition.skills,
                        educationLevel: condition.educationLevel,
                        specialization: condition.specialization,
                        yearsOfExperience: value);
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: job.numberOfVacancies,
                        image: job.image);
                  } else {
                    condition = JobCondition(
                        id: condition.id,
                        country: condition.country,
                        gender: condition.gender,
                        nationality: condition.nationality,
                        languages: condition.languages,
                        age: condition.age,
                        skills: condition.skills,
                        educationLevel: condition.educationLevel,
                        specialization: condition.specialization,
                        yearsOfExperience: 'No Years of Experience needed');
                    job = Job(
                        company: initilize(),
                        jobCondition: condition,
                        id: job.id,
                        title: job.title,
                        description: job.description,
                        salary: job.salary,
                        shift: job.shift,
                        durationOfJob: job.durationOfJob,
                        dateOfPublication: job.dateOfPublication,
                        numberOfVacancies: job.numberOfVacancies,
                        image: job.image);
                  }
                }, (_) {}),
                SizedBox(height: 15),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CircleAvatar(
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                _image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.person,
                                color: Colors.grey[800],
                              ),
                            ),
                    ),
                    Align(
                      child: TextButton(
                        child: Text('Add photo'),
                        onPressed: _imgFromGallery,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    Spacer(),
                    Align(
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              child: Text('Submit'),
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                textStyle: TextStyle(fontSize: 18),
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
