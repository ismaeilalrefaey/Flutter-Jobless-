//@dart=2.9
import 'dart:math';
import 'package:geolocator/geolocator.dart';

import '../services/world_locations.dart';

class UserLocation {
  double latitude, longitude;
  String city, country;

  UserLocation(this.latitude, this.longitude, this.city, this.country);

  double distanceFrom(UserLocation other) {
    /*
    final int R = 6371; // Radius of the earth
    double lat1 = this.latitude;
    double lon1 = this.longitude;
    double lat2 = other.latitude;
    double lon2 = other.longitude;
    double latDistance = toRad(lat2 - lat1);
    double lonDistance = toRad(lon2 - lon1);
    double a = pow(sin(latDistance / 2), 2) +
        cos(toRad(lat1)) * cos(toRad(lat2)) * pow(sin(lonDistance / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c;
    // print('The distance between ${this.city} and ${other.city} is: $distance');
    return distance; // in KMs
    */

    return Geolocator.distanceBetween(
        this.latitude, this.longitude, other.latitude, other.longitude);
  }

  static double toRad(double value) {
    return value * pi / 180;
  }

  void setToNearestKnownLocation() {
    UserLocation nearest = UserLocation(0.0, 0.0, 'city', 'country');
    locations.forEach((element) {
      if (this.distanceFrom(element) < this.distanceFrom(nearest))
        nearest = element;
    });
    this.city = nearest.city;
    this.country = nearest.country;
  }

  UserLocation getCityCoordinates() {
    if (locationsV2[this.country] == null)
      this.country = this.country.toLowerCase();
    if (locationsV2[this.country] == null) return this;
    locationsV2[this.country].forEach((element) {
      if (element.city == this.city) {
        this.latitude = element.latitude;
        this.longitude = element.longitude;
      }
    });
    return this;
  }

  String toString() {
    return '(' +
        this.city +
        ', ' +
        this.country +
        ' / ' +
        this.latitude.toString() +
        ', ' +
        this.longitude.toString() +
        ')';
  }
}
