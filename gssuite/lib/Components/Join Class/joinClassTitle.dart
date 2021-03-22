import 'package:flutter/material.dart';

class TitleComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(15, 80, 0, 0),
            child: Text(
              'Enter',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 50,
                  fontFamily: 'Montserrat'),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 150, 0, 0),
            child: Text(
              'Join Code',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 50,
                  fontFamily: 'Montserrat'),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(275, 130, 0, 0),
            child: Text(
              '.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 70,
                color: Colors.teal[400],
                fontFamily: 'Montserrat',
              ),
            ),
          )
        ],
      ),
    );
  }
}
