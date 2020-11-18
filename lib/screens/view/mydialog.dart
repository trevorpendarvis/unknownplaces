import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDialog {
  static void progessStart(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()));
  }

  static void progessEnd(BuildContext context) {
    Navigator.pop(context);
  }

  static void info({BuildContext context, String title, String content}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }

  static Future<void> newAccount(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Account Created"),
            content: Text("Successfully"),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }

  static Future<void> infoSearch(
      {BuildContext context, String title, Map content, int index}) async {
    String name = content['name'][index];
    String address = content['address'][index];
    String ratings = content['ratings'][index];
    String open = content['open'][index];
    String message =
        "Name ${name}\n Address: ${address}\n Rating: ${ratings}\n Open: ${open}";

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text('$message'),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }
}
