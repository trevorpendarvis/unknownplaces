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
  Map resluts;
  List renderName;
  List renderLocation;
  FirebaseUser user;
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
    resluts ??= args['results'];
    renderName ??= resluts['name'];
    renderLocation ??= resluts['vicinity'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Quick Search"),
      ),
      body: ListView.builder(
        itemBuilder: con.getListTile,
        itemCount: renderName.length,
      ),
    );
  }
}

class Controller {
  DisplayState state;
  Controller(this.state);

  Widget getListTile(BuildContext context, int index) {
    return Container(
      color: Colors.grey[700],
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      child: ListTile(
        title: Text(
          state.renderName[index],
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text("", style: TextStyle(color: Colors.black)),
        onTap: () => onTapTitle(context, index, state.renderLocation[index]),
      ),
    );
  }

  void onTapTitle(BuildContext context, int index, String location) {
    MyDialog.info(
      context: context,
      title: 'Location',
      content: location,
    );
  }
}
