import 'package:flutter/material.dart';
import 'package:gssuite/Components/Classroom/Info.dart';
import 'package:gssuite/Components/Classroom/UserClassrooms/Resource/resource.dart';
import '../../Drawer Component/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../apis/api.dart';
import 'Feed/Feed.dart';
import 'Attendance/Attendance.dart';
import 'Forums/Forums.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'StudentsEnrolled.dart';

class ClassroomPanel extends StatefulWidget {
  final firstIndex, secondIndex;
  String _className;
  final String classId;
  final String forumId;
  ClassroomPanel(
      {this.classId, this.forumId, this.firstIndex, this.secondIndex});

  @override
  _ClassroomPanelState createState() => _ClassroomPanelState();
}

class _ClassroomPanelState extends State<ClassroomPanel> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getClassroomDetails();
  }

  Widget build(BuildContext context) {
    print(this.widget.forumId);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: this.widget._className == null
          ? Container(
              color: Colors.white,
              child: Center(
                  child: SpinKitThreeBounce(
                color: Colors.teal[400],
              )),
            )
          : DefaultTabController(
              length: 3,
              initialIndex: this.widget.firstIndex ?? 0,
              child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  actions: [
                    PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.black,
                      ),
                      itemBuilder: (BuildContext bc) => [
                        PopupMenuItem(
                            child: Text("View Students"), value: "students"),
                        PopupMenuItem(
                            child: Text("Manage Resources"),
                            value: "resources"),
                        PopupMenuItem(child: Text("Info"), value: "info"),
                      ],
                      onSelected: (route) async {
                        if (route == "resources") {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Resource(
                                    owner: true,
                                    classId: this.widget.classId,
                                  )));
                        }
                        if (route == "students") {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StudentEnrolled(
                                    classId: this.widget.classId,
                                    owner: true,
                                  )));
                        }
                        if (route == "info") {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Info(
                                    classId: this.widget.classId,
                                    className: this.widget._className,
                                    owner: true,
                                  )));
                        }
                      },
                    ),
                  ],
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 15, top: 15),
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
                                text: this.widget._className.length > 15
                                    ? this.widget._className.substring(0, 11) +
                                        ' ...'
                                    : this.widget._className ??
                                        'Loading ...', // To be changed
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  bottom: PreferredSize(
                      preferredSize: Size.fromHeight(55),
                      child: Align(
                        child: Container(
                          color: Colors.white,
                          height: 43,
                          child: TabBar(
                              unselectedLabelColor: Colors.teal[400],
                              indicatorSize: TabBarIndicatorSize.label,
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.teal[400]),
                              tabs: [
                                Tab(
                                  child: Container(
                                    height: 42,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Colors.teal[400], width: 2)),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Feed",
                                        style:
                                            TextStyle(fontFamily: 'Montseratt'),
                                      ),
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    height: 42,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Colors.teal[400], width: 2)),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Attendance",
                                        style:
                                            TextStyle(fontFamily: 'Montseratt'),
                                      ),
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    height: 42,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Colors.teal[400], width: 2)),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Forums",
                                        style:
                                            TextStyle(fontFamily: 'Montseratt'),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      )),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TabBarView(
                    children: [
                      Feed(
                        firstIndex: this.widget.secondIndex,
                        classId: this.widget.classId,
                      ),
                      Attendance(
                        classId: this.widget.classId,
                      ),
                      Forums(
                        classId: this.widget.classId,
                      ),
                    ],
                  ),
                ),
                drawer: AppDrawer(),
              ),
            ),
    );
  }

  void getClassroomDetails() async {
    print('getClassroomDetails');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {
      'token': prefs.getString('token'),
    };
    print(_headers);
    print(this.widget.classId);
    var _body = json.encode({'classroom_uid': this.widget.classId.toString()});
    var response =
        await http.post(getClassroomDetail, body: _body, headers: _headers);
    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      print(res);
      if (mounted) {
        setState(() {
          this.widget._className = res['data']['name'];
        });
      }
      prefs.setString('token', res['token'].toString());
    } else {
      print('Response didn\'t fetch');
      print(res);
    }
  }

  Future<bool> _onBackPressed() {
    Navigator.pushNamed(context, '/dashboard');
  }
}
