import 'package:UnknownPlaces/controller/firebase_controller.dart';
import 'package:UnknownPlaces/screens/changeuserinfo_screen.dart';
import 'package:UnknownPlaces/screens/view/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/homeScreen/settingsScreen';
  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
}

class SettingsState extends State<SettingsScreen> {
  Controller con;
  var formKey = GlobalKey<FormState>();
  FirebaseUser user;
  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            onPressed: con.save,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: 'User Name'),
                autocorrect: false,
                initialValue: user.displayName ?? con.userName,
                validator: con.validUserName,
                onSaved: con.onSavedUserName,
              ),
              RaisedButton(
                child: Text("Change Email"),
                onPressed: con.changeEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Controller {
  SettingsState state;
  String userName;
  String email;
  Controller(this.state);

  void save() async {
    if (!state.formKey.currentState.validate()) {
      return;
    } else {
      state.formKey.currentState.save();

      try {
        await FireBaseController.updateUserInfo(userName, state.user);
        Navigator.pop(state.context);
      } catch (e) {
        MyDialog.info(
          context: state.context,
          title: 'Update Error',
          content: e.message ?? e.toString(),
        );
      }
    }
  }

  String validUserName(String value) {
    return null;
  }

  void onSavedUserName(String value) {
    this.userName = value;
  }

  void changeEmail() {
    Navigator.pushNamed(state.context, ChangeUserInfoScreen.routeName,
        arguments: state.user);
  }
}
