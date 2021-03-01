import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flash/flash.dart';
import 'package:gssuite/apis/api.dart';
import 'package:gssuite/utils/regEx.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TextFieldComponent extends StatefulWidget {
  @override
  _TextFieldComponentState createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          '808232082652-jbq7r93nlk2e9hql7k8nam3or43leg6s.apps.googleusercontent.com');
  TextEditingController emailController,
      usernameController,
      passwordController,
      firstNameController,
      lastNameController;
  bool isEmailValid = true;
  bool isUsernameValid = true;
  bool isPasswordValid = true;
  bool _showPassword = true;
  bool isFirstNameValid = true;
  bool isLastNameValid = true;

  final _baseLog = signUp;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
  }

  register() async {
    print('register');
    final creds = jsonEncode({
      'username': usernameController.text,
      'password': passwordController.text,
      'email': emailController.text,
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
    });
    var response = await http.post(_baseLog,
        headers: {"Content-Type": "application/json"}, body: creds);
    var res = await json.decode(response.body.toString());
    print(res);
    if (res['success'] == true) {
      Navigator.of(context).pushNamed('/login');
    } else {
      String message = 'User exists';
      showFlash(
        context: context,
        builder: (context, controller) {
          return Flash(
              controller: controller,
              style: FlashStyle.grounded,
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
                message: Text(message ?? 'Account doesn\'t exists.'),
              ));
        },
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
              onChanged: (value) {
                if (value.length > 5) {
                  if (value.contains('!@#^&*')) {
                    isFirstNameValid = false;
                  }
                  setState(() {});
                }
              },
              decoration: InputDecoration(
                  hintText: 'First name',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  errorText: isUsernameValid ? null : "Invalid first name"),
              controller: firstNameController,
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
                    isLastNameValid = false;
                  }
                  setState(() {});
                }
              },
              decoration: InputDecoration(
                  hintText: 'Last name',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  errorText: isUsernameValid ? null : "Invalid first name"),
              controller: lastNameController,
            ),
          ),
          SizedBox(
            height: 10,
          ),
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
                        print('tapped');
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
                  child: GestureDetector(
                    onTap: () => startGoogleRegister(),
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

  void startGoogleRegister() async {
    GoogleSignInAccount user = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await user.authentication;
    if (user == null) {
      print('Sign Up Failed');
    } else {
      print(user.email);
      print(user.displayName);
      print(googleAuth);
      print(googleAuth.accessToken);
      print(user.hashCode);
      final creds = jsonEncode({
        'username':
            user.displayName.substring(0, user.displayName.indexOf(' ')),
        'password': googleAuth.accessToken,
        'email': user.email,
        'first_name': user.displayName,
        'last_name': user.displayName,
      });
      var response = await http.post(_baseLog,
          headers: {"Content-Type": "application/json"}, body: creds);
      var res = await json.decode(response.body.toString());
      print(res);
      if (res['success'] == true) {
        Navigator.of(context).pushNamed('/login');
      } else {
        String message = 'User exists';
        showFlash(
          context: context,
          builder: (context, controller) {
            return Flash(
                controller: controller,
                style: FlashStyle.grounded,
                boxShadows: kElevationToShadow[4],
                horizontalDismissDirection:
                    HorizontalDismissDirection.horizontal,
                child: FlashBar(
                  actions: [
                    FlatButton(
                        onPressed: () => {
                              Navigator.of(context).pushNamed('/login'),
                              controller.dismiss()
                            },
                        child: Text('Login')),
                    FlatButton(
                        onPressed: () => {
                              passwordController.text = '',
                              controller.dismiss()
                            },
                        child: Text('Try Again')),
                  ],
                  message: Text(message),
                ));
          },
        );
      }
    }
  }
}
