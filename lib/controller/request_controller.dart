import 'package:UnknownPlaces/model/unknownPlaces.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';

class RequestController {
  final apikey = 'AIzaSyDk8u_FauTz0f5DxY_wemRmqwZbTSonwYY';
  final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?';
  var dio = Dio();
  final latitude = 35.650956;
  final longitude = -97.453361;
  Future<List<UnknownPlaces>> getPlaces(String keyword) async {
    var parameters = {
      'key': apikey,
      'location': '$latitude,$longitude',
      'radius': '1609',
      'keyword': keyword,
    };
    var response = await dio.get(url, queryParameters: parameters);

    dio.close();

    var json = response.data['results'];

    var jsonResults = json as List;

    return jsonResults.map((place) => UnknownPlaces.fromJson(place)).toList();
  }

  void debug() async {
    String search = 'https://maps.googleapis.com/maps/api/place/details/json?';
    var parameters = {
      'key': apikey,
      'place_id': "ChIJi6C1MxquEmsR9-c-3O48ykI",
      'fields': "name,formatted_phone_number,photos",
    };
    var response = await dio.get(search, queryParameters: parameters);

    dio.close();

    var json = response.data['result']['photos'][0]['photo_reference'];
    print(json);
  }

  Future<String> getPhotoRef(String ref) async {
    String url = 'https://maps.googleapis.com/maps/api/place/details/json?';
    var parameters = {
      'key': apikey,
      'place_id': ref,
      'fields': "name,formatted_phone_number,photos",
    };
    var response = await dio.get(url, queryParameters: parameters);
    var json;
    dio.close();
    try {
      json = response.data['result']['photos'][0]['photo_reference'];
    } catch (e) {
      print(e.toString());
      return null;
    }
    return json;
  }

  String getImageUrl(String photoRef) {
    String imageUrl =
        'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoRef&key=$apikey';
    return imageUrl;
  }
}
