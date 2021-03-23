import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
            height: 165,
            child: RefreshIndicator(
              key: refreshKey,
              onRefresh: onRefresh,
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
            ),
          );
  }
}
