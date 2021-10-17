//@dart=2.9

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../global_stuff.dart';
import '../../providers/accounts.dart';
import '../../models/http_exceptions.dart';
import '../../providers/freelance_offer.dart';

class AddFreelanceOfferScreen extends StatefulWidget {
  static const routeName = 'new-freelance-offer';
  final UserAccount userAccount;
  AddFreelanceOfferScreen(this.userAccount);
  @override
  _AddFreelanceOfferScreenState createState() =>
      _AddFreelanceOfferScreenState();
}

class _AddFreelanceOfferScreenState extends State<AddFreelanceOfferScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var offerId;
  FreelanceOffer offer = FreelanceOffer(
      id: null,
      user: null,
      dateOfPublication: DateTime.now(),
      title: '',
      description: '',
      image: null,
      wage: 0,
      deadLine: null,
      skills: '');
  var _offerDetails = {
    'user_id': '',
    'date_of_publication': '',
    'title': '',
    'description': '',
    'image': null,
    'wage': '',
    'deadline': '',
    'skills': ''
  };
  var _isInit = true;
  var _isLoading = false;
  File _image;
  String _date = 'Not set';
  String _time = 'Not set';
  int year = 1, month = 1, day = 1, hour = 0, minutes = 0, second = 0;
  DateTime dateTime = DateTime.now();

  File f;

  Future<void> _imgFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
    _offerDetails['image'] =
        _image == null ? null : fileToString(_image); // Binary string
    offer.image = _image;
    print(_image == null);
  }

  void didChangeDependencies() async {
    // Yroro
    if (_isInit) {
      offerId = ModalRoute.of(context).settings.arguments as String;
      print(offerId);
      if (offerId != null) {
        //se initial value
        offer = Provider.of<FreelanceOfferBusiness>(context).findById(offerId);
        _offerDetails = {
          'user_id': widget.userAccount.userId,
          'date_of_publication': offer.dateOfPublication.toString(),
          'title': offer.title,
          'description': offer.description,
          'image': offer.image != null ? null : fileToString(offer.image),
          'wage': offer.wage.toString(),
          'deadline': offer.deadLine.toString(),
          'skills': offer.skills
        };
      }
      _date = offer.deadLine == null ? null :
          '${offer.deadLine.year} - ${offer.deadLine.month} - ${offer.deadLine.day}';
      _time = offer.deadLine == null ? null :
          '${offer.deadLine.hour} : ${offer.deadLine.minute} : ${offer.deadLine.second}';
    }
    _isInit = false;
    f = null;
    // f = File('${(await getTemporaryDirectory()).path}/${randomAlpha(5)}.txt');
    super.didChangeDependencies();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred !!'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _saveForm() async {
    // print(dateTime.toString());
    setState(() {
      _isLoading = true;
    });
    if (!_formKey.currentState.validate()) {
      print('Invalid!');
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _formKey.currentState.save();
    if (offer.id != null) {
      print('if______________________________________________________________');
      try {
        //provider .. edit  offer
        print('try');
        await Provider.of<FreelanceOfferBusiness>(context, listen: false)
            .editOffer(offerId, offer);
      } on HttpExceptions catch (error) {
        _showErrorDialog(error.toString());
      } catch (error) {
        _showErrorDialog(error.toString());
        setState(() {
          _isLoading = false;
        });
        print('finish');
      }
    } else {
      try {
        // Sending offer to Database
        await Provider.of<FreelanceOfferBusiness>(context, listen: false)
            .addOffer(offer, widget.userAccount);
      } on HttpExceptions catch (error) {
        _showErrorDialog(error.toString());
      } catch (error) {
        _showErrorDialog(error.toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
        textInputAction: labelText == 'skills'
            ? TextInputAction.done
            : labelText == 'description'
                ? TextInputAction.newline
                : TextInputAction.next,
        onSaved: onSaved,
        validator: validator,
      );
    }

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add a new freelance offer'),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // CircleAvatar(
                //   child: f != null ? Image.file(f) : null,
                // ),
                // title
                textFormField(
                    _offerDetails['title'], 'Offer Title', TextInputType.text,
                    (value) {
                  offer = FreelanceOffer(
                      id: offer.id,
                      user: widget.userAccount,
                      dateOfPublication: offer.dateOfPublication,
                      title: value,
                      description: offer.description,
                      image: offer.image,
                      wage: offer.wage,
                      deadLine: offer.deadLine,
                      skills: offer.skills);
                }, (value) {
                  if (value.isEmpty) return 'This field can\'t be empty !!';
                  return null;
                }),
                SizedBox(
                  height: 15,
                ),
                // description
                textFormField(_offerDetails['description'], 'description',
                    TextInputType.multiline, (value) {
                  offer = FreelanceOffer(
                      id: offer.id,
                      user: widget.userAccount,
                      dateOfPublication: offer.dateOfPublication,
                      title: offer.title,
                      description: value,
                      image: offer.image,
                      wage: offer.wage,
                      deadLine: offer.deadLine,
                      skills: offer.skills);
                }, (value) {
                  if (value.isEmpty) return 'This field can\'t be empty !!';
                  return null;
                }),
                SizedBox(height: 15),
                // wage
                textFormField(
                    _offerDetails['wage'], 'Wage', TextInputType.number,
                    (value) {
                  offer = FreelanceOffer(
                      id: offer.id,
                      user: widget.userAccount,
                      dateOfPublication: offer.dateOfPublication,
                      title: offer.title,
                      description: offer.description,
                      image: offer.image,
                      wage: double.parse(value),
                      deadLine: offer.deadLine,
                      skills: offer.skills);
                }, (value) {
                  if (value.isEmpty) return 'This field can\'t be empty !!';
                  return null;
                }),
                SizedBox(height: 15),
                // skills
                textFormField(
                    _offerDetails['skills'], 'Skills', TextInputType.text,
                    (value) {
                  if (value.isNotEmpty) {
                    offer = FreelanceOffer(
                        id: offer.id,
                        user: widget.userAccount,
                        dateOfPublication: offer.dateOfPublication,
                        title: offer.title,
                        description: offer.description,
                        image: offer.image,
                        wage: offer.wage,
                        deadLine: offer.deadLine,
                        skills: value);
                  } else {
                    offer = FreelanceOffer(
                        id: offer.id,
                        user: widget.userAccount,
                        dateOfPublication: offer.dateOfPublication,
                        title: offer.title,
                        description: offer.description,
                        image: offer.image,
                        wage: offer.wage,
                        deadLine: offer.deadLine,
                        skills: 'No specific skills needed');
                  }
                }, (_) {}),
                SizedBox(height: 15),
                Text(
                  'Deadline:',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 4),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: 100, vertical: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  theme: DatePickerTheme(
                                      containerHeight: 210.0,
                                      backgroundColor: Colors.white),
                                  showTitleActions: true,
                                  minTime: DateTime(2000, 1, 1),
                                  maxTime: DateTime(2022, 12, 31),
                                  onConfirm: (date) {
                                if (date == null) {
                                  return 'This field can\'t be empty !!';
                                  //return null;
                                } else {
                                  print('confirm $date');
                                  _date =
                                      '${date.year} - ${date.month} - ${date.day}';
                                  year = date.year;
                                  month = date.month;
                                  day = date.day;
                                  dateTime = DateTime(
                                      year, month, day, hour, minutes, second);
                                  offer = FreelanceOffer(
                                      id: offer.id,
                                      user: widget.userAccount,
                                      dateOfPublication:
                                          offer.dateOfPublication,
                                      title: offer.title,
                                      description: offer.description,
                                      image: offer.image,
                                      wage: offer.wage,
                                      deadLine: dateTime,
                                      skills: offer.skills);
                                }

                                // dateTime =
                                //     new DateTime.utc(date.year, date.month, date.day);
                                // print(dateTime.toString());
                                setState(() {});
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  " $_date",
                                  style: TextStyle(
                                      color: Colors.black,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            // padding: EdgeInsets.symmetric(
                            //     horizontal: 100, vertical: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                          onPressed: () {
                            DatePicker.showTimePicker(context,
                                theme: DatePickerTheme(
                                    containerHeight: 210.0,
                                    backgroundColor: Colors.white),
                                showTitleActions: true, onConfirm: (time) {
                              if (time == null) {
                                return 'This field can\'t be empty !!';
                              } else {
                                // print('confirm $time');
                                _time =
                                    '${time.hour} : ${time.minute} : ${time.second}';
                                hour = time.hour;
                                minutes = time.minute;
                                second = time.second;
                                dateTime = DateTime(
                                    year, month, day, hour, minutes, second);
                                offer = FreelanceOffer(
                                    id: offer.id,
                                    user: widget.userAccount,
                                    dateOfPublication: offer.dateOfPublication,
                                    title: offer.title,
                                    description: offer.description,
                                    image: offer.image,
                                    wage: offer.wage,
                                    deadLine: dateTime,
                                    skills: offer.skills);
                              }
                              //print(dateTime.toString());
                              setState(() {});
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                            setState(() {});
                          },
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.access_time,
                                size: 18.0,
                                color: Colors.teal,
                              ),
                              Text(
                                " $_time",
                                style: TextStyle(
                                    color: Colors.black,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
                SizedBox(
                  height: 15,
                ),
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
                              onPressed: _saveForm,
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
