import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../apis/api.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GiveAttendance extends StatefulWidget {
  final classId;

  const GiveAttendance({Key key, this.classId}) : super(key: key);
  @override
  _GiveAttendanceState createState() => _GiveAttendanceState();
}

class _GiveAttendanceState extends State<GiveAttendance> {
  bool _markedAttendance = false;
  TextEditingController tokenController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenController = TextEditingController();
  }

  markAttendance() async {
    print('stop attendance');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(tokenController.text);
    Map<String, String> _headers = {'token': prefs.getString('token')};
    print('headers:');
    print(_headers);
    print(this.widget.classId);
    var _body = json.encode({
      'classroom_uid': this.widget.classId.toString(),
      'attendance_token': tokenController.text
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 400,
            padding: EdgeInsets.only(top: 35, left: 20, right: 20),
            child: !_markedAttendance
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 60,
                        child: TextField(
                          style: TextStyle(fontSize: 25),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          controller: tokenController,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 40,
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.teal[400],
                          elevation: 7.0,
                          child: InkWell(
                            onTap: () => {
                              markAttendance()
                              // createClass(classNameController.text),
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => ClassroomPanel(
                              //           classId: '1',
                              //           className: classNameController.text,
                              //         )))
                            },
                            child: Center(
                              child: Text(
                                'Mark Attendance',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : Center(
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
                  ),
          ),
        ],
      ),
    );
  }
}
