import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapFindScreen extends StatefulWidget {
  static const routeName = '/homeScreen/MapFindScreen';
  @override
  State<StatefulWidget> createState() {
    return MapFindState();
  }
}

class MapFindState extends State<MapFindScreen> {
  double lat;
  double lng;
  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    lat ??= arg['lat'];
    lng ??= arg['lng'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
      ),
      body: (lat != null && lng != null)
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          lat,
                          lng,
                        ),
                        zoom: 16.0,
                      ),
                      zoomGesturesEnabled: true,
                    ),
                  )
                ],
              ),
            )
          : Container(
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text("Loading...."),
                  ],
                ),
              ),
            ),
    );
  }
}
