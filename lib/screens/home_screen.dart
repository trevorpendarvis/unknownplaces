import 'package:UnknownPlaces/controller/request_controller.dart';
import 'package:UnknownPlaces/screens/quicksearch_screen.dart';
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
        title: Text("Home Screen"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.displayName ?? 'N/A'),
              accountEmail: Text(user.email),
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text("Quick Search"),
              onTap: con.quickSearch,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Sign Out."),
              onTap: con.signOut,
            ),
          ],
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

  void quickSearch() {
    Navigator.pushNamed(state.context, QuickSearchScreen.routeName,
        arguments: state.user);
  }
}
