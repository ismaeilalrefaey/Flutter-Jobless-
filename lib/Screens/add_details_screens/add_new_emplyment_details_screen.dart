//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../../models/location.dart';
import '../../services/world_locations.dart';
import 'package:provider/provider.dart';
import '../../providers/employment_details.dart';

class AddNewEmploymentDetailsScreen extends StatefulWidget {
  static const routeName = 'add-new-employment-detail-screen';
  @override
  _AddNewEmploymentDetailsScreenState createState() =>
      _AddNewEmploymentDetailsScreenState();
}

class _AddNewEmploymentDetailsScreenState
    extends State<AddNewEmploymentDetailsScreen> {
  var _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  EmploymentDetails employmentDetails = EmploymentDetails(
    id: null,
    to: null,
    from: null,
    userId: '',
    jobTitle: '',
    jobDetails: '',
    jobLocation: UserLocation(0.0, 0.0, 'city', 'country'),
  );
  List<String> countries = [], cities = [];

  String _toDate = 'Not Set';
  String _fromDate = 'Not Set';
  UserLocation userLocation = UserLocation(0.0, 0.0, 'city', 'country');
  String selectedCity, selectedCountry;
  var isInit = true;
  var userId;
  @override
  void didChangeDependencies() {
    if (isInit) {
      countries.addAll(locationsV2.entries.map((e) => e.key));
      userId = ModalRoute.of(context).settings.arguments as String;
    }
    isInit = false;
    // cities = [];
    // if (selectedCountry != null) {
    //   locationsV2[selectedCountry].forEach((element) {
    //     cities.add(element.city);
    //   });
    // }
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
    setState(() {
      _isLoading = true;
    });
    if (!_formKey.currentState.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _formKey.currentState.save();
    employmentDetails.userId = userId;
    employmentDetails.jobLocation =
        employmentDetails.jobLocation.getCityCoordinates();
    print(employmentDetails.userId);
    print(employmentDetails.jobTitle);
    print(employmentDetails.jobDetails);
    print(employmentDetails.to);
    print(employmentDetails.from);
    try {
      await Provider.of<EmploymentDetailsProvider>(context, listen: false)
          .add(employmentDetails);
      Navigator.of(context).pop();
    } catch (error) {
      _showErrorDialog(error.toString());
      setState(() {
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget textFormField(String labelText, TextInputType textInputType,
        Function onSaved, Function validator) {
      return TextFormField(
        minLines: 1,
        onSaved: onSaved,
        validator: validator,
        keyboardType: textInputType,
        maxLines: labelText == 'Job Details' ? 30 : 1,
        textInputAction: labelText == 'Job Details'
            ? TextInputAction.newline
            : TextInputAction.next,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
        ),
      );
    }

    if (selectedCountry != null) {
      cities = [];
      locationsV2[selectedCountry].forEach((element) {
        cities.add(element.city);
      });
    }

    DateTime from, to;

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(title: const Text('Add a new Employment Detail')),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                // Title
                textFormField(
                  'Job Title',
                  TextInputType.text,
                  (value) {
                    // employmentDetails = EmploymentDetails(
                    //   id: employmentDetails.id,
                    //   to: employmentDetails.to,
                    //   from: employmentDetails.from,
                    //   userId: userId,
                    //   jobTitle: value,
                    //   jobDetails: employmentDetails.jobDetails,
                    //   jobLocation: employmentDetails.jobLocation,
                    // );
                    employmentDetails.jobTitle = value;
                  },
                  (value) {
                    if (value.isEmpty) return 'This field can\'t be empty !!';
                    return null;
                  },
                ),
                SizedBox(height: 15),

                // Details
                textFormField(
                  'Job Details',
                  TextInputType.multiline,
                  (value) {
                    // employmentDetails = EmploymentDetails(
                    //   id: employmentDetails.id,
                    //   to: employmentDetails.to,
                    //   from: employmentDetails.from,
                    //   userId: userId,
                    //   jobTitle: employmentDetails.jobTitle,
                    //   jobDetails: value,
                    //   jobLocation: employmentDetails.jobLocation,
                    // );
                    employmentDetails.jobDetails = value;
                  },
                  (value) {
                    if (value.isEmpty) return 'This field can\'t be empty !!';
                    return null;
                  },
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('From:',
                        style: TextStyle(color: Colors.black, fontSize: 15.0)),
                    Row(
                      children: [
                        Text('To:',
                            style:
                                TextStyle(color: Colors.black, fontSize: 15.0)),
                        SizedBox(width: 130),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () {
                          DatePicker.showDatePicker(
                            context,
                            locale: LocaleType.en,
                            showTitleActions: true,
                            currentTime: DateTime.now(),
                            minTime: DateTime(1950, 1, 1),
                            maxTime: DateTime.now(),
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                              backgroundColor: Colors.white,
                            ),
                            onConfirm: (date) {
                              if (date == null) {
                                return 'This field can\'t be empty !!';
                                //return null;
                              } else {
                                _fromDate =
                                    '${date.day} - ${date.month} - ${date.year}';
                                from =
                                    DateTime(date.year, date.month, date.day);
                                print(from);
                                // employmentDetails = EmploymentDetails(
                                //   id: employmentDetails.id,
                                //   to: to,
                                //   from: from,
                                //   userId: userId,
                                //   jobTitle: employmentDetails.jobTitle,
                                //   jobDetails: employmentDetails.jobDetails,
                                //   jobLocation: employmentDetails.jobLocation,
                                // );
                                employmentDetails.from = from;
                              }
                              setState(() {});
                            },
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              size: 18.0,
                              color: Colors.teal,
                            ),
                            Text(
                              " $_fromDate",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 150,
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       primary: Colors.white,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(5.0),
                    //       ),
                    //     ),
                    //     onPressed: () {
                    //       DatePicker.showDatePicker(
                    //         context,
                    //         locale: LocaleType.en,
                    //         showTitleActions: true,
                    //         currentTime: DateTime.now(),
                    //         minTime: DateTime(1950, 1, 1),
                    //         maxTime: DateTime.now(),
                    //         theme: DatePickerTheme(
                    //           containerHeight: 210.0,
                    //           backgroundColor: Colors.white,
                    //         ),
                    //         onConfirm: (date) {
                    //           if (date == null) {
                    //             return 'This field can\'t be empty !!';
                    //             //return null;
                    //           } else {
                    //             _toDate =
                    //                 '${date.day} - ${date.month} - ${date.year}';
                    //             print(_toDate);
                    //             employmentDetails = EmploymentDetails(
                    //               id: employmentDetails.id,
                    //               from: employmentDetails.from,
                    //               to: DateTime(date.year, date.month, date.day),
                    //               userId: userId,
                    //               jobTitle: employmentDetails.jobTitle,
                    //               jobDetails: employmentDetails.jobDetails,
                    //               jobLocation: employmentDetails.jobLocation,
                    //             );
                    //           }
                    //           setState(() {});
                    //         },
                    //       );
                    //     },
                    //     child: Row(
                    //       children: <Widget>[
                    //         Icon(
                    //           Icons.date_range,
                    //           size: 18.0,
                    //           color: Colors.teal,
                    //         ),
                    //         Text(
                    //           " $_toDate",
                    //           style: TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 15.0,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () {
                          DatePicker.showDatePicker(
                            context,
                            locale: LocaleType.en,
                            showTitleActions: true,
                            currentTime: DateTime.now(),
                            minTime: DateTime(1950, 1, 1),
                            maxTime: DateTime.now(),
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                              backgroundColor: Colors.white,
                            ),
                            onConfirm: (date) {
                              if (date == null) {
                                return 'This field can\'t be empty !!';
                                //return null;
                              } else {
                                _toDate =
                                    '${date.day} - ${date.month} - ${date.year}';
                                to = DateTime(date.year, date.month, date.day);
                                print(to);
                                // employmentDetails = EmploymentDetails(
                                //   id: employmentDetails.id,
                                //   from: from,
                                //   to: to,
                                //   userId: userId,
                                //   jobTitle: employmentDetails.jobTitle,
                                //   jobDetails: employmentDetails.jobDetails,
                                //   jobLocation: employmentDetails.jobLocation,
                                // );
                                employmentDetails.to = to;
                              }
                              setState(() {});
                            },
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              size: 18.0,
                              color: Colors.teal,
                            ),
                            Text(
                              " $_toDate",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  child: DropdownButton<String>(
                    value: selectedCountry,
                    items: countries
                        .map<DropdownMenuItem<String>>((e) =>
                            DropdownMenuItem<String>(value: e, child: Text(e)))
                        .toList(),
                    hint: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Country',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedCountry = value;
                        employmentDetails.jobLocation.country = value;
                      });
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: DropdownButton<String>(
                      value: selectedCity,
                      items: cities
                          .map<DropdownMenuItem<String>>(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      hint: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'City',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          selectedCity = value;
                          employmentDetails.jobLocation.city = value;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          child: Text('Submit'),
                          onPressed: _saveForm,
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
