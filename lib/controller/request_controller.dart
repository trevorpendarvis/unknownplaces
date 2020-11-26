import 'package:UnknownPlaces/model/unknownPlaces.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

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
}
