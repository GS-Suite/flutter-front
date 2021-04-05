import 'package:flutter/material.dart';
import '../../../../../Drawer Component/drawer.dart';

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
                          }
                          setState(() {});
                        }
                      },
                      decoration: InputDecoration(
                          hintText: 'Last name',
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
                          hintText: 'Email',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          errorText:
                              isLectureDescValid ? null : "Invalid email"),
                      controller: lectureDescController,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(children: [
                        Container(
                          height: 40,
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.teal[400],
                            elevation: 7.0,
                            child: GestureDetector(
                              onTap: () {
                                print('tapped');
                                // register();
                              },
                              child: Center(
                                child: Text(
                                  'REGISTER',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ]))
                ])));
  }
}
