import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../apis/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:developer';
import 'dart:async';

class Forums extends StatefulWidget {
  final classId;

  const Forums({Key key, this.classId}) : super(key: key);
  @override
  _ForumsState createState() => _ForumsState();
}

class _ForumsState extends State<Forums> {
  TextEditingController _postMessageController;
  var _chatList;
  var _classroom_owner_uid;
  var _classroom_owner_username;
  Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _postMessageController = TextEditingController();
    getForumChat();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => {getForumChat()});
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
                    child: Center(
                      child: TextField(
                        controller: _postMessageController,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Post a message"),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () => {print('clicked'), sendNewMessage()},
                      child: Icon(Icons.send))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getForumChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {'token': prefs.getString('token')};
    var _body = json.encode({
      'classroom_uid': this.widget.classId.toString(),
      'timeout_minutes': 30,
    });
    var response = await http.post(forumChats, body: _body, headers: _headers);
    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      var forum_dets = res['data']['forum_stuff'];
      setState(() {
        _classroom_owner_uid = forum_dets['classroom_owner_uid'];
        _classroom_owner_username = forum_dets['classroom_owner_username'];
        _chatList = forum_dets['posts'];
      });
      prefs.setString('token', res['token'].toString());
    } else {
      print('Response didn\'t fetch');
      print(res);
    }
  }

  sendNewMessage() async {
    // print('check this');
    // print(
    //     '{success: true, message: Forum messages have been acquired, token: 0b8548b1c1c284483402661585940a55437d3ec7ab3888cbd98f8d5aec2dc801, data: {forum_stuff: {classroom_uid: 737c056eaa3d4179915b97d0fe5a1f37, classroom_owner_uid: 342a159f-d594-445c-ab46-9e7eff0ae977, classroom_owner_username: testing, forum_id: 737c056eaa3d4179915b97d0fe5a1f37-F, thread: main, posts: [{message_id: WKlBr0SIUDACKII, reply_user_id: , reply_username: , reply_msg_id: , user_id: 342a159f-d594-445c-ab46-9e7eff0ae977, username: testing, message: First Message, date: 27-03-2021, time: 10:26:35}, {message_id: vlUNIzBkcCEbFwD, reply_user_id: 342a159f-d594-445c-ab46-9e7eff0ae977, reply_username: testing, reply_msg_id: WKlBr0SIUDACKII, user_id: 342a159f-d594-445c-ab46-9e7eff0ae977, username: testing, message: First Message, date: 27-03-2021, time: 10:27:40}, {message_id: tIUwA');
    print('send message');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {'token': prefs.getString('token')};
    print(this.widget.classId);
    var _body = json.encode({
      "classroom_uid": this.widget.classId,
      "message": _postMessageController.text,
      "reply_user_id": "",
      "reply_msg_id": ""
    });
    var response = await http.post(sendMessage, body: _body, headers: _headers);

    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      setState(() {
        getForumChat();
      });
      this.build.call(context); // Don't change this at any cost

      _postMessageController.clear();
      prefs.setString('token', res['token'].toString());
    } else {
      print('Response didn\'t fetch');
      print(res);
    }
  }
}
