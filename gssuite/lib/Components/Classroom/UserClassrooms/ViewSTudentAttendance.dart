import 'package:flutter/material.dart';
import '../../Drawer Component/drawer.dart';

class ViewStudentsAttendance extends StatefulWidget {
  final studentList;

  const ViewStudentsAttendance({Key key, this.studentList}) : super(key: key);
  @override
  _ViewStudentsAttendanceState createState() => _ViewStudentsAttendanceState();
}

class _ViewStudentsAttendanceState extends State<ViewStudentsAttendance> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
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
      body: Container(
        child: _attendanceList != null
            ? Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _attendanceList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Container(
                            margin: EdgeInsets.only(right: 10.0),
                            width: 250,
                            child: ListTile(
                              title: Card(
                                child: ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  contentPadding: EdgeInsets.all(0),
                                  title: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 0, bottom: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _attendanceList[index]
                                                      .toString()
                                                      .substring(11, 19) +
                                                  ' Hrs',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              _attendanceList[index]
                                                  .toString()
                                                  .substring(0, 10),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                        onTap: () => {},
                                        child: Icon(Icons.chevron_right_sharp)),
                                  ),
                                ),
                              ),
                            )),
                      );
                    }),
              )
            : Center(
                child: SpinKitThreeBounce(
                color: Colors.teal[400],
              )),
      ),
    );
  }
}
