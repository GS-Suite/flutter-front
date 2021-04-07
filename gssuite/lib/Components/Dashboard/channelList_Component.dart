import 'package:flutter/material.dart';
import '../Classroom/UserClassrooms/ClassroomPanel.dart';
import '../Classroom/EnrollClassrooms/ClassroomPanelEnrolled.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../apis/api.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import '../Classroom/UserClassrooms/StudentsEnrolled.dart';

class ChannelList extends StatelessWidget {
  final List classrooms;
  final Function onRefresh;
  final bool enrolled;

  ChannelList({Key key, this.classrooms, this.onRefresh, this.enrolled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.classrooms.length == 0
        ? Container(
            height: 165,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.teal[100],
                  size: 40,
                ),
                Text(
                  "You haven't created any classrooms",
                  style: TextStyle(color: Colors.grey[400]),
                )
              ],
            )),
          )
        : Container(
            height: 200,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: classrooms.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      margin: EdgeInsets.only(right: 10.0),
                      width: 250,
                      child: InkWell(
                        onTap: enrolled
                            ? () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ClassroomPanelEnrolled(
                                          classId: this.classrooms[index]
                                              ['uid'],
                                        )));
                              }
                            : () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ClassroomPanel(
                                          classId: this.classrooms[index]
                                              ['uid'],
                                        )));
                              },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[300],
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight: Radius.circular(7)),
                                ),
                                color: Color(
                                        (math.Random().nextDouble() * 0xFFFFFF)
                                            .toInt())
                                    .withOpacity(0.60),
                                child: Container(
                                  height: 130,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                      this.classrooms[index]['name'].toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 36.0),
                                    )),
                                  ),
                                ),
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              Icon(Icons.person_pin_outlined),
                                        ),
                                        Text(
                                          enrolled
                                              ? this
                                                  .classrooms[index]['teacher']
                                                      ['username']
                                                  .toString()
                                              : 'You',
                                          style: TextStyle(
                                              fontFamily: 'Montseratt',
                                              fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                    PopupMenuButton(
                                      itemBuilder: (BuildContext bc) => [
                                        PopupMenuItem(
                                            child: Text("View Students"),
                                            value: "students"),
                                        !this.enrolled
                                            ? PopupMenuItem(
                                                child: Text("Invite Code"),
                                                value: "invite_code")
                                            : PopupMenuItem(
                                                child: Text("Unenroll"),
                                                value: "unenroll"),
                                      ],
                                      onSelected: (route) async {
                                        if (route == "invite_code") {
                                          var joincCode =
                                              await generate_join_code(
                                                  classroom_uid:
                                                      this.classrooms[index]
                                                          ['uid']);
                                          print(joincCode);
                                        }
                                        if (route == 'unenroll') {
                                          var unenroll = _unenroll(
                                              context: context,
                                              classId: this.classrooms[index]
                                                  ['uid']);
                                        }
                                        if (route == "students") {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StudentEnrolled(
                                                        classId:
                                                            this.classrooms[
                                                                index]['uid'],
                                                      )));
                                        }
                                      },
                                    ),
                                  ])
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
  }

  Future<String> generate_join_code({String classroom_uid}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {
      'token': prefs.getString('token'),
    };
    var _body = json.encode({'classroom_uid': classroom_uid});
    var response =
        await http.post(generateJoinCode, body: _body, headers: _headers);
    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      var joinCode = res['data']['entry_code'].toString();
      Fluttertoast.showToast(
          msg: "Copied to clipboard!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black38,
          fontSize: 16.0);
      Clipboard.setData(new ClipboardData(text: joinCode));
      return joinCode;
    } else {
      print('error');
    }
  }

  _unenroll({String classId, BuildContext context}) async {
    print('unenroll');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {
      'token': prefs.getString('token'),
    };
    print(_headers);
    print(classId);
    var _body = json.encode({'classroom_uid': classId});
    var response = await http.post(unenroll, body: _body, headers: _headers);
    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      Fluttertoast.showToast(
          msg: res['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black38,
          fontSize: 16.0);

      prefs.setString('token', res['token'].toString());
      print('unenrolled');
      Navigator.pushNamed(context, '/dashboard');
    } else {
      Fluttertoast.showToast(
          msg: res['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black38,
          fontSize: 16.0);
      print('Response didn\'t fetch');
      print(res);
    }
  }
}
