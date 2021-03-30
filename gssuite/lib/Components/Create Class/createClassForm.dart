import 'package:flutter/material.dart';
import '../Drawer Component/drawer.dart';
import './createClassTitle.dart';
import '../../modal/Classrooms.dart';
import '../Classroom/UserClassrooms/ClassroomPanel.dart';
import 'package:gssuite/utils/regEx.dart';
import 'package:gssuite/apis/api.dart';
import 'package:flash/flash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateClassForm extends StatefulWidget {
  CreateClassForm({Key key}) : super(key: key);

  @override
  _CreateClassFormState createState() => _CreateClassFormState();
}

class _CreateClassFormState extends State<CreateClassForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController classNameController;
  bool isClassNameValid;

  @override
  void initState() {
    super.initState();
    classNameController = TextEditingController();
    isClassNameValid = true;
  }

  @override
  void dispose() {
    super.dispose();
    classNameController.dispose();
  }

  createClass(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {
      'token': prefs.getString('token'),
    };

    //For create class
    var _body = json.encode({'class_name': name});
    var response =
        await http.post(createClassroom, body: _body, headers: _headers);
    var res = json.decode(response.body.toString());
    if (res['success'] == true) {
      var classRoomData = Classroom.fromJson(res);
      if (classRoomData.data.uid != null) {
        print('creating forum');
        var _forBody = json.encode({'classroom_uid': classRoomData.data.uid});
        var _forResponse =
            await http.post(createForum, body: _forBody, headers: _headers);
        var _forRes = json.decode(_forResponse.body.toString());
        if (_forRes['success'] == true) {
          print(_forRes['token']);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ClassroomPanel(
                    classId: classRoomData.data.uid,
                    forumId: _forRes['token'],
                  )));
        } else {
          print('error creating forum');
          _showBasicsFlash(
            message: 'Forum creation error',
            flashStyle: FlashStyle.grounded,
          );
        }
      }
      print(classRoomData);
      print(classRoomData.data.uid);
    } else {
      _showBasicsFlash(
        flashStyle: FlashStyle.grounded,
      );
    }
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
                    onPressed: () =>
                        {classNameController.text = '', controller.dismiss()},
                    child: Text('Try Again')),
              ],
              message: Text(
                  message ?? 'Classroom "${classNameController.text}" exists'),
            ));
      },
    );
  }

  Widget _textFieldComponent() {
    return Container(
      width: 400,
      padding: EdgeInsets.only(top: 35, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 60,
            child: TextField(
              onChanged: (value) {
                if (classnmaeRegExp.hasMatch(value) && value.length > 5) {
                  setState(() {
                    isClassNameValid = true;
                  });
                } else {
                  setState(() {
                    isClassNameValid = false;
                  });
                }
              },
              style: TextStyle(fontSize: 25),
              decoration: InputDecoration(
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  errorText: isClassNameValid ? null : "Invalid classname"),
              controller: classNameController,
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
                  createClass(classNameController.text),
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => ClassroomPanel(
                  //           classId: '1',
                  //           className: classNameController.text,
                  //         )))
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      key: _scaffoldKey,

      drawer: AppDrawer(),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [TitleComponent(), _textFieldComponent()],
            ),
          ),
        ),
      ),
    );
  }
}
