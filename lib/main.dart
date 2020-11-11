import 'package:UnknownPlaces/screens/home_screen.dart';
import 'package:UnknownPlaces/screens/display_screen.dart';
import 'package:UnknownPlaces/screens/signin_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(UnknownPlacesApp());
}

class UnknownPlacesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        DisplayScreen.routeName: (context) => DisplayScreen(),
      },
    );
  }
}
