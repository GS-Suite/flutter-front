import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Classroom/ClassroomPanel.dart';
import 'dart:math' as math;
import '../Dashboard/dashboard.dart';

class ChannelList extends StatelessWidget {
  final List classrooms;
  final refreshKey;
  final Function onRefresh;

  const ChannelList({Key key, this.classrooms, this.refreshKey, this.onRefresh})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return this.classrooms.length == 0
        ? Container(
            height: 165,
            child: Center(
              child: SpinKitThreeBounce(
                color: Colors.teal[400],
                size: 50.0,
              ),
            ),
          )
        : Container(
            height: 200,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: classrooms.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      margin: EdgeInsets.only(right: 10.0),
                      width: 250,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ClassroomPanel(
                                    classId: this.classrooms[index]['uid'],
                                    className: this.classrooms[index]['name'],
                                  )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[300],
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Column(
                            children: [
                              Card(
                                color: Color(
                                        (math.Random().nextDouble() * 0xFFFFFF)
                                            .toInt())
                                    .withOpacity(0.30),
                                child: Container(
                                  height: 130,
                                  child: Center(
                                      child: Text(
                                    this.classrooms[index]['name'].toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 36.0),
                                  )),
                                ),
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.person_pin_outlined),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Text(
                                            this
                                                .classrooms[index]['name']
                                                .toString(),
                                            style: TextStyle(
                                                fontFamily: 'Montseratt',
                                                fontSize: 16.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.more_vert,
                                          size: 16.0,
                                        ),
                                        onPressed: () =>
                                            {print('vert_menu clicked')})
                                  ])
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}
