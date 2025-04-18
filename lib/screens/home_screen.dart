import 'package:UnknownPlaces/controller/geolocator_controller.dart';
import 'package:UnknownPlaces/model/unknownPlaces.dart';
import 'package:UnknownPlaces/controller/request_controller.dart';
import 'package:UnknownPlaces/screens/display_screen.dart';
import 'package:UnknownPlaces/screens/mapfind_screen.dart';
import 'package:UnknownPlaces/screens/search_screen.dart';
import 'package:UnknownPlaces/screens/settings_screen.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/firebase_controller.dart';
import 'signin_screen.dart';
import 'signin_screen.dart';
import 'view/mydialog.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/signInScreen/homeScreen';
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  Controller con;
  FirebaseUser user;
  String dropdownValue = 'Quick Search';
  Position userLocation;
  GeolocatorController geo;
  List<UnknownPlaces> results;
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    con = Controller(this);
    geo = GeolocatorController();
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    user ??= ModalRoute.of(context).settings.arguments;
    con.getLocation();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            items: <String>['Food', 'Gas', 'Hotel', 'Groceries', 'Quick Search']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(child: Text(value)),
              );
            }).toList(),
            onChanged: (value) => con.quickSearch(value),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: con.clearSearch,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.displayName ?? 'N/A'),
              accountEmail: Text(user.email),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Edit Profile'),
              onTap: con.settings,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Sign Out."),
              onTap: con.signOut,
            ),
          ],
        ),
      ),
      body: (results == null || results.length == 0)
          ? SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(hintText: "Search"),
                        autocorrect: true,
                        validator: con.validSearch,
                        onSaved: con.onSavedSearch,
                      ),
                      RaisedButton(
                        child: Text("Search"),
                        onPressed: con.save,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                        child: Stack(children: [
                          Image.asset('assets/images/logo2.jpg'),
                          Positioned(
                            top: 25.0,
                            left: 100.0,
                            child: Text(
                              "Unknown Places",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25.0,
                                fontFamily: "Cinzel",
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      color: Colors.grey[300],
                      child: ListTile(
                        title: Text(
                          "${results[index].name}",
                          style: TextStyle(fontSize: 35.0),
                        ),
                        subtitle: Text(
                          "${results[index].vicinity}",
                          style: TextStyle(fontSize: 25.0),
                        ),
                        onTap: () => con.onTapTile(context, index),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class Controller {
  HomeState state;
  String keyword;
  Controller(this.state);

  void signOut() async {
    try {
      await FireBaseController.signOut();
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Sign Out error',
        content: e.message ?? e.toString(),
      );
    }
    Navigator.pushReplacementNamed(state.context, SignInScreen.routeName);
  }

  void quickSearch(String newValue) async {
    if (newValue == state.dropdownValue) {
      return;
    } else {
      try {
        MyDialog.progessStart(state.context);
        RequestController requestController = RequestController();
        state.results = await requestController.getPlaces(newValue);
        MyDialog.progessEnd(state.context);
        state.render(() {});
      } catch (e) {
        MyDialog.progessEnd(state.context);
        MyDialog.info(
          context: state.context,
          title: "Places search error",
          content: e.toString(),
        );
      }
    }
  }

  void settings() async {
    await Navigator.pushNamed(state.context, SettingsScreen.routeName,
        arguments: state.user);
    await state.user.reload();
    state.user = await FirebaseAuth.instance.currentUser();
    Navigator.pop(state.context);
  }

  void search() async {
    await Navigator.pushNamed(state.context, SearchScreen.routeName,
        arguments: state.user);
    Navigator.pop(state.context);
  }

  void save() async {
    if (!state.formKey.currentState.validate()) {
      return;
    } else {
      state.formKey.currentState.save();

      try {
        MyDialog.progessStart(state.context);
        RequestController requestController = RequestController();
        state.results = await requestController.getPlaces(this.keyword);
        MyDialog.progessEnd(state.context);
        if (state.results == null || state.results.length == 0) {
          showDialog(
              context: state.context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Search Error"),
                  content: Text("Could not find what you were looking for"),
                  actions: [
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              });
        }

        state.render(() {});
      } catch (e) {
        MyDialog.progessEnd(state.context);
        MyDialog.info(
          context: state.context,
          title: "Places search error",
          content: e.toString(),
        );
      }
    }
  }

  void getLocation() async {
    state.userLocation = await state.geo.getLocation();
    state.render(() {});
  }

  void favorite() async {}

  String validSearch(String value) {
    if (value != null) {
      return null;
    } else {
      return "not valid search";
    }
  }

  void onSavedSearch(String value) {
    this.keyword = value;
  }

  Widget getListItems(BuildContext context, int index) {
    return Container(
      color: Colors.grey[700],
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      child: ListTile(
        title: Text(
          state.results[index].name,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          "Location: ${state.results[index].vicinity}\n Rating: ${state.results[index].rating.toString()}\n User rating: ${state.results[index].userRatings.toString()}",
          style: TextStyle(color: Colors.black),
        ),
        onTap: () => onTapTile(context, index),
        onLongPress: () => onLongPressTile(context, index),
      ),
    );
  }

  void onTapTile(BuildContext context, int index) async {
    RequestController requestController = RequestController();
    String imageUrl;
    String ref =
        await requestController.getPhotoRef(state.results[index].placeId);
    if (ref != null) {
      imageUrl = requestController.getImageUrl(ref);
    } else {
      imageUrl = null;
    }

    Navigator.pushNamed(
      state.context,
      DisplayScreen.routeName,
      arguments: {
        'results': state.results[index],
        'user': state.user,
        'imageurl': imageUrl
      },
    );
  }

  void onLongPressTile(BuildContext context, int index) async {
    double lat = state.results[index].geometry.location.lat;
    double lng = state.results[index].geometry.location.lng;

    await Navigator.pushNamed(state.context, MapFindScreen.routeName,
        arguments: {'lat': lat, 'lng': lng});
    state.render(() {});
  }

  void clearSearch() {
    state.render(() {
      state.results = null;
    });
  }
}
