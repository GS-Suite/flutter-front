import 'dart:io';

import 'package:flutter/material.dart';
import 'subscription_Component.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Drawer Component/drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  static String _user;

  @override
  void initState() {
    super.initState();
    pref();
  }

  pref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _user = prefs.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Center(
          child: SpinKitWanderingCubes(
        color: Colors.blueAccent,
      ));
    } else {
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.only(left: 0, top: 15),
              child: GestureDetector(
                onTap: () => _scaffoldKey.currentState.openDrawer(),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: '# ',
                    style: TextStyle(
                        color: Colors.teal[400],
                        fontWeight: FontWeight.bold,
                        fontSize: 33),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Hi, ' + _user + '!', // To be changed
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          drawer: AppDrawer(),
          body: Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SubscribedCourses(),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  AlertDialog alert(BuildContext context) => AlertDialog(
        title: Text("Attention!"),
        content: Text("DO you want to exit? "),
        actions: [
          FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text("Continue"),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              sleep(Duration(microseconds: 1));
              if (prefs.getString('username') != null) {
                exit(0);
              } else {
                Navigator.of(context).pop(true);
              }
            },
          ),
        ],
      );

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert(context);
      },
    );
  }
}
