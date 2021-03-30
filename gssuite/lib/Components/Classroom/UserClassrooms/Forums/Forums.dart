import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../apis/api.dart';

class Forums extends StatefulWidget {
  final classId;

  const Forums({Key key, this.classId}) : super(key: key);
  @override
  _ForumsState createState() => _ForumsState();
}

class _ForumsState extends State<Forums> {
  var _chatList;
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
            child: Container(
              child: Text('Forums'),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Chat message',
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

    print(response.body.toString());
    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      print(res);
      print(res['message']);
      prefs.setString('token', res['token'].toString());
    } else {
      print('Response didn\'t fetch');
      print(res);
    }
  }
}
