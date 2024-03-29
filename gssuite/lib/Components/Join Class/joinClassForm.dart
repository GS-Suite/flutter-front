import 'package:flutter/material.dart';
import '../Drawer Component/drawer.dart';
import './joinClassTitle.dart';
import '../Classroom/EnrollClassrooms/ClassroomPanelEnrolled.dart';
import 'package:gssuite/utils/regEx.dart';
import 'package:gssuite/apis/api.dart';
import 'package:gssuite/utils/refreshToken.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JoinClassForm extends StatefulWidget {
  JoinClassForm({Key key}) : super(key: key);

  @override
  _JoinClassFormState createState() => _JoinClassFormState();
}

class _JoinClassFormState extends State<JoinClassForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController joinCodeController;
  bool isjoinCodeValid;

  @override
  void initState() {
    super.initState();
    joinCodeController = TextEditingController();
    isjoinCodeValid = true;
  }

  @override
  void dispose() {
    super.dispose();
    joinCodeController.dispose();
  }

  getClassUid({String joinCode, String token}) async {
    print('getclassuid');
    print(joinCode + ' ' + token);
    Map<String, String> _headers = {'token': token};
    var _body = json.encode({'entry_code': joinCode});
    print('post init');
    try {
      var response =
          await http.post(getClassroomUid, body: _body, headers: _headers);
      print('response');
      print(response);
      print(response.body.toString());
      var res = json.decode(response.body.toString());
      print('res');
      print(res);
      if (res['success'] == true) {
        return res['data']['classroom_uid'];
      }
    } catch (e) {
      print(e);
    }
  }

  joinClass(String entry_code) async {
    print('join');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');
    print('token' + token);

    var classroom_uid = await getClassUid(joinCode: entry_code, token: token);

    Map<String, String> _headers = {
      'token': prefs.getString('token'),
    };

    var _body =
        json.encode({'classroom_uid': classroom_uid, 'entry_code': entry_code});
    var response =
        await http.post(enrollClassroom, body: _body, headers: _headers);
    var res = json.decode(response.body.toString());
    print(res);
    if (res['success'] == true) {
      Fluttertoast.showToast(
          msg: res['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black38,
          fontSize: 16.0);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ClassroomPanelEnrolled(
                classId: classroom_uid,
              )));
    } else {
      Fluttertoast.showToast(
          msg: res['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black38,
          fontSize: 16.0);
    }
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
                if (classnmaeRegExp.hasMatch(value)) {
                  setState(() {
                    isjoinCodeValid = true;
                  });
                } else {
                  setState(() {
                    isjoinCodeValid = false;
                  });
                }
              },
              style: TextStyle(fontSize: 25),
              decoration: InputDecoration(
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  errorText: isjoinCodeValid ? null : "Invalid classname"),
              controller: joinCodeController,
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
                  joinClass(joinCodeController.text),
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => ClassroomPanel(
                  //           classId: '1',
                  //           className: classNameController.text,
                  //         )))
                },
                child: Center(
                  child: Text(
                    'JOIN',
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
