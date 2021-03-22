import 'dart:io';

import 'package:flutter/material.dart';
import 'subscription_Component.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Drawer Component/drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:adv_fab/adv_fab.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  static String _user;
  AdvFabController mabialaFABController;
  bool useFloatingSpaceBar = false;
  bool useAsFloatingActionButton = false;
  bool useNavigationBar = true;
  bool isPlaying = false;

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
          child: Container(
        child: SpinKitWanderingCubes(
          color: Colors.blueAccent,
        ),
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
                              text: _user.contains(' ')
                                  ? 'Hi, ' +
                                      _user.substring(0, _user.indexOf(' ')) +
                                      '!'
                                  : _user, // To be changed
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
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: Colors.teal[400],
                ),
                onPressed: () => {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                              content: Container(
                                  child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () => {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog'),
                                  Navigator.pushNamed(context, '/create_class')
                                },
                                child: Container(
                                  padding: EdgeInsets.all(15.0),
                                  height: 100,
                                  width: 130,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Icon(
                                          Icons.create_new_folder_outlined,
                                          size: 35.0,
                                          color: Colors.teal[400],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Center(
                                        child: Text('Create class',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () => {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog'),
                                  Navigator.pushNamed(context, '/join_class')
                                },
                                child: Container(
                                  padding: EdgeInsets.all(15.0),
                                  width: 130,
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Icon(
                                          Icons.arrow_circle_up_sharp,
                                          size: 35.0,
                                          color: Colors.teal[400],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Center(
                                        child: Text('Join class',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                ),
                              )
                            ],
                          ))))
                },
                backgroundColor: Colors.white60,
                foregroundColor: Colors.teal[400],
                splashColor: Colors.teal[100],
              )));
    }
  }

  AlertDialog alert(BuildContext context) => AlertDialog(
        title: Text("Attention!"),
        content: Text("Do you want to exit? "),
        actions: [
          FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text("Exit"),
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
