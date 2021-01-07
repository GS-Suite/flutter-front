import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flash/flash.dart';

class TextFieldComponent extends StatefulWidget {
  @override
  _TextFieldComponentState createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  TextEditingController usernameController, passwordController;
  bool isUsernameValid = true;
  bool isPasswordValid = true;
  bool _showPassword = true;

  final _baseLog = 'https://gstestsuite.herokuapp.com/auth/jwt/';

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  login() async {
    var response = await http.post(_baseLog, body: {
      'username': usernameController.text,
      'password': passwordController.text
    });
    var res = await json.decode(response.body.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', res['token']);
    print(prefs.getString('token'));
    if (prefs.getString('token') != null) {
      prefs.setString('username', usernameController.text);
      Navigator.of(context).pushNamed(
        '/dashboard',
      );
    } else {
      _showBasicsFlash(flashStyle: FlashStyle.grounded);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                if (value.length > 5) {
                  setState(() {});
                }
              },
              decoration: InputDecoration(
                  hintText: 'Username',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  errorText: isUsernameValid ? null : "Invalid username"),
              controller: usernameController,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            child: TextField(
              obscureText: _showPassword,
              decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  child: Icon(
                    !_showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                ),
                labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
                errorText:
                    isPasswordValid ? null : "Try for some strong password!",
              ),
              controller: passwordController,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            alignment: Alignment(1.0, 0.0),
            padding: EdgeInsets.only(top: 10),
            child: InkWell(
              child: Text(
                'Forgot Password',
                style: TextStyle(
                    color: Colors.teal[400],
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Container(
                  height: 40,
                  child: GestureDetector(
                    onTap: () {
                      login();
                      // Navigator.of(context).pushNamed('/dashboard');
                    },
                    child: InkWell(
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.teal[400],
                        elevation: 7.0,
                        child: Center(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40.0,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1.0),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: ImageIcon(AssetImage('assets/google.png')),
                        ),
                        SizedBox(width: 10.0),
                        Center(
                          child: Text('Log in with Google',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat')),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'New to GS Suite ?',
                      style: TextStyle(fontFamily: 'Montserrat'),
                    ),
                    SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/register');
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.teal[400],
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showBasicsFlash({
    Duration duration,
    flashStyle = FlashStyle.floating,
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
                        Navigator.of(context).pushNamed('/register'),
                        controller.dismiss()
                      },
                  child: Text('Register')),
              FlatButton(
                  onPressed: () =>
                      {passwordController.text = '', controller.dismiss()},
                  child: Text('Try Again')),
            ],
            message: Text(
                'Password/Email Id doesn\'t match. Please check your credentials.'),
          ),
        );
      },
    );
  }
}
