import 'package:flutter/material.dart';

class Forums extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text('Forums'),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Chat message',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
