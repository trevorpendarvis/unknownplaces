import 'package:flutter/material.dart';

class QuickSearchScreen extends StatefulWidget {
  static const routeName = '/homeScreen/quickSearchScreen';
  @override
  State<StatefulWidget> createState() {
    return QuickSearchState();
  }
}

class QuickSearchState extends State<QuickSearchScreen> {
  Controller con;
  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quick Search"),
      ),
      body: Text("Quick Search"),
    );
  }
}

class Controller {
  QuickSearchState state;
  Controller(this.state);
}
