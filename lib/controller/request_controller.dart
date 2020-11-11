import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RequestController {
  static const apikey = 'AIzaSyDk8u_FauTz0f5DxY_wemRmqwZbTSonwYY';
  static const url =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
  static const latitude = 35.650956;
  static const longitude = -97.453361;

  static Future<List<String>> test(String keyWord) async {
    var dio = Dio();
    var parameters = {
      'key': apikey,
      'location': '$latitude,$longitude',
      'radius': '1609',
      'keyword': keyWord,
    };

    var response = await dio.get(url, queryParameters: parameters);
    var readable = response.data['results']
        .map<String>((results) => results['name'].toString())
        .toList();

    return readable;
  }
}
