import 'package:flutter/material.dart';
import '../../../Drawer Component/drawer.dart';

class ViewStudentsAttendance extends StatefulWidget {
  final studentList;
  final dateTime;
  final anyoneMarked;

  const ViewStudentsAttendance(
      {Key key, this.studentList, this.dateTime, this.anyoneMarked})
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
                        text: 'Attendance', // To be changed
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
        ),
        drawer: AppDrawer(),
        body: this.widget.anyoneMarked
            ? Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: this.widget.studentList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Container(
                            margin: EdgeInsets.only(right: 10.0),
                            width: 250,
                            child: ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: 0, vertical: -4),
                              contentPadding: EdgeInsets.all(0),
                              title: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Icon(
                                          Icons.account_box_outlined,
                                          size: 30,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 15, bottom: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                this
                                                    .widget
                                                    .studentList[index]
                                                    .toString(),
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.black26)))),
                      );
                    }),
              )
            : Container(child: Center(child: Text('No one attended'))));
  }
}
