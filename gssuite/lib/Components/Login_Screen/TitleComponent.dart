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
              'GS',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 70,
                  fontFamily: 'Montserrat'),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 150, 0, 0),
            child: Text(
              'Suite',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 70,
                  fontFamily: 'Montserrat'),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(200, 150, 0, 0),
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
