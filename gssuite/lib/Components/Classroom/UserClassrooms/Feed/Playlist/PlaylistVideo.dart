import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gssuite/apis/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../Lectures/VideoPlayer/Video.dart';
import 'package:http/http.dart' as http;
import '../../../../../utils/fetch_preview.dart';

class PlaylistVideo extends StatefulWidget {
  final playlistName;
  final classId;

  const PlaylistVideo({Key key, this.classId, this.playlistName})
      : super(key: key);

  @override
  _PlaylistVideoState createState() => _PlaylistVideoState();
}

class _PlaylistVideoState extends State<PlaylistVideo> {
  var _videoList;
  var _fetchList = [];
  var _isLoading = true;
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Container(
            child: !_isLoading
                ? Container(
                    color: Colors.white,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _fetchList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () => {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Video(
                                          url: _fetchList[index]['url'],
                                        )))
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[200]),
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
                                            _fetchList[index]['lecture_name'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
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
                                                _fetchList[index]['favIcon'],
                                                height: 12,
                                                width: 12,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                  _fetchList[index]['url']
                                                          .toString()
                                                          .substring(0, 20) +
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
    );
  }

  void getVideos() async {
    print('get videos');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {'token': prefs.getString('token')};
    print('headers:');
    print(_headers);
    var _body = json.encode({
      'classroom_uid': this.widget.classId.toString(),
      'playlist_name': this.widget.playlistName.toString(),
    });
    print('body');
    var response =
        await http.post(getPlaylistVideos, body: _body, headers: _headers);
    print('Lectures');
    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      var tempList = [];
      print(res);
      print(true);
      setState(() {
        _isLoading = false;
        _videoList = res['data'];
      });
      _videoList.forEach((e) async {
        var temp = {
          'url': e['lecture_link'],
          'lecture_description': e['lecture_description'],
          'lecture_name': e['lecture_name']
        };
        await FetchPreview()
            .fetch(e['lecture_link'].toString().endsWith('/')
                ? e['lecture_link']
                : e['lecture_link'] + '/')
            .then((res) {
          temp['title'] = res['title'];
          temp['image'] = res['image'];
          temp['description'] = res['description'];
          temp['favIcon'] = res['favIcon'];
        });
        tempList.add(temp);
        if (mounted) {
          setState(() {
            _fetchList = tempList;
          });
        }
      });
      prefs.setString('token', res['token'].toString());
    } else {
      if (res['message'] == 'There are no lectures to retrieve') {
        print('empty');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('Response didn\'t fetch');
        print(res);
      }
    }
  }
}
