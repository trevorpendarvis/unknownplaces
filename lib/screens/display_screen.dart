import 'package:UnknownPlaces/controller/firebase_controller.dart';
import 'package:UnknownPlaces/model/unknownplaces.dart';
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
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: con.fav,
          ),
        ],
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
                      child: Icon(Icons.broken_image),
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

  void fav() async {
    var u = UnknownPlaces(
      name: state.results.name,
      createdBy: state.user.email,
      imageUrl: state.image,
      rating: state.results.rating,
      vicinity: state.results.vicinity,
      timestamp: DateTime.now(),
    );

    await FireBaseController.addFav(u);
  }
}
