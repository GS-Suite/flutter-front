import 'package:flutter/material.dart';
import 'package:gssuite/Components/Profile/profile.dart';
import 'package:gssuite/apis/api.dart';
import '../../Drawer Component/drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../apis/api.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudentEnrolled extends StatefulWidget {
  final classId;
  final owner;

  const StudentEnrolled({Key key, this.classId, this.owner}) : super(key: key);
  @override
  _StudentEnrolledState createState() => _StudentEnrolledState();
}

class _StudentEnrolledState extends State<StudentEnrolled> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _studentList = null;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudentList();
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
                      text: 'Students', // To be changed
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
        child: !_isLoading
            ? _studentList != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: _studentList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Container(
                                margin: EdgeInsets.only(right: 10.0),
                                width: 250,
                                child: GestureDetector(
                                  onTap: () => {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => Profile(
                                                  userId: _studentList[index]
                                                      ['uid'],
                                                  username: _studentList[index]
                                                      ['username'],
                                                )))
                                  },
                                  child: Card(
                                    child: Column(
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
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(
                                                      Icons
                                                          .account_circle_sharp,
                                                      size: 35,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      _studentList[index]
                                                          ['username'],
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montseratt',
                                                          fontSize: 25,
                                                          color:
                                                              Colors.grey[600]),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  this.widget.owner
                                                      ? IconButton(
                                                          icon: Icon(Icons
                                                              .remove_circle_outline_sharp),
                                                          onPressed: () {
                                                            _unenroll(
                                                                classId: this
                                                                    .widget
                                                                    .classId,
                                                                username: _studentList[
                                                                        index][
                                                                    'username'],
                                                                uid: _studentList[
                                                                        index]
                                                                    ['uid']);
                                                          })
                                                      : Container()
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                : Container(
                    child: Center(
                      child: Text('No one enrolled yet'),
                    ),
                  )
            : Center(
                child: SpinKitThreeBounce(
                color: Colors.teal[400],
              )),
      ),
    );
  }

  void getStudentList() async {
    print('get student List');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {
      'token': prefs.getString('token'),
    };
    print(_headers);
    print(this.widget.classId);
    var _body = json.encode({'classroom_uid': this.widget.classId.toString()});
    var response =
        await http.post(getEnrolledStudents, body: _body, headers: _headers);
    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      setState(() {
        _studentList = res['data']['enrolled'];
        _isLoading = false;
      });
      prefs.setString('token', res['token'].toString());
    } else {
      print('Response didn\'t fetch');
      setState(() {
        _isLoading = false;
      });
      print(res);
    }
    print(_studentList);
  }

  void _unenroll({String classId, String uid, String username}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {
      'token': prefs.getString('token'),
    };

    //For create class
    var _body = json.encode({'classroom_uid': classId, 'user_id': uid});
    print(jsonDecode(_body));
    var response =
        await http.post(unenroll_user, body: _body, headers: _headers);
    print(response);
    var res = json.decode(response.body.toString());
    print(res);
    if (res['success'] == true) {
      setState(() {
        getStudentList();
      });
      Fluttertoast.showToast(
          msg: '$username removed successfully',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black38,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: 'Error removing $username',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black38,
          fontSize: 16.0);
    }
  }
}
