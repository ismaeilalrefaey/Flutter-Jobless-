// No need to parse the csv file every time we run the program
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import '../models/location.dart';

List<UserLocation> locations = [];
Map<String, List<UserLocation>> locationsV2 = {};

Future</*Map<String, List<UserLocation>>*/ void> getLocations() async {
  if (locationsV2.isNotEmpty) return;
  final String loadedString =
      await rootBundle.loadString('assets/worldcities.csv');
  print('Loaded');
  List<List<dynamic>> loadedCsv = CsvToListConverter().convert(loadedString);
  loadedCsv.removeAt(0);
  loadedCsv.forEach((element) {
    locations.add(UserLocation(
      double.parse(element[2]),
      double.parse(element[3]),
      element[1],
      element[4],
    ));
  });
  print('Converted');
  locations.removeWhere((element) =>
      element.city.contains('\'') || element.country.contains('\''));
  print('Cleaned');
  locations.sort((a, b) => a.country.compareTo(b.country));
  print('Sorted');
  var currentCountry = locations[0].country;
  List<UserLocation> currentList = [];
  // int i = 1;
  for (int i = 0; i < locations.length; i++) {
    var element = locations[i];
    if (element.country.compareTo(currentCountry) == 0) {
      currentList.add(element);
    } else {
      locationsV2[currentCountry] = currentList;
      currentList = [];
      currentList.add(element);
      currentCountry = element.country;
    }
  }
  locationsV2[currentCountry] = currentList; // Last Country

  locationsV2.forEach((key, value) {
    value.sort((a, b) => a.city.compareTo(b.city));
  });
  print('Done with Locations !!');
  // return locationsV2;
}
