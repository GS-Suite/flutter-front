import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gssuite/apis/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gssuite/apis/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class Announcement extends StatefulWidget {
  final classId;

  const Announcement({Key key, this.classId}) : super(key: key);
  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  Timer timer;
  var _announcementList;
  var _isAnnEmpty;
  var _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAnnouncements();
    // timer =
    //     Timer.periodic(Duration(seconds: 2), (Timer t) => {getAnnouncements()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Container(
            child: !_isLoading
                ? _isAnnEmpty
                    ? Center(child: Text('No Announcements yet'))
                    : Container(
                        color: Colors.white,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: _announcementList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 180,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          _announcementList[index]['creator'],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Container(
                                        width: 370,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                    _announcementList[index]
                                                        ['announcement']),
                                              ),
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.copy,
                                                    size: 20,
                                                    color: Colors.lightBlue,
                                                  ),
                                                  onPressed: () => {
                                                        Clipboard.setData(ClipboardData(
                                                            text: _announcementList[
                                                                    index][
                                                                'announcement']))
                                                      })
                                            ],
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey[50],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          _announcementList[index]['datetime']
                                              .toString()
                                              .substring(11, 16),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 15),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ))
                : Center(
                    child: SpinKitThreeBounce(
                      color: Colors.teal[400],
                    ),
                  )),
      ),
    );
  }

  void getAnnouncements() async {
    print('get Announcements');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {'token': prefs.getString('token')};
    print('headers:');
    print(_headers);
    print(this.widget.classId);
    var _body = json.encode({
      'classroom_uid': this.widget.classId.toString(),
    });
    print('body');
    print(_body);
    var response =
        await http.post(fetchAnnouncements, body: _body, headers: _headers);
    print('Announcements');
    print(response.body.toString());
    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      setState(() {
        _isAnnEmpty = false;
        _isLoading = false;
        _announcementList = res['data']['forum_stuff']['posts'];
      });
      prefs.setString('token', res['token'].toString());
    } else {
      if (res['message'] == 'There are no announcements') {
        setState(() {
          _isAnnEmpty = true;
          _isLoading = false;
        });
      } else {
        print('Response didn\'t fetch');
        print(res);
      }
    }
  }
}
