import 'package:flutter/material.dart';
import 'package:gssuite/Components/Dashboard/dashboard.dart';
import 'package:gssuite/Components/Login_Screen/TitleComponent.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'TextField_Component.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignIn createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  static bool _isLoggedIn;

  isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('username'));
    print('init');
    setState(() {
      _isLoggedIn = prefs.getString('username') == null ? false : true;
    });
  }

  @override
  void initState() {
    super.initState();
    isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    print(_isLoggedIn);
    return _isLoggedIn != true
        ? _isLoggedIn == false
            ? main()
            : Center(
                child: SpinKitWanderingCubes(
                color: Colors.blueAccent,
              ))
        : Dashboard();
  }

  Widget main() {
    return Scaffold(
      body: ColorfulSafeArea(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [TitleComponent(), TextFieldComponent()],
            ),
          ),
        ),
      ),
    );
  }
}
