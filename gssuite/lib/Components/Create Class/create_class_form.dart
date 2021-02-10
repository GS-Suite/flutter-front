import 'package:flutter/material.dart';
import '../Drawer Component/drawer.dart';
import 'package:gssuite/utils/TnC.dart';

class CreateClass extends StatefulWidget {
  @override
  _CreateClassState createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static bool _notice;

  @override
  void initState() {
    super.initState();
    print('init');
    setState(() {
      _notice = true;
    });
  }

  Widget _noticeModal() {
    final AlertDialog dialog = AlertDialog(
      title: Text('Terms and Conditions'),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(tnc),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () => {Navigator.pushNamed(context, '/dashboard')},
          child: Text('Deny'),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _notice = false;
            });
          },
          child: Text('Accept & Continue'),
        ),
      ],
    );

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
      body: _notice
          ? dialog
          : Center(
              child: Text('create class'),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _noticeModal();
  }
}
