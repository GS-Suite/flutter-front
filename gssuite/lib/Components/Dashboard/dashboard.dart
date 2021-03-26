import 'dart:io';

import 'package:flutter/material.dart';
import 'subscription_Component.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Drawer Component/drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../modal/ClassroomDetails.dart';
import '../../apis/api.dart';
import '../Login_Screen/TextField_Component.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  SharedPreferences prefs;
  static String _user;
  var _userClassrooms = [];
  var _userEnrolledClasrooms = [];

  @override
  void initState() {
    print('init');
    super.initState();
    pref();
  }

  pref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _user = prefs.getString('username');
    });
    Map<String, String> _headers = {
      'token': prefs.getString('token'),
    };
    print(_headers);
    try {
      // For fetching your created classes
      var response = await http.post(getUserClassrooms, headers: _headers);
      var res = json.decode(response.body.toString());
      if (res['success'] == true) {
        print(res);
        setState(() {
          _userClassrooms = res['data'];
        });
        prefs.setString('token', res['token'].toString());
      } else {
        print('Response didn\'t fetch');
        print(res);
      }

      // For fetching your enrolled classes
      response = await http.post(getEnrolledClassrooms, headers: _headers);
      res = json.decode(response.body.toString());
      if (res['success'] == true) {
        print('hello');
        if (res['message'] == 'You aren\'t enrolled in any classroom') {
          print("you're not enrolled");
        } else {
          var enrolledList = [];
          var _body;
          var resp;
          print(res['data']);
          for (var i = 0; i < res['data'].length; i++) {
            print(res['data'][i]);
            var _body = json.encode({'classroom_uid': res['data'][i]});
            var val = await http.post(getClassroomDetails,
                headers: _headers, body: _body);
            var valRes = json.decode(val.body.toString());
            if (valRes['success'] == true) {
              print(true);
              setState(() {
                print(valRes['data']['name']);
                _userEnrolledClasrooms.add({
                  'name': valRes['data']['name'],
                  'uid': valRes['data']['uid']
                });
              });
            }
          }
          print('over');
          print(_userEnrolledClasrooms);
        }
      } else {
        print('Response didn\'t fetch');
        print(res);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Null> refreshClassrooms() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    pref();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null || _userClassrooms == []) {
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
                      SubscribedCourses(
                        title: 'Your Classes',
                        classrooms: _userClassrooms,
                        onRefresh: refreshClassrooms,
                        enrolled: false,
                      ),
                      SizedBox(height: 12.0),
                      SubscribedCourses(
                        title: 'Enrolled Classes',
                        classrooms: _userEnrolledClasrooms,
                        onRefresh: refreshClassrooms,
                        enrolled: true,
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.teal[400],
                onPressed: () => {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                              content: Container(
                                  child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () async => {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog'),
                                  await Navigator.pushNamed(
                                      context, '/create_class'),
                                  setState(() => {pref()})
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
                splashColor: Colors.teal[300],
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
