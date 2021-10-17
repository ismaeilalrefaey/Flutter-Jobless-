// import 'package:location/location.dart';
import '../models/location.dart';
import 'package:geolocator/geolocator.dart';
// import 'world_locations.dart';

class GPSAccessService {
  UserLocation _currentLocation = UserLocation(0.0, 0.0, 'K.', '16');
  var geolocation = Geolocator();

  Future<UserLocation> getCurrentLocation() async {
    try {
      print('Trying');
      var userGeolocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      print('Got your current location');
      _currentLocation = UserLocation(
          userGeolocation.latitude, userGeolocation.longitude, '', '');

      _currentLocation.setToNearestKnownLocation();
      print('Shifted to the nearest known location');
    } catch (e) {
      print('Error getting the location: $e');
    }
    return _currentLocation;
  }
}
