import 'package:flutter/material.dart';
import 'package:gssuite/apis/api.dart';
import '../Drawer Component/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  final userId;
  final username;

  const Profile({Key key, this.userId, this.username}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getProfile();
  }

  var _isLoading = true;
  var _userProfile;
  var _userClassrooms;
  var _userEnrolled;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: !_isLoading
              ? Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.teal, Colors.white])),
                          child: Container(
                            width: double.infinity,
                            height: 320.0,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/profile.jfif',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    radius: 50.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 5.0),
                                    clipBehavior: Clip.antiAlias,
                                    color: Colors.white,
                                    elevation: 5.0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 22.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0,
                                                horizontal: 20.0),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "${_userProfile['first_name']} ${_userProfile['last_name']}",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 25.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Text(
                                                      "@${_userProfile["username"]}",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        final url =
                                                            'mailto:${_userProfile['email']}';
                                                        try {
                                                          await launch(url);
                                                        } catch (e) {}
                                                      },
                                                      child: Text(
                                                        "${_userProfile["email"]}",
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: Colors
                                                                .grey[600]),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                    ),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, right: 16.0, left: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TabBar(
                              labelColor: Colors.teal[400],
                              tabs: [
                                Tab(
                                  child: Text(
                                    'Owned (${_userClassrooms.length})',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'Enrolled (${_userEnrolled.length})',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                              controller: _tabController,
                              indicatorSize: TabBarIndicatorSize.tab,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(controller: _tabController, children: [
                        // first tab bar view widget
                        Container(
                            color: Colors.white,
                            child: _userClassrooms != null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: _userClassrooms.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 3),
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10.0),
                                                      width: 250,
                                                      child: Card(
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8.0,
                                                                      left: 0,
                                                                      bottom:
                                                                          8.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Flexible(
                                                                          child:
                                                                              Text(
                                                                            _userClassrooms[index]['name'].toString().length > 20
                                                                                ? _userClassrooms[index]['name'].toString().substring(0, 17) + ' ..'
                                                                                : _userClassrooms[index]['name'].toString(),
                                                                            style:
                                                                                TextStyle(fontSize: 15, color: Colors.grey[600]),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )));
                                            })))
                                :
                                // second tab bar viiew widget
                                Container(
                                    child: Center(
                                      child: SpinKitThreeBounce(),
                                    ),
                                  )),
                        Container(
                            color: Colors.white,
                            child: _userClassrooms != null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: _userEnrolled.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 3),
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10.0),
                                                    width: 250,
                                                    child: Card(
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 8.0,
                                                              left: 0,
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        _userEnrolled[index]
                                                                            [
                                                                            'name'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.grey[600]),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ));
                                            })))
                                :
                                // second tab bar viiew widget
                                Container(
                                    child: Center(
                                      child: SpinKitThreeBounce(),
                                    ),
                                  )),
                      ]),
                    ),
                  ],
                )
              : Center(
                  child: SpinKitThreeBounce(
                    color: Colors.teal[400],
                  ),
                )),
    );
  }

  void getProfile() async {
    print('get profile');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {'token': prefs.getString('token')};
    var _body = json.encode(
        {"username": this.widget.username, "user_id": this.widget.userId});
    var response = await http.post(profile, body: _body, headers: _headers);
    print(response.body.toString());
    var res = json.decode(response.body.toString());
    print(res);
    if (res['success'] == true) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _userProfile = res['data']['user_profile'];
          _userClassrooms = res['data']['user_created_classrooms'];
          _userEnrolled = res['data']['user_enrolled_classrooms'];
        });
      }

      prefs.setString('token', res['token'].toString());
    } else {
      print('Response didn\'t fetch');
      print(res);
    }
  }

  void mailto({String email}) async {
    if (await canLaunch(email)) {
      await launch(email);
    } else {
      throw 'Could not launch';
    }
  }
}
