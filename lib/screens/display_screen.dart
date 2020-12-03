import 'package:UnknownPlaces/controller/firebase_controller.dart';
import 'package:UnknownPlaces/model/unknownplaces.dart';
import 'package:UnknownPlaces/screens/mapfind_screen.dart';
import 'package:UnknownPlaces/screens/view/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DisplayScreen extends StatefulWidget {
  static const routeName = '/homeScreen/displayScreen';
  @override
  State<StatefulWidget> createState() {
    return DisplayState();
  }
}

class DisplayState extends State<DisplayScreen> {
  Controller con;
  var results;
  FirebaseUser user;
  String image;
  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    image ??= args['imageurl'];
    results ??= args['results'];
    return Scaffold(
      appBar: AppBar(
        title: Text("${results.name}"),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              (image != null)
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(image),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4,
                      child: Icon(
                        Icons.broken_image,
                        size: 75.0,
                      ),
                    ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text(
                  results.name,
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text(
                  results.vicinity,
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.star_border),
                title: Text(results.rating.toString(),
                    style: TextStyle(fontSize: 30.0)),
              ),
              ListTile(
                leading: Icon(Icons.vpn_lock),
                title: Text(
                    "Lat: ${results.geometry.location.lat.toString()} Lng: ${results.geometry.location.lng.toString()} ",
                    style: TextStyle(fontSize: 30.0)),
              ),
              RaisedButton(
                child: Text("View On Map"),
                onPressed: con.mapFind,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Controller {
  DisplayState state;
  Controller(this.state);

  void mapFind() {
    Navigator.pushNamed(state.context, MapFindScreen.routeName, arguments: {
      "lat": state.results.geometry.location.lat,
      'lng': state.results.geometry.location.lng,
    });
  }
}
