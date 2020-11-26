import 'package:UnknownPlaces/model/location.dart';

class Geometry {
  Location location;

  Geometry({
    this.location,
  });

  Geometry.fromJson(Map<dynamic, dynamic> parsedJson)
      : location = Location.fromJson(parsedJson['location']);
}
