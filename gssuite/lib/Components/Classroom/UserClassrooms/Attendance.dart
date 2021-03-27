import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../apis/api.dart';

class Attendance extends StatefulWidget {
  final classId;

  Attendance({this.classId});

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  var _attendanceToken;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _attendanceToken != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_attendanceToken,
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Montseratt',
                                color: Colors.teal[400])),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.copy,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () => {
                                  Clipboard.setData(
                                      new ClipboardData(text: _attendanceToken))
                                })
                      ],
                    ),
                    RaisedButton(
                        onPressed: () => {
                              setState(() => {_attendanceToken = null})
                            },
                        child: Text('Stop Attendance',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Montseratt',
                                color: Colors.teal[400])))
                  ],
                ),
              )
            : Center(
                child: RaisedButton(
                    onPressed: () => {generateAttendanceToken()},
                    child: Text('Take Attendance',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Montseratt',
                            color: Colors.teal[400])))));
  }

  generateAttendanceToken() async {
    {
      print('take attendance');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var timeout = 30;
      Map<String, String> _headers = {'token': prefs.getString('token')};
      print('headers:');
      print(_headers);
      print(this.widget.classId);
      var _body =
          json.encode({'classroom_uid': this.widget.classId.toString()});
      var response =
          await http.post(takeAttendance, body: _body, headers: _headers);
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
}
