import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../apis/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

class Forums extends StatefulWidget {
  final classId;

  const Forums({Key key, this.classId}) : super(key: key);
  @override
  _ForumsState createState() => _ForumsState();
}

class _ForumsState extends State<Forums> {
  var _isChatValid = false;
  TextEditingController _postMessageController;
  final _controller = ScrollController();
  var _chatEmpty;
  var _chatList = [];
  var _classroom_owner_uid;
  var _classroom_owner_username;
  Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _postMessageController = TextEditingController();
    getForumChat();
    timer = Timer.periodic(
        Duration(seconds: 4),
        (Timer t) => {
              print('tiemr'),
              getForumChat(),
              _controller.jumpTo(_controller.position.maxScrollExtent)
            });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: _chatList != null
                  ? Container(
                      color: Colors.white,
                      child: ListView.builder(
                        controller: _controller,
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
                                    borderRadius: _chatList[index]
                                                ['username'] ==
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
                                    crossAxisAlignment: _chatList[index]
                                                ['username'] ==
                                            _classroom_owner_username
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _chatList[index]['username'] ==
                                                _classroom_owner_username
                                            ? 'You'
                                            : _chatList[index]['username'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          _chatList[index]['message'],
                                          textAlign: _chatList[index]
                                                      ['username'] ==
                                                  _classroom_owner_username
                                              ? TextAlign.end
                                              : TextAlign.start,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                            _chatList[index]['datetimestamp']
                                                .toString()
                                                .substring(11, 16),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ));
                        },
                      ),
                    )
                  : _chatEmpty
                      ? Container(
                          child: Center(child: Text('No posts yet...')),
                        )
                      : Container(
                          color: Colors.white,
                          child: Center(
                            child: SpinKitThreeBounce(color: Colors.teal[400]),
                          )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    height: 60,
                    width: 335,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: _postMessageController,
                          onChanged: (value) => {
                            if (value.length > 0)
                              {
                                setState(() => {_isChatValid = true})
                              }
                            else
                              {
                                setState(() => {_isChatValid = false})
                              }
                          },
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Post a message",
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () => _isChatValid
                          ? {print('clicked'), sendNewMessage()}
                          : {print('empty post')},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.send),
                      ))
                ],
              ),
            ),
          ],
        ),
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
      if (mounted) {
        setState(() {
          _chatEmpty = false;
          _classroom_owner_uid = forum_dets['classroom_owner_uid'];
          _classroom_owner_username = forum_dets['classroom_owner_username'];
          _chatList = forum_dets['posts'];
        });
      }
      prefs.setString('token', res['token'].toString());
    } else {
      if (res['message'] == 'There are no messages') {
        if (mounted) {
          setState(() {
            _chatEmpty = true;
          });
        }
      }
      print('Response didn\'t fetch');
      print(res);
    }
  }

  sendNewMessage() async {
    print('send message');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {'token': prefs.getString('token')};
    print(this.widget.classId);
    var _body = json.encode({
      "classroom_uid": this.widget.classId,
      "message": _postMessageController.text,
      "datetimestamp": DateTime.now().toString(),
      "reply_user_id": "",
      "reply_msg_id": "",
    });
    _postMessageController.clear();
    var response = await http.post(sendMessage, body: _body, headers: _headers);

    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      if (mounted) {
        setState(() {
          getForumChat();
        });
      }
      this.build.call(context); // Don't change this at any cost

      _controller.jumpTo(_controller.position.maxScrollExtent);
      prefs.setString('token', res['token'].toString());
    } else {
      print('Response didn\'t fetch');
      print(res);
    }
  }
}
