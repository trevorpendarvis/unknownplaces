//import 'package:UnknownPlaces/controller/request_controller.dart';
import 'package:UnknownPlaces/screens/view/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/homeScreen/searchScreen';
  @override
  State<StatefulWidget> createState() {
    return SearchState();
  }
}

class SearchState extends State<SearchScreen> {
  Controller con;
  FirebaseUser user;
  Map results;
  List name;
  List address;
  List ratings;
  List open;
  String message;
  var formKey = GlobalKey<FormState>();
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
        actions: [
          Container(
            width: 280.0,
            child: Form(
              key: formKey,
              child: TextFormField(
                cursorColor: Colors.white,
                decoration: InputDecoration(hintText: 'Search'),
                autocorrect: true,
                validator: con.validSearch,
                onSaved: con.onSavedSearch,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: con.search,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: results == null
            ? Text("No Results")
            : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: con.getListTile,
                itemCount: name.length,
              ),
      ),
    );
  }
}

class Controller {
  SearchState state;
  Controller(this.state);
  String searchItem;

  void search() async {
    if (!state.formKey.currentState.validate()) {
      return;
    } else {
      MyDialog.progessStart(state.context);
      state.formKey.currentState.save();
      try {
        // state.results = await RequestController.search(this.searchItem);
        // state.name = state.results['name'];
        // state.address = state.results['address'];
        // state.open = state.results['open'];
        // state.ratings = state.results['ratings'];
        MyDialog.progessEnd(state.context);
      } catch (e) {
        MyDialog.progessEnd(state.context);
        MyDialog.info(
          context: state.context,
          title: 'error',
          content: e.toString(),
        );
      }
      state.render(() {});
    }
  }

  String validSearch(String value) {
    if (value.length != 0) {
      return null;
    } else {
      return 'Search Bar is Empty';
    }
  }

  void onSavedSearch(String value) {
    this.searchItem = value;
  }

  Widget getListTile(BuildContext context, int index) {
    return Container(
      color: Colors.grey[700],
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      child: ListTile(
        title: Text(
          state.name[index],
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text("", style: TextStyle(color: Colors.black)),
        onTap: () => onTapTitle(context, index),
      ),
    );
  }

  void onTapTitle(BuildContext context, int index) {
    state.message =
        'Name: ${state.name[index]}\n\n Address: ${state.address[index]}\n\n Open: ${state.open[index]}\n\n Ratings: ${state.ratings[index]}';
    MyDialog.info(
      context: context,
      title: 'Information',
      content: state.message,
    );
  }
}
