import 'package:UnknownPlaces/model/geometry.dart';

class UnknownPlaces {
  String name;
  double rating;
  String vicinity;
  Geometry geometry;
  int userRatings;

  UnknownPlaces({
    this.name,
    this.rating,
    this.vicinity,
    this.geometry,
    this.userRatings,
  });

  UnknownPlaces.fromJson(Map<dynamic, dynamic> parsedJson)
      : name = parsedJson['name'],
        rating = (parsedJson['rating'] != null)
            ? parsedJson['rating'].toDouble()
            : null,
        vicinity = parsedJson['vicinity'],
        geometry = Geometry.fromJson(parsedJson['geometry']),
        userRatings = (parsedJson['user_ratings_total'] != null)
            ? parsedJson['user_ratings_total'].toInt()
            : null;
}
