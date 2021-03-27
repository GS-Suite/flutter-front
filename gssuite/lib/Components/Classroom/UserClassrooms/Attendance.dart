import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../apis/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

class Attendance extends StatefulWidget {
  final classId;

  Attendance({this.classId});

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  var _attendanceToken;
  bool shouldButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _attendanceToken != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(_attendanceToken,
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Montseratt',
                              color: Colors.teal[400])),
                      IconButton(
                          icon: Icon(
                            Icons.copy,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () => {
                                Clipboard.setData(
                                    new ClipboardData(text: _attendanceToken))
                              })
                    ]),
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        onPressed: () => {stopTakingAttendance()},
                        child: Text('Stop Attendance',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Montseratt',
                                color: Colors.red[300])))
                  ],
                ),
              )
            : Center(
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    onPressed: () => {
                          generateAttendanceToken(),
                        },
                    child: Text('Take Attendance',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Montseratt',
                            color: Colors.teal[400])))));
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
