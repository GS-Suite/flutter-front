import 'package:flutter/material.dart';
import '../../../Drawer Component/drawer.dart';

class ViewStudentsAttendance extends StatefulWidget {
  final studentList;
  final dateTime;

  const ViewStudentsAttendance({Key key, this.studentList, this.dateTime})
      : super(key: key);
  @override
  _ViewStudentsAttendanceState createState() => _ViewStudentsAttendanceState();
}

class _ViewStudentsAttendanceState extends State<ViewStudentsAttendance> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    print(this.widget.studentList);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.only(left: 0, top: 15),
            child: GestureDetector(
              onTap: () => _scaffoldKey.currentState.openDrawer(),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: '# ',
                  style: TextStyle(
                      color: Colors.teal[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 33),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Attendance}', // To be changed
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
        ),
        drawer: AppDrawer(),
        body: Container(
          child: Text('stulist'),
        ));
  }
}
