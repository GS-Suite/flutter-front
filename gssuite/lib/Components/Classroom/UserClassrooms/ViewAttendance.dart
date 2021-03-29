import 'package:flutter/material.dart';
import '../../Drawer Component/drawer.dart';
import '../../../apis/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  var _val_list = [];
  var _attendanceToken = '';

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
        child: _attendanceList != null
            ? Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _attendanceList.length,
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
                              title: Column(
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            _attendanceList[index]
                                                    .toString()
                                                    .substring(11, 19) +
                                                ' Hrs',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            _attendanceList[index]
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
                              trailing: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                    onTap: () => {},
                                    child: Icon(Icons.chevron_right_sharp)),
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
              )),
      ),
    );
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
      var keys = res['data'].keys.toList();
      setState(() {
        _attendanceList = keys;
        keys.forEach((date) => {
              _val_list.add(res['data'][date.toString()]),
            });
        _attendanceToken = res['data']['token'];
      });
      print('attendance list');
      print(_attendanceList);
      print('val_list');
      print(_val_list);
      prefs.setString('token', res['token'].toString());
    } else {
      print('Response didn\'t fetch');
      print(res);
    }
  }
}
