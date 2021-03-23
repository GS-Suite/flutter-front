import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChannelList extends StatelessWidget {
  final List classrooms;

  const ChannelList({Key key, this.classrooms}) : super(key: key);
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
            height: 165,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: classrooms.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: 250,
                      child: InkWell(
                        onTap: () {
                          print(this.classrooms[index]['name']);
                        },
                        child: Card(
                          color: Colors.grey[200],
                          child: Container(
                            child: Center(
                                child: Text(
                              this.classrooms[index]['name'].toString(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 36.0),
                            )),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}
