import 'package:UnknownPlaces/controller/firebase_controller.dart';
import 'package:UnknownPlaces/screens/display_screen.dart';
import 'package:UnknownPlaces/screens/home_screen.dart';
import 'package:UnknownPlaces/screens/signin_screen.dart';
import 'package:UnknownPlaces/screens/view/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangeUserInfoScreen extends StatefulWidget {
  static const routeName = '/settingsScreen/changeUserInfoScreen';
  @override
  State<StatefulWidget> createState() {
    return ChangeUserInfoState();
  }
}

class ChangeUserInfoState extends State<ChangeUserInfoScreen> {
  Controller con;
  FirebaseUser user;
  var formKey = GlobalKey<FormState>();
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
        title: Text("Change Email"),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: 'Email'),
              initialValue: user.email,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              validator: con.validEmail,
              onSaved: con.onSavedEmail,
            ),
            RaisedButton(
              child: Text("Save Changes"),
              onPressed: con.saveNewEmail,
            ),
          ],
        ),
      ),
    );
  }
}

class Controller {
  ChangeUserInfoState state;
  Controller(this.state);
  String email;

  void saveNewEmail() async {
    if (!state.formKey.currentState.validate()) {
      return;
    } else {
      state.formKey.currentState.save();

      try {
        await state.user.updateEmail(this.email);
        await FireBaseController.signOut();
        Navigator.pushReplacementNamed(state.context, SignInScreen.routeName);
      } catch (e) {
        MyDialog.info(
          context: state.context,
          title: 'Update Email Error',
          content: e.message ?? e.toString(),
        );
      }
    }
  }

  String validEmail(String value) {
    if (value.contains('@') && value.contains('.')) {
      return null;
    } else {
      return 'Not a Valid email';
    }
  }

  void onSavedEmail(String value) {
    this.email = value;
  }
}
