import 'package:flutter/material.dart';

class ClassroomPanel extends StatelessWidget {
  String className;
  String classId;
  ClassroomPanel({this.className, this.classId});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text(this.className != null ? className : 'null ClassName'),
              Text(this.classId != null ? classId : 'null ClassId')
            ],
          ),
        ),
      ),
    );
  }
}
