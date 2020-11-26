import 'package:UnknownPlaces/controller/firebase_controller.dart';
//import 'package:UnknownPlaces/controller/request_controller.dart';
import 'package:UnknownPlaces/screens/home_screen.dart';
import 'package:UnknownPlaces/screens/signup_screen.dart';
import 'package:UnknownPlaces/screens/view/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signInScreen';
  @override
  State<StatefulWidget> createState() {
    return SignInState();
  }
}

class SignInState extends State<SignInScreen> {
  Controller con;
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Stack(children: [
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
              TextFormField(
                decoration: InputDecoration(hintText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: con.validEmail,
                onSaved: con.onSavedEmail,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Password'),
                autocorrect: false,
                obscureText: true,
                validator: con.validPassword,
                onSaved: con.onSavedPassword,
              ),
              RaisedButton(
                child: Text(
                  "Log In",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: con.signIn,
                color: Colors.blue,
              ),
              RaisedButton(
                child: Text("Click here to create a account."),
                onPressed: con.createAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Controller {
  SignInState state;
  Controller(this.state);
  String email;
  String password;

  void signIn() async {
    if (!state.formKey.currentState.validate()) {
      return;
    } else {
      state.formKey.currentState.save();
      MyDialog.progessStart(state.context);

      try {
        FirebaseUser user = await FireBaseController.signIn(email, password);
        print("USER: $user");
        MyDialog.progessEnd(state.context);

        Navigator.pushReplacementNamed(state.context, HomeScreen.routeName,
            arguments: user);
      } catch (e) {
        MyDialog.progessEnd(state.context);
        MyDialog.info(
          context: state.context,
          title: "Sign In Error",
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

  String validPassword(String value) {
    if (value.length >= 6) {
      return null;
    } else {
      return 'Min char 6';
    }
  }

  void onSavedPassword(String value) {
    this.password = value;
  }

  void createAccount() {
    Navigator.pushNamed(state.context, SignUpScreen.routeName);
  }
}
