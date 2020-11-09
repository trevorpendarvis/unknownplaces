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
      body: Form(
        key: formKey,
        child: Column(
          children: [
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
          ],
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

  void signIn() {
    if (!state.formKey.currentState.validate()) {
      return;
    } else {
      state.formKey.currentState.save();
      print("Email: $email");
      print("Password: $password");
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
    if (value.length >= 4) {
      return null;
    } else {
      return 'Min char 4';
    }
  }

  void onSavedPassword(String value) {
    this.password = value;
  }
}
