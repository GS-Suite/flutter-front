import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../apis/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../Drawer Component/drawer.dart';

class ViewAttendance extends StatefulWidget {
  final classId;

  const ViewAttendance({Key key, this.classId}) : super(key: key);
  @override
  _ViewAttendanceState createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _keyList = null;
  var _valList = [];
  var _attendedCount;
  var _totalCount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewAttendanceByStudent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        body: _keyList != null
            ? Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _keyList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Container(
                            margin: EdgeInsets.only(right: 10.0),
                            width: 250,
                            child: ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: 0, vertical: -4),
                              contentPadding: EdgeInsets.all(0),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 0, bottom: 8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  _keyList[index]
                                                          .toString()
                                                          .substring(11, 19) +
                                                      ' Hrs',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  _keyList[index]
                                                      .toString()
                                                      .substring(0, 10),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[600]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          _valList[index]
                                              ? 'Attended'
                                              : 'Not Attended',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.black26)))),
                      );
                    }),
              )
            : Center(
                child: SpinKitThreeBounce(
                color: Colors.teal[400],
              )));
  }

  void viewAttendanceByStudent() async {
    print('viewAtendanceByStudent');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {
      'token': prefs.getString('token'),
    };
    print(_headers);
    print(this.widget.classId);
    var _body = json.encode({'classroom_uid': this.widget.classId.toString()});
    var response =
        await http.post(studentViewAttendance, body: _body, headers: _headers);
    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      print(res);
      var keys = res['data']['details'].keys.toList();
      setState(() {
        _keyList = keys;
        keys.forEach((date) => {
              _valList.add(res['data']['details'][date.toString()]),
            });
        _attendedCount = res['data']['attended_count'];
        _totalCount = res['data']['total_count'];
      });
      print('key list');
      print(_keyList);
      print('val_list');
      print(_valList);
      print(_attendedCount);
      print(_totalCount);
      prefs.setString('token', res['token'].toString());
    } else {
      print('Response didn\'t fetch');
      print(res);
    }
  }
}
