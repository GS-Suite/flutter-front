import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flash/flash.dart';
import 'package:gssuite/apis/api.dart';
import 'package:gssuite/modal/User.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gssuite/utils/vernamCreds.dart';

class TextFieldComponent extends StatefulWidget {
  @override
  _TextFieldComponentState createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          '808232082652-jbq7r93nlk2e9hql7k8nam3or43leg6s.apps.googleusercontent.com');

  TextEditingController usernameController, passwordController;
  bool isUsernameValid = true;
  bool isPasswordValid = true;
  bool _showPassword = true;

  final _baseLog = signIn;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  login() async {
    print(_baseLog);
    var username = usernameController.text;
    var _body = json
        .encode({'username': username, 'password': passwordController.text});
    var response = await http
        .post('https://gs-suite-dev.herokuapp.com/sign_in/', body: _body);
    var res = json.decode(response.body.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (res['success'] == true) {
      var userData = User.fromJson(res);

      prefs.setString('token', userData.token);
      print(prefs.getString('token'));
    }
    if (prefs.getString('token') != null) {
      print(prefs.getString('token'));
      prefs.setString('username', username);
      Navigator.of(context).pushNamed(
        '/dashboard',
      );
    } else {
      _showBasicsFlash(
        flashStyle: FlashStyle.grounded,
      );
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
              onChanged: (text) {
                if (text.length > 4 && text.length < 9) {
                  setState(() {
                    isPasswordValid = false;
                  });
                } else {
                  setState(() {
                    isPasswordValid = true;
                  });
                }
              },
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
                errorText: isPasswordValid
                    ? null
                    : "Password is atleaast 8 characters!",
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
                  child: GestureDetector(
                    onTap: () => {startSignIn()},
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
                          Navigator.of(context).pushNamed('/register'),
                          controller.dismiss()
                        },
                    child: Text('Register')),
                FlatButton(
                    onPressed: () =>
                        {passwordController.text = '', controller.dismiss()},
                    child: Text('Try Again')),
              ],
              message: Text(message ?? 'Invalid username/pasword!'),
            ));
      },
    );
  }

  void startSignIn() async {
    GoogleSignInAccount user = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await user.authentication;
    if (user == null) {
      print('Sign In Failed');
    } else {
      print(_baseLog);
      print(user.displayName.substring(0, user.displayName.indexOf(' ')));
      print(googleAuth.accessToken);
      print({
        'id': user.id,
        'image': user.photoUrl,
        'username': user.displayName.contains(' ')
            ? user.displayName.substring(0, user.displayName.indexOf(' '))
            : user.displayName,
        'password':
            generateCreds(user.hashCode.toString(), user.email.toString())
      });
      var _body = json.encode({
        'username': user.displayName.contains(' ')
            ? user.displayName.substring(0, user.displayName.indexOf(' '))
            : user.displayName,
        'password':
            generateCreds(user.hashCode.toString(), user.email.toString())
      });
      var response = await http
          .post('https://gs-suite-dev.herokuapp.com/sign_in/', body: _body);
      var res = json.decode(response.body.toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (res['success'] == true) {
        var userData = User.fromJson(res);

        prefs.setString('token', userData.token);
        print('Token' + prefs.getString('token'));
      }
      if (prefs.getString('token') != null) {
        print(prefs.getString('token'));
        prefs.setString('username', user.displayName);
        Navigator.of(context).pushNamed(
          '/dashboard',
        );
      } else {
        _showBasicsFlash(
          flashStyle: FlashStyle.grounded,
        );
      }
    }
  }
}
