import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gssuite/Components/Dashboard/UniversalSearchPanel.dart';
import 'package:gssuite/Components/Profile/profile.dart';
import 'subscription_Component.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Drawer Component/drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../apis/api.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  static String _user;
  var _loading = true;
  var _userClassrooms = [];
  var _userEnrolledClasrooms = [];
  TextEditingController _searchController;

  @override
  void initState() {
    print('init');
    super.initState();
    pref();
    _searchController = TextEditingController();
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
        if (mounted) {
          setState(() {
            _loading = false;
            _userClassrooms = res['data'];
          });
        }
        prefs.setString('token', res['token'].toString());
      } else {
        if (res['message'] == 'Invalid token or non-existent user') {
          Navigator.of(context).pushNamed('/login');
          prefs.setString('token', '');
        }
        print(res);
      }

      // For fetching your enrolled classes
      response = await http.post(getEnrolledClassrooms, headers: _headers);
      res = json.decode(response.body.toString());
      if (res['success'] == true) {
        if (res['message'] == 'You aren\'t enrolled in any classroom') {
          print("you're not enrolled");
        } else {
          for (var i = 0; i < res['data'].length; i++) {
            print(res['data'][i]['uid']);
            var temp = {'teacher': res['data'][i]['teacher']};
            var _body = json.encode({'classroom_uid': res['data'][i]['uid']});
            var val = await http.post(getClassroomDetail,
                headers: _headers, body: _body);
            var valRes = json.decode(val.body.toString());
            print(valRes);
            if (valRes['success'] == true) {
              var tempEnroll = [];
              print(true);
              print('yuor truly');
              print(valRes['data']['name']);
              temp['name'] = valRes['data']['name'];
              temp['uid'] = valRes['data']['uid'];
              tempEnroll.add(temp);
              if (mounted) {
                setState(() {
                  _loading = false;
                  _userEnrolledClasrooms = tempEnroll;
                });
              }
            } else {
              print('failed');
            }
          }
          print('over');
          print(_userEnrolledClasrooms);
        }
      } else {
        if (res['message'] == 'Invalid token or non-existent user') {
          prefs.setString('token', null);
          Navigator.of(context).pushNamed('/login');
        }
        print('Response didn\'t fetch');
        print(res);
      }
    } catch (e) {
      print(e);
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.teal[300],
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null || _userClassrooms == []) {
      return Center(
          child: Container(
        color: Colors.white,
        child: SpinKitThreeBounce(
          color: Colors.teal[400],
        ),
      ));
    } else {
      var size = MediaQuery.of(context).size.height;
      Color kPrimaryColor = Colors.teal[300];

      const double kDefaultPadding = 20.0;
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: buildAppBar(),
            drawer: AppDrawer(),
            body: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 1.5,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: kDefaultPadding * 2.5),
                      // It will cover 20% of our total height
                      height: size * 0.2,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                              left: kDefaultPadding,
                              right: kDefaultPadding,
                              bottom: 36 + kDefaultPadding,
                            ),
                            height: size * 0.2 - 27,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(36),
                                bottomRight: Radius.circular(36),
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '${_user.contains(' ') ? 'Hi, ' + _user.substring(0, _user.indexOf(' ')) + '!' : 'Hi, ' + _user}!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => Profile(
                                                  username: _user,
                                                  userId: '',
                                                )))
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xffE6E6E6),
                                    radius: 25,
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/profile.jfif',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding),
                              padding: EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding),
                              height: 54,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 10),
                                    blurRadius: 50,
                                    color: kPrimaryColor.withOpacity(0.23),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      onChanged: (value) {},
                                      decoration: InputDecoration(
                                        hintText: "Search users...",
                                        hintStyle: TextStyle(
                                          color: kPrimaryColor.withOpacity(0.5),
                                        ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () => {getSearch()},
                                      child: Icon(Icons.search)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      width: double.infinity,
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: !_loading
                              ? (_userClassrooms != null ||
                                      _userEnrolledClasrooms != null)
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: SubscribedCourses(
                                            context: context,
                                            title: 'Your Classes',
                                            classrooms: _userClassrooms,
                                            enrolled: false,
                                          ),
                                        ),
                                        SizedBox(height: 20.0),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: SubscribedCourses(
                                            context: context,
                                            title: 'Enrolled Classes',
                                            classrooms: _userEnrolledClasrooms,
                                            enrolled: true,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Center(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 165,
                                              child: Center(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Image.asset(
                                                        'assets/plant_grow.gif',
                                                        height: 95,
                                                        fit: BoxFit.cover,
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Welcome, start by creating a classroom/enrolling into one",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[400]),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                              : SpinKitThreeBounce(
                                  color: Colors.teal[400],
                                )),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.teal[400],
                size: 30,
              ),
              backgroundColor: Colors.white,
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
            )),
      );
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

  getSearch() async {
    print('get search');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {'token': prefs.getString('token')};
    print('headers:');
    print(_headers);
    var _body = json
        .encode({'query': _searchController.text.toLowerCase(), 'filter': ''});
    print('body');
    var response = await http.post(unisearch, body: _body, headers: _headers);
    print('Lectures');
    var res = json.decode(response.body.toString());
    print(res);
    if (res['success'] == true) {
      _searchController.text = '';
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UniversalSearchPanel(
                userList: res['data']['results'],
              )));
      prefs.setString('token', res['token'].toString());
    } else {
      print('Response didn\'t fetch');
      print(res);
    }
  }
}
