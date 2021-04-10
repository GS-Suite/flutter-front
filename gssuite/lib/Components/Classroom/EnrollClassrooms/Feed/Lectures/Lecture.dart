import 'package:flutter/material.dart';
import 'package:gssuite/utils/fetch_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../apis/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import '../../../UserClassrooms/Feed/Lectures/VideoPlayer/Video.dart';

class Lecture extends StatefulWidget {
  final classId;

  const Lecture({Key key, this.classId}) : super(key: key);
  @override
  _LectureState createState() => _LectureState();
}

class _LectureState extends State<Lecture> {
  var _fetchList = [];
  var _lectureList;
  var _isLectureEmpty;
  var _isLoading = true;
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLectures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: Container(
              child: !_isLoading
                  ? _isLectureEmpty
                      ? Center(child: Text('No Announcements yet'))
                      : Container(
                          color: Colors.white,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: _fetchList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => Video(
                                                    url: _fetchList[index]
                                                        ['url'],
                                                  )))
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey[200]),
                                          color: Colors.blueGrey[50],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blueGrey[50],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(11.0))),
                                            child: Image.network(
                                              _fetchList[index]['image'],
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Flexible(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  _fetchList[index]
                                                      ['lecture_name'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  _fetchList[index]
                                                      ['lecture_description'],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Image.network(
                                                      _fetchList[index]
                                                          ['favIcon'],
                                                      height: 12,
                                                      width: 12,
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                        _fetchList[index]['url']
                                                                .toString()
                                                                .substring(
                                                                    0, 20) +
                                                            '...',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12))
                                                  ],
                                                )
                                              ],
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  )
                                ],
                              );
                            },
                          ),
                        )
                  : Center(
                      child: SpinKitThreeBounce(
                        color: Colors.teal[400],
                      ),
                    )),
        ),
      ),
    );
  }

  void getLectures() async {
    print('get lectures');
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
        await http.post(getClassroomLectures, body: _body, headers: _headers);
    print('Lectures');
    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      setState(() {
        _isLectureEmpty = false;
        _isLoading = false;
        _lectureList = res['data'];
      });
      _lectureList.forEach((e) async {
        var temp = {
          'url': e['lecture_link'],
          'lecture_description': e['lecture_description'],
          'lecture_name': e['lecture_name']
        };
        await FetchPreview().fetch(e['lecture_link']).then((res) {
          temp['title'] = res['title'];
          temp['image'] = res['image'];
          temp['description'] = res['description'];
          temp['favIcon'] = res['favIcon'];
        });
        setState(() {
          _fetchList.add(temp);
        });

        // print(_fetchList);
      });
      prefs.setString('token', res['token'].toString());
    } else {
      if (res['message'] == 'Lecture could not be retrieved.') {
        setState(() {
          _isLectureEmpty = true;
          _isLoading = false;
        });
      } else {
        print('Response didn\'t fetch');
        print(res);
      }
    }
  }
}
