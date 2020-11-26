import 'package:geolocator/geolocator.dart';

class GeolocatorController {
  Future<Position> getLocation() async {
    var geolocator = Geolocator();
    Position userLocation = await geolocator.getCurrentPosition(
        locationPermissionLevel: GeolocationPermission.location);
    return userLocation;
  }
}
