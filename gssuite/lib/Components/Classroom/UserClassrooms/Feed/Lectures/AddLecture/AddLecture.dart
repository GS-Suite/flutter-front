import 'package:flutter/material.dart';
import 'package:gssuite/apis/api.dart';
import '../../../../../Drawer Component/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../ClassroomPanel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddLecture extends StatefulWidget {
  final classId;

  const AddLecture({Key key, this.classId}) : super(key: key);
  @override
  _AddLectureState createState() => _AddLectureState();
}

class _AddLectureState extends State<AddLecture> {
  TextEditingController lectureNameController,
      lectureLinkController,
      playlistController,
      lectureDescController;
  bool isLectureNameValid = true;
  bool isLectureLinkValid = true;
  bool isPlaylistValid = true;
  bool isLectureDescValid = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lectureNameController = TextEditingController();
    lectureLinkController = TextEditingController();
    playlistController = TextEditingController();
    lectureDescController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    lectureNameController.dispose();
    lectureLinkController.dispose();
    playlistController.dispose();
    lectureDescController.dispose();
  }

  createLecture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {
      'token': prefs.getString('token'),
    };

    //For create post
    var _body = json.encode({
      "lecture_name": lectureNameController.text,
      "lecture_link": lectureLinkController.text,
      "playlists": [playlistController.text],
      "lecture_description": lectureDescController.text,
      "classroom_uid": this.widget.classId
    });
    var response = await http.post(addLecture, body: _body, headers: _headers);
    var res = json.decode(response.body.toString());
    print(res);
    if (res['success'] == true) {
      print(res);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ClassroomPanel(
                classId: this.widget.classId,
                firstIndex: 0,
                secondIndex: 0,
              )));
    } else {
      print('error creating post');
      Fluttertoast.showToast(
          msg: 'Unable to create Lecture at the moment',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black38,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, // set it to false
        key: _scaffoldKey,
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
                        text: 'Create Lecture!', // To be changed
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
            width: 400,
            padding: EdgeInsets.only(top: 35, left: 20, right: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 60,
                    child: TextField(
                        onChanged: (value) {
                          if (value.length > 3) {
                            if (value.length < 5) {
                              isLectureNameValid = false;
                            } else {
                              isLectureNameValid = true;
                            }
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'Lecture Name',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            errorText: isLectureNameValid
                                ? null
                                : "Invalid lecture name"),
                        controller: lectureNameController),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    child: TextField(
                      onChanged: (value) {
                        if (value.length > 5) {
                          if (!value.startsWith('http')) {
                            isLectureLinkValid = false;
                          } else {
                            isLectureLinkValid = true;
                          }
                          setState(() {});
                        }
                      },
                      decoration: InputDecoration(
                          hintText: 'Lecture Link',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          errorText: isLectureLinkValid
                              ? null
                              : "Invalid Link. Link should start with 'http(s)'"),
                      controller: lectureLinkController,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    child: TextField(
                      onChanged: (value) {
                        if (value.length > 5) {
                          if (value.contains('!@#^&*')) {
                            isPlaylistValid = false;
                          } else {
                            isPlaylistValid = true;
                          }
                          setState(() {});
                        }
                      },
                      decoration: InputDecoration(
                          hintText: 'Playlist name',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          errorText:
                              isPlaylistValid ? null : "Invalid playlist name"),
                      controller: playlistController,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    child: TextField(
                      onChanged: (value) {
                        if (value.length > 3) {
                          if (value.length > 7) {
                            isLectureDescValid = true;
                          }
                          setState(() {});
                        }
                      },
                      decoration: InputDecoration(
                          hintText: 'About',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          errorText: isLectureDescValid
                              ? null
                              : "Invalid description"),
                      controller: lectureDescController,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      print('tapped');
                      createLecture();
                    },
                    child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(children: [
                          Container(
                            height: 40,
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.teal[400],
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'CREATE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ])),
                  )
                ])));
  }
}
