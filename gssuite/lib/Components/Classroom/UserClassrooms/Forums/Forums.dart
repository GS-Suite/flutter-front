import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../apis/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Forums extends StatefulWidget {
  final classId;

  const Forums({Key key, this.classId}) : super(key: key);
  @override
  _ForumsState createState() => _ForumsState();
}

class _ForumsState extends State<Forums> {
  var _chatList;
  var _classroom_owner_uid;
  var _classroom_owner_username;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getForumChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: _chatList != null
                ? Container(
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: _chatList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                            width: 25,
                            padding:
                                EdgeInsets.only(left: 14, right: 14, top: 10),
                            child: Align(
                              alignment: (_chatList[index]['username'] !=
                                      _classroom_owner_username
                                  ? Alignment.topLeft
                                  : Alignment.topRight),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: _chatList[index]['username'] ==
                                          _classroom_owner_username
                                      ? BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15))
                                      : BorderRadius.only(
                                          bottomRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                  color: (_chatList[index]['username'] !=
                                          _classroom_owner_username
                                      ? Colors.grey.shade200
                                      : Colors.blue[200]),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        mainAxisAlignment: _chatList[index]
                                                    ['username'] ==
                                                _classroom_owner_username
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            _chatList[index]['username'] ==
                                                    _classroom_owner_username
                                                ? 'You'
                                                : _chatList[index]['username'],
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        mainAxisAlignment: _chatList[index]
                                                    ['username'] ==
                                                _classroom_owner_username
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _chatList[index]['message'],
                                              textAlign: _chatList[index]
                                                          ['username'] ==
                                                      _classroom_owner_username
                                                  ? TextAlign.end
                                                  : TextAlign.start,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        mainAxisAlignment: _chatList[index]
                                                    ['username'] ==
                                                _classroom_owner_username
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            _chatList[index]['time']
                                                .toString()
                                                .substring(0, 5),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: _chatList[index]
                                                          ['username'] ==
                                                      _classroom_owner_username
                                                  ? Colors.grey[200]
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },
                    ),
                  )
                : Container(
                    color: Colors.white,
                    child: Center(
                      child: SpinKitThreeBounce(color: Colors.teal[400]),
                    )),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.brown[50],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    height: 50,
                    width: 340,
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Post Message',
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => {print('send clicked')})
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getForumChat() async {
    print('take attendance');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {'token': prefs.getString('token')};
    print('headers:');
    print(_headers);
    print(this.widget.classId);
    var _body = json.encode({
      'classroom_uid': this.widget.classId.toString(),
      'timeout_minutes': 30,
    });
    var response = await http.post(forumChats, body: _body, headers: _headers);
    var res = json.decode(response.body.toString());
    print(res);
    if (res['success'] == true) {
      print('object');
      var forum_dets = res['data']['forum_stuff'];
      setState(() {
        _classroom_owner_uid = forum_dets['classroom_owner_uid'];
        _classroom_owner_username = forum_dets['classroom_owner_username'];
        _chatList = forum_dets['posts'];
      });
      prefs.setString('token', res['token'].toString());
      print(_chatList);
    } else {
      print('Response didn\'t fetch');
      print(res);
    }
  }
}
