import 'dart:convert';

import 'package:UnknownPlaces/screens/view/mydialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class RequestController {
  static const apikey = 'AIzaSyDk8u_FauTz0f5DxY_wemRmqwZbTSonwYY';
  static const url =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?';
  static const latitude = 35.650956;
  static const longitude = -97.453361;

  static Future<Map<String, dynamic>> test(String keyWord) async {
    var dio = Dio();
    var parameters = {
      'key': apikey,
      'location': '$latitude,$longitude',
      'radius': '1609',
      'keyword': keyWord,
    };

    var response = await dio.get(url, queryParameters: parameters);
    dio.close();
    var name = response.data['results']
        .map<String>((results) => results['name'].toString())
        .toList();
    var vicinity = response.data['results']
        .map<String>((results) => results['vicinity'].toString())
        .toList();
    // var photos = response.data['results']
    //     .map<String>(
    //         (results) => results['photos'][0]['photo_reference'].toString())
    //     .toList();
    // print(photos);

    var readable = {
      'name': name,
      'vicinity': vicinity,
    };
    //print(name);

    return readable;
  }

  static Future<Map<String, dynamic>> search(String searchItem) async {
    const urls =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?';
    String input = searchItem.trim();
    var parameters = {
      'key': apikey,
      'input': input,
      'inputtype': 'textquery',
      'fields': 'photos,formatted_address,name,opening_hours,rating',
      'locationbias': 'circle:2500@35.650956,-97.453361',
    };
    var dio = Dio();
    var res = await dio.get(urls, queryParameters: parameters);
    dio.close();

    var name = res.data['candidates']
        .map<String>((results) => results['name'].toString())
        .toList();

    var add = res.data['candidates']
        .map<String>((results) => results['formatted_address'].toString())
        .toList();

    var rating = res.data['candidates']
        .map<String>((results) => results['rating'].toString())
        .toList();

    var open = res.data['candidates']
        .map<String>(
            (results) => results['opening_hours']['open_now'].toString())
        .toList();

    //print(res.data['candidates'][0]['opening_hours']['open_now']);

    var read = {
      'name': name,
      'address': add,
      'ratings': rating,
      'open': open,
    };

    return read;
  }
}
