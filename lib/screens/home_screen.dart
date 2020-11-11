import 'package:UnknownPlaces/controller/request_controller.dart';
import 'package:UnknownPlaces/screens/display_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller/firebase_controller.dart';
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
  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    user ??= ModalRoute.of(context).settings.arguments;
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
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.displayName ?? 'N/A'),
              accountEmail: Text(user.email),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Sign Out."),
              onTap: con.signOut,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}

class Controller {
  HomeState state;
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
      var results = await RequestController.test(newValue);
      await Navigator.pushNamed(state.context, DisplayScreen.routeName,
          arguments: {'user': state.user, 'results': results});
      state.render(() {});
    }
  }
}
