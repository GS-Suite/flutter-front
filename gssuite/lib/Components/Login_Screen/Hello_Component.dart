import 'package:flutter/material.dart';

class HelloComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(15, 110, 0, 0),
            child: Text(
              'GS',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 80,
                  fontFamily: 'Montserrat'),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 180, 0, 0),
            child: Text(
              'Suite',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 80,
                  fontFamily: 'Montserrat'),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(197, 180, 0, 0),
            child: Text(
              '.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 80,
                color: Colors.lightBlue,
                fontFamily: 'Montserrat',
              ),
            ),
          )
        ],
      ),
    );
  }
}
