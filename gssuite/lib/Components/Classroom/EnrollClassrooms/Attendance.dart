import 'package:flutter/material.dart';
import 'package:gssuite/apis/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Attendance extends StatefulWidget {
  final classId;

  const Attendance({Key key, this.classId}) : super(key: key);
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  TextEditingController attendanceCodeController;
  bool _isCodeValid = true;
  bool shouldButtonEnabled = true;
  bool _markedAttendance = false;

  @override
  void initState() {
    super.initState();
    attendanceCodeController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    attendanceCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: EdgeInsets.only(top: 35, left: 20, right: 20),
      child: _markedAttendance
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Center(
                        child: Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.grey[400],
                      size: 70,
                    )),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Text('You\'ve marked your attendance'),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  height: 60,
                  child: Center(
                    child: TextField(
                      onChanged: (value) => {
                        if (value.length > 2)
                          {
                            if (value.length != 9)
                              {
                                setState(() => {_isCodeValid = false})
                              }
                            else
                              {
                                setState(() => {_isCodeValid = true})
                              }
                          }
                        else
                          {
                            setState(() => {_isCodeValid = true})
                          },
                      },
                      style: TextStyle(fontSize: 25),
                      decoration: InputDecoration(
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          errorText:
                              _isCodeValid ? null : "Invalid attendance token"),
                      controller: attendanceCodeController,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      onPressed:
                          _isCodeValid ? () => {markAttendance()} : () => {},
                      child: Text('Mark Attendance',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Montseratt',
                              color: Colors.teal[400]))),
                ),
              ],
            ),
    );
  }

  _disabledButton() {
    shouldButtonEnabled = false;
    Timer(Duration(seconds: 30), () => shouldButtonEnabled = true);
  }

  markAttendance() async {
    print('stop attendance');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(attendanceCodeController.text);
    Map<String, String> _headers = {'token': prefs.getString('token')};
    print('headers:');
    print(_headers);
    print(this.widget.classId);
    var _body = json.encode({
      'classroom_uid': this.widget.classId.toString(),
      'attendance_token': attendanceCodeController.text
    });
    var response =
        await http.post(giveAttendance, body: _body, headers: _headers);
    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      print(res);
      setState(() {
        _markedAttendance = true;
      });
      Fluttertoast.showToast(
          msg: 'Attendance marked successfully',
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
