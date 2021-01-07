import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TextFieldComponent extends StatefulWidget {
  @override
  _TextFieldComponentState createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  TextEditingController emailController, usernameController, passwordController;
  bool isEmailValid = true;
  bool isUsernameValid = true;
  bool isPasswordValid = true;
  bool _showPassword = true;

  final _baseLog = 'https://gstestsuite.herokuapp.com/sign_up/';

  RegExp emailRegExp = new RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?\s^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  RegExp passwordRegExp = new RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$',
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  register() async {
    var response = await http.post(_baseLog, body: {
      {
        'username': usernameController.text,
        'password1': passwordController.text,
        'password2': passwordController.text,
        'name': usernameController.text
      }
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
      // _showBasicsFlash(flashStyle: FlashStyle.grounded);
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
                if (value.length > 7) {
                  if (emailRegExp.hasMatch(value)) {
                    isEmailValid = true;
                  } else {
                    isEmailValid = false;
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
                  errorText: isEmailValid ? null : "Invalid email"),
              controller: emailController,
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
                    isUsernameValid = false;
                  }
                  setState(() {});
                }
              },
              decoration: InputDecoration(
                  hintText: 'Username',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  errorText: isEmailValid ? null : "Invalid username"),
              controller: usernameController,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            child: TextField(
              onChanged: (value) {
                if (!passwordRegExp.hasMatch(value)) {
                  isPasswordValid = false;
                } else {
                  isPasswordValid = true;
                }
                setState(() {});
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
                errorText:
                    isPasswordValid ? null : "Try for some strong password!",
              ),
              controller: passwordController,
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
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.teal[400],
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () {
                        register();
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
                          child: Text('Register with Google',
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
                      'Have an account ?',
                      style: TextStyle(fontFamily: 'Montserrat'),
                    ),
                    SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: Text(
                        'Log In',
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
}
