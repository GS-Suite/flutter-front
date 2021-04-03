import 'package:flutter/material.dart';

class Lecture extends StatefulWidget {
  @override
  _LectureState createState() => _LectureState();
}

class _LectureState extends State<Lecture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(child: Text('Lectures')),
    ));
  }
}
