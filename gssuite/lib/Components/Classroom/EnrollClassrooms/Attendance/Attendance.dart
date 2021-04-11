import 'package:flutter/material.dart';
import 'package:gssuite/Components/Classroom/EnrollClassrooms/Attendance/GiveAttendance.dart';
import 'package:gssuite/apis/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import './ViewAttendance.dart';

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
                  child: Text('Mark Attendance'),
                ),
                Tab(
                  icon: Icon(Icons.playlist_play_outlined),
                  child: Text('View Attendance'),
                ),
              ]),
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          GiveAttendance(
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

  //
}
