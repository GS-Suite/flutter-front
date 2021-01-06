import 'package:flutter/material.dart';
import 'subscription_Component.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    var pref = () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('token') == null) {
        Navigator.pop(context);
      }
    };
    pref();
  }

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
                    text: 'Hi, ' + 'kp!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        width: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SubscribedCourses(),
            ],
          ),
        ),
      ),
    );
  }
}
