import 'package:flutter/material.dart';
import '../../Drawer Component/drawer.dart';
import '../../../apis/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ViewAttendance extends StatefulWidget {
  final classId;

  const ViewAttendance({Key key, this.classId}) : super(key: key);

  @override
  _ViewAttendanceState createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _attendanceList = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAttendanceList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        text: 'Attendance Logs', // To be changed
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
        ),
        drawer: AppDrawer(),
        body: Container(
          child: Center(
            child: Text('sjugf'),
          ),
        ));
  }

  void getAttendanceList() async {
    print('getAttendanceList');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {
      'token': prefs.getString('token'),
    };
    print(_headers);
    print(this.widget.classId);
    var _body = json.encode({'classroom_uid': this.widget.classId.toString()});
    var response = await http.post(viewClassroomAttendance,
        body: _body, headers: _headers);
    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      print(res);
      setState(() {
        _attendanceList = res['data'];
      });
      print('attendance list');
      print(_attendanceList);
      prefs.setString('token', res['token'].toString());
    } else {
      print('Response didn\'t fetch');
      print(res);
    }
  }
}
