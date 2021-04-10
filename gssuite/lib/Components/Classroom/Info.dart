import 'package:flutter/material.dart';
import 'package:gssuite/apis/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Info extends StatefulWidget {
  final owner;
  final className;
  final classId;

  const Info({Key key, this.classId, this.className, this.owner})
      : super(key: key);
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  var _ownerName = '';
  var _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      text: 'Meta Data!', // To be changed
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),
          ),
        ),
      ),
      body: !_isLoading
          ? Container(
              alignment: Alignment.topLeft,
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              this.widget.className,
                              style: TextStyle(
                                fontSize: 28,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Created by '),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(_ownerName.toString()),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 40.0,
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1.0),
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(child: Icon(Icons.refresh_outlined)),
                                SizedBox(width: 10.0),
                                Center(
                                  child: Text('Refresh Invite Code',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat')),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 40.0,
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTap: () async {},
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.red[200],
                                      style: BorderStyle.solid,
                                      width: 1.0),
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                      child: Icon(Icons.remove_circle_outline)),
                                  SizedBox(width: 10.0),
                                  this.widget.owner == true
                                      ? Center(
                                          child: Text('Delete Classroom',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Montserrat')),
                                        )
                                      : null
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : Container(
              child: Center(
                child: SpinKitThreeBounce(
                  color: Colors.teal[400],
                ),
              ),
            ),
    );
  }

  void getOwnerNameF(classId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {'token': prefs.getString('token')};
    var _body = json.encode({
      'classroom_uid': this.widget.classId.toString(),
    });
    var response =
        await http.post(getOwnerName, body: _body, headers: _headers);
    var res = jsonDecode(response.body.toString());
    print(res);
    if (res['success'] == true) {
      setState(() {
        _isLoading = false;
        _ownerName = res['data']['classroom_name'];
      });

      prefs.setString('token', res['token'].toString());
    } else {
      if (res['message'] == 'There are no lectures to retrieve') {
        if (mounted) {
          {
            setState(() {
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
