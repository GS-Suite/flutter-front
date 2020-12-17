import 'package:flutter/material.dart';

class TextFieldComponent extends StatelessWidget {
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
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
