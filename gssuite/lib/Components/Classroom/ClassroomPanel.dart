import 'package:flutter/material.dart';
import '../Drawer Component/drawer.dart';

class ClassroomPanel extends StatefulWidget {
  String className;
  String classId;
  ClassroomPanel({this.className, this.classId});

  @override
  _ClassroomPanelState createState() => _ClassroomPanelState();
}

class _ClassroomPanelState extends State<ClassroomPanel> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    print('classroom panel init');
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 15, top: 15),
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
                        text: this.widget.className, // To be changed
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(55),
              child: Align(
                child: Container(
                  height: 43,
                  child: TabBar(
                      unselectedLabelColor: Colors.teal[400],
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.teal[400]),
                      tabs: [
                        Tab(
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Colors.teal[400], width: 2)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Feed",
                                style: TextStyle(fontFamily: 'Montseratt'),
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Colors.teal[400], width: 2)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Attendance",
                                style: TextStyle(fontFamily: 'Montseratt'),
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Colors.teal[400], width: 2)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Forums",
                                style: TextStyle(fontFamily: 'Montseratt'),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              )),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Container(
                child: Text(
                  "Feed",
                  style: TextStyle(fontSize: 22, color: Colors.teal[400]),
                ),
              ),
            ),
            Center(
              child: Container(
                child: Text(
                  "Attendance",
                  style: TextStyle(fontSize: 22, color: Colors.teal[400]),
                ),
              ),
            ),
            Center(
              child: Container(
                child: Text(
                  "Forums",
                  style: TextStyle(fontSize: 22, color: Colors.teal[400]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
