import 'package:UnknownPlaces/controller/firebase_controller.dart';
import 'package:UnknownPlaces/screens/signin_screen.dart';
import 'package:UnknownPlaces/screens/view/mydialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signUpScreen';
  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUpScreen> {
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
        title: Text("Create an Account"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text(
                "Create An Account",
                style: TextStyle(fontSize: 30.0),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Email'),
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
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
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                child: Text(
                  "Create",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
                onPressed: con.signUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Controller {
  SignUpState state;
  Controller(this.state);
  String email;
  String password;

  void signUp() async {
    if (!state.formKey.currentState.validate()) return;

    state.formKey.currentState.save();
    MyDialog.progessStart(state.context);

    try {
      await FireBaseController.signUp(email, password);

      await MyDialog.newAccount(state.context);
      MyDialog.progessEnd(state.context);
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.progessEnd(state.context);
      MyDialog.info(
        context: state.context,
        title: 'Account Creation error',
        content: e.message ?? e.toString(),
      );
    }
  }

  String validEmail(String value) {
    if (value.contains('@') && value.contains('.'))
      return null;
    else
      return 'Invalid Email';
  }

  void onSavedEmail(String value) {
    this.email = value;
  }

  String validPassword(String value) {
    if (value.length < 6)
      return "Min Char 6";
    else
      return null;
  }

  void onSavedPassword(String value) {
    this.password = value;
  }
}
