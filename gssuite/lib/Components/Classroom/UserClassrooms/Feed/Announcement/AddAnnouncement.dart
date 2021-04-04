import 'package:flutter/material.dart';
import 'package:gssuite/Components/Classroom/UserClassrooms/ClassroomPanel.dart';
import '../../../../Drawer Component/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../apis/api.dart';
import 'package:flash/flash.dart';

class AddAnnouncement extends StatefulWidget {
  final classId;

  const AddAnnouncement({Key key, this.classId}) : super(key: key);
  @override
  _AddAnnouncementState createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  TextEditingController announcementController;
  bool isAnnouncemantValid;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    announcementController = TextEditingController();
    isAnnouncemantValid = true;
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
                      text: 'Create Class!', // To be changed
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 80, 0, 0),
                      child: Text(
                        'Add',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 40,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 150, 0, 0),
                      child: Text(
                        'Announcement',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 40,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(338, 121, 0, 0),
                      child: Text(
                        '.',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 70,
                          color: Colors.teal[400],
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 400,
                padding: EdgeInsets.only(top: 35, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 60,
                      child: TextField(
                        onChanged: (value) {
                          if (value.length > 0) {
                            setState(() {
                              isAnnouncemantValid = true;
                            });
                          } else {
                            setState(() {
                              isAnnouncemantValid = false;
                            });
                          }
                        },
                        style: TextStyle(fontSize: 25),
                        decoration: InputDecoration(
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            errorText: isAnnouncemantValid
                                ? null
                                : "Invalid announcement"),
                        controller: announcementController,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 40,
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.teal[400],
                        elevation: 7.0,
                        child: InkWell(
                          onTap: () => {
                            createAnnouncement(announcementController.text),
                          },
                          child: Center(
                            child: Text(
                              'NEXT',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  createAnnouncement(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {
      'token': prefs.getString('token'),
    };

    //For create post
    var _body = json
        .encode({'classroom_uid': this.widget.classId, 'announcement': text});
    var response =
        await http.post(addAnnouncement, body: _body, headers: _headers);
    var res = json.decode(response.body.toString());
    print(res);
    if (res['success'] == true) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ClassroomPanel(
                classId: this.widget.classId,
              )));
    } else {
      print('error creating post');
      _showBasicsFlash(
        message: 'Post creation error',
        flashStyle: FlashStyle.grounded,
      );
    }
    // For Creating Announcement Pane

    //   }
    //   print(classRoomData);
    //   print(classRoomData.data.uid);
    // } else {
    //   _showBasicsFlash(
    //     flashStyle: FlashStyle.grounded,
    //   );
  }

  void _showBasicsFlash({
    Duration duration,
    flashStyle = FlashStyle.floating,
    String message,
  }) {
    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
            controller: controller,
            style: flashStyle,
            boxShadows: kElevationToShadow[4],
            horizontalDismissDirection: HorizontalDismissDirection.horizontal,
            child: FlashBar(
              actions: [
                FlatButton(
                    onPressed: () => {
                          announcementController.text = '',
                          controller.dismiss()
                        },
                    child: Text('Try Again')),
              ],
              message: Text(message ?? 'Post creation Error'),
            ));
      },
    );
  }
}
