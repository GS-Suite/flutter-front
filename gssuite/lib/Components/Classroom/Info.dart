import 'package:flutter/material.dart';
import 'package:gssuite/Components/Classroom/UserClassrooms/StudentsEnrolled.dart';
import 'package:gssuite/apis/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Info extends StatefulWidget {
  final owner;
  final className;
  final classId;

  const Info({Key key, this.classId, this.className, this.owner})
      : super(key: key);
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  var _publicLink = '';
  var _entryCode = '';
  var _ownerName = '';
  var _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOwnerNameF(this.widget.classId);
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
                      text: 'Meta Data!', // To be changed
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),
          ),
        ),
      ),
      body: !_isLoading
          ? Container(
              alignment: Alignment.topLeft,
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey[400], width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      this.widget.className.toString().length >
                                              15
                                          ? this
                                                  .widget
                                                  .className
                                                  .toString()
                                                  .substring(0, 15) +
                                              ' ...'
                                          : this.widget.className.toString(),
                                      style: TextStyle(
                                        fontSize: 28,
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () => {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StudentEnrolled(
                                                        classId:
                                                            this.widget.classId,
                                                        owner:
                                                            this.widget.owner)))
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'Students',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.blueAccent),
                                          ),
                                          Icon(
                                            Icons.chevron_right_outlined,
                                            size: 16,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey[50],
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Created by :- ',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Text(
                                            _ownerName.toString(),
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Invite Code :- ',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Text(
                                            _entryCode != null
                                                ? _entryCode.toString()
                                                : 'Not yet generated',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Spacer(),
                                          _entryCode != ''
                                              ? IconButton(
                                                  icon: Icon(
                                                    Icons.copy,
                                                    size: 18,
                                                    color: Colors.blueAccent,
                                                  ),
                                                  onPressed: () => {
                                                        Clipboard.setData(
                                                            new ClipboardData(
                                                                text: _entryCode
                                                                    .toString())),
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Copied to clipboard!",
                                                            toastLength: Toast
                                                                .LENGTH_LONG,
                                                            gravity:
                                                                ToastGravity
                                                                    .SNACKBAR,
                                                            backgroundColor:
                                                                Colors
                                                                    .grey[200],
                                                            textColor:
                                                                Colors.black38,
                                                            fontSize: 16.0),
                                                      })
                                              : SizedBox()
                                        ],
                                      ),
                                      this.widget.owner
                                          ? _publicLink.toString() == null
                                              ? Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        'Resource Storage Link :- ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await canLaunch(
                                                                _publicLink
                                                                    .toString())
                                                            ? await launch(
                                                                _publicLink
                                                                    .toString())
                                                            : throw 'Could not launch';
                                                      },
                                                      child: Text(
                                                        _publicLink.toString(),
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : SizedBox()
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      this.widget.owner == true
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () => {
                                    generate_join_code(
                                        classroom_uid: this.widget.classId)
                                  },
                                  child: Container(
                                    height: 40.0,
                                    color: Colors.transparent,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black,
                                              style: BorderStyle.solid,
                                              width: 1.0),
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                              child:
                                                  Icon(Icons.refresh_outlined)),
                                          SizedBox(width: 10.0),
                                          Center(
                                            child: Text(
                                                _entryCode != null
                                                    ? 'Refresh Invite Code'
                                                    : 'Generate Invite Code',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Montserrat')),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                this.widget.owner == true
                                    ? Container(
                                        height: 40.0,
                                        color: Colors.transparent,
                                        child: GestureDetector(
                                          onTap: () async {},
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.red[200],
                                                    style: BorderStyle.solid,
                                                    width: 1.0),
                                                color: Colors.red[50],
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Center(
                                                    child: Icon(Icons
                                                        .remove_circle_outline)),
                                                SizedBox(width: 10.0),
                                                Center(
                                                  child: Text(
                                                      'Delete Classroom',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'Montserrat')),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              child: Center(
                child: SpinKitThreeBounce(
                  color: Colors.teal[400],
                ),
              ),
            ),
    );
  }

  void generate_join_code({String classroom_uid}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {
      'token': prefs.getString('token'),
    };
    var _body = json.encode({'classroom_uid': classroom_uid});
    print(json.decode(_body));
    var response =
        await http.post(generateJoinCode, body: _body, headers: _headers);
    print(response.body.toString());
    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      print(res);
      setState(() {
        if (mounted) {
          _entryCode = res['data']['entry_code'];
        }
      });
    } else {
      print('error');
    }
  }

  void getOwnerNameF(classId) async {
    print('get owner uid');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {'token': prefs.getString('token')};
    var _body = json.encode({
      'classroom_uid': this.widget.classId.toString(),
    });
    var response =
        await http.post(getClassroomDetail, body: _body, headers: _headers);
    var res = jsonDecode(response.body.toString());
    print(res);
    if (res['success'] == true) {
      if (mounted) {
        setState(() {
          _ownerName = res['data']['classroom_name'];
          _entryCode = res['data']['entry_code'];
          _publicLink = res['data']['public_storage_link'];
        });
      }
      print('get id');
      var _bodyId = json.encode({
        'classroom_uid': this.widget.classId.toString(),
      });
      var respId =
          await http.post(getOwnerId, body: _bodyId, headers: _headers);
      var resId = jsonDecode(respId.body.toString());
      if (resId['success'] == true) {
        print('get name');
        print(resId['data']['classroom_owner_id']);
        var _bodyOwner = json.encode({
          'user_uid': resId['data']['classroom_owner_id'],
        });
        print(_bodyOwner);
        var respOwner =
            await http.post(getUserName, body: _bodyOwner, headers: _headers);
        var resOwner = jsonDecode(respOwner.body.toString());

        if (resOwner['success'] == true) {
          print(resOwner);
          if (mounted) {
            setState(() {
              _isLoading = false;
              _ownerName = resOwner['data']['username'];
            });
          }
        }
      }
      prefs.setString('token', res['token'].toString());
    } else {
      if (res['message'] == 'There are no lectures to retrieve') {
        if (mounted) {
          {
            setState(() {
              _isLoading = false;
            });
          }
        }
        print('Response didn\'t fetch');
        print(res);
      }
    }
  }
}
