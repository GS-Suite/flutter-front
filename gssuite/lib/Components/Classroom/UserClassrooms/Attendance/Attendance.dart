import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../apis/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import './ViewAttendance.dart';
import './takeAttendance.dart';

class Attendance extends StatefulWidget {
  final classId;
  final initialTab;

  Attendance({this.classId, this.initialTab});

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> with TickerProviderStateMixin {
  var _attendanceToken;
  bool shouldButtonEnabled = true;
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Container(
          color: Colors.white,
          child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.teal[400],
              labelColor: Colors.teal[400],
              unselectedLabelColor: Colors.black54,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.list),
                  child: Text('Take Attendance'),
                ),
                Tab(
                  icon: Icon(Icons.playlist_play_outlined),
                  child: Text('Attendance Logs'),
                ),
              ]),
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          TakeAttendance(
            classId: this.widget.classId,
          ),
          ViewAttendance(
            classId: this.widget.classId,
          )
        ],
        controller: _tabController,
      ),
    );
  }

  _disabledButton() {
    shouldButtonEnabled = false;
    Timer(Duration(seconds: 30), () => shouldButtonEnabled = true);
  }

  generateAttendanceToken() async {
    {
      print('take attendance');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, String> _headers = {'token': prefs.getString('token')};
      print('headers:');
      print(_headers);
      print(this.widget.classId);
      var _body = json.encode({
        'classroom_uid': this.widget.classId.toString(),
        'timeout_minutes': 30,
      });
      var response =
          await http.post(takeAttendance, body: _body, headers: _headers);

      print(response.body.toString());
      var res = json.decode(response.body.toString());
      if (res['success'] == true) {
        print(res);
        setState(() {
          this._attendanceToken = res['data']['attendance_token'];
        });
        prefs.setString('token', res['token'].toString());
      } else {
        print('Response didn\'t fetch');
        print(res);
      }
    }
  }

  stopTakingAttendance() async {
    print('stop attendance');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(_attendanceToken);
    Map<String, String> _headers = {'token': prefs.getString('token')};
    print('headers:');
    print(_headers);
    print(this.widget.classId);
    var _body = json.encode({
      'classroom_uid': this.widget.classId.toString(),
      'attendance_token': _attendanceToken
    });
    var response =
        await http.post(stopAttendance, body: _body, headers: _headers);
    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      print(res);
      setState(() {
        this._attendanceToken = null;
      });
      Fluttertoast.showToast(
          msg: res['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black38,
          fontSize: 16.0);
      prefs.setString('token', res['token'].toString());
    } else {
      print('Response didn\'t fetch');
      print(res);
      Fluttertoast.showToast(
          msg: 'Error',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black38,
          fontSize: 16.0);
    }
  }
}
