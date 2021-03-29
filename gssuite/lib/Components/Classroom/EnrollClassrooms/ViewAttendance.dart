import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../apis/api.dart';
import 'package:http/http.dart' as http;

class ViewAttendance extends StatefulWidget {
  final classId;

  const ViewAttendance({Key key, this.classId}) : super(key: key);
  @override
  _ViewAttendanceState createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
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
    return Container(
      child: Text(this.widget.classId),
    );
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
    var response = await http.post(viewClassroomAttendance,
        body: _body, headers: _headers);
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
