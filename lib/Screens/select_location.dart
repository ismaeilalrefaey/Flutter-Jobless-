//@dart=2.9
import 'package:flutter/material.dart';
import '../models/location.dart';

// ignore: must_be_immutable
class SelectLocation extends StatefulWidget {
  static const routeName = '/select-location-screen';
  final Function assign;
  final Map<String, List<UserLocation>> l;
  SelectLocation(this.assign, this.l);
  String selectedCountry, selectedCity;
  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 40,
            child: DropdownButton<String>(
              value: widget.selectedCountry,
              items: widget.l.keys
                  .map<DropdownMenuItem<String>>((element) =>
                      DropdownMenuItem<String>(
                          value: element, child: Text(element)))
                  .toList(),
              hint: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Country',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              onChanged: (String value) {
                setState(() {
                  widget.selectedCountry = value;
                  widget.assign(widget.selectedCity, widget.selectedCountry);
                });
              },
            ),
          ),
          Divider(
            thickness: 2,
            color: Colors.black,
          ),
          if (widget.l[widget.selectedCountry] != null)
            Container(
              width: double.infinity,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: DropdownButton<String>(
                  value: widget.selectedCity,
                  items: widget.l[widget.selectedCountry]
                      .map<DropdownMenuItem<String>>((e) =>
                          DropdownMenuItem<String>(
                              value: e.city, child: Text(e.city)))
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
                      widget.selectedCity = value;
                      widget.assign(
                          widget.selectedCity, widget.selectedCountry);
                    });
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
