import 'package:UnknownPlaces/model/geometry.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UnknownPlaces {
  static const COLLECTION = 'unknownPlaces';
  static const PHOTO_FOLDER = 'unknownPlacesPictures';
  static const NAME = 'name';
  static const RATING = 'rating';
  static const IMAGE_URL = 'imageURL';
  static const PLACE_ID = 'placeId';
  static const VICINITY = 'vicinity';
  static const TIMESTAMP = 'timestamp';
  static const CREATED_BY = 'createdBy';
  static const DOC_ID = 'docId';

  String name;
  double rating;
  String vicinity;
  Geometry geometry;
  int userRatings;
  String placeId;
  String createdBy;
  String imageUrl;
  String docId;
  DateTime timestamp;

  void setImageUrl(String url) {
    this.imageUrl = url;
  }

  UnknownPlaces({
    this.name,
    this.rating,
    this.vicinity,
    this.geometry,
    this.userRatings,
    this.placeId,
    this.imageUrl,
    this.createdBy,
    this.timestamp,
    this.docId,
  });

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      NAME: name,
      RATING: rating,
      VICINITY: vicinity,
      TIMESTAMP: timestamp,
      CREATED_BY: createdBy,
      IMAGE_URL: imageUrl,
    };
  }

  UnknownPlaces.fromJson(Map<dynamic, dynamic> parsedJson)
      : name = parsedJson['name'],
        rating = (parsedJson['rating'] != null)
            ? parsedJson['rating'].toDouble()
            : null,
        vicinity = parsedJson['vicinity'],
        geometry = Geometry.fromJson(parsedJson['geometry']),
        userRatings = (parsedJson['user_ratings_total'] != null)
            ? parsedJson['user_ratings_total'].toInt()
            : null,
        placeId =
            (parsedJson['place_id'] != null) ? parsedJson['place_id'] : null;
}
