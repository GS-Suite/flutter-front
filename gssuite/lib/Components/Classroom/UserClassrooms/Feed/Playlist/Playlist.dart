import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gssuite/Components/Classroom/UserClassrooms/Feed/Playlist/PlaylistVideo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../apis/api.dart';

class PlayList extends StatefulWidget {
  final classId;

  const PlayList({Key key, this.classId}) : super(key: key);
  @override
  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  var _playlistList;
  var _isPLaylistEmpty;
  var _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Container(
            child: !_isLoading
                ? _isPLaylistEmpty
                    ? Center(child: Text('No Playlists made yet'))
                    : Container(
                        color: Colors.white,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: _playlistList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => PlaylistVideo(
                                                  classId: this.widget.classId,
                                                  playlistName:
                                                      _playlistList[index],
                                                )))
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.grey[200]),
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
                                            'https://img.pngio.com/spotify-playlist-music-png-clipart-area-computer-icons-desktop-playlist-png-728_495.jpg',
                                            width: 100,
                                            height: 120,
                                            fit: BoxFit.contain,
                                          ),
                                          // child: Image.asset(
                                          //     'assets/images/playlists.jpg'),
                                        ),
                                        Flexible(
                                            child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                _playlistList[index],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
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

  void getPlaylists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {'token': prefs.getString('token')};
    var _body = json.encode({
      'classroom_uid': this.widget.classId.toString(),
    });
    var response = await http.post(allPlaylist, body: _body, headers: _headers);
    var res = json.decode(response.body.toString());
    print(res);
    if (res['success'] == true) {
      setState(() {
        if (mounted) {
          _isPLaylistEmpty = false;
          _playlistList = res['data'].where((i) => i != '').toList();
          _isLoading = false;
        }
      });
      prefs.setString('token', res['token'].toString());
    } else {
      if (res['message'] == 'There are no lectures to retrieve') {
        if (mounted) {
          {
            setState(() {
              _isPLaylistEmpty = true;
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
