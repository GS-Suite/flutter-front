import 'package:flutter/material.dart';
import 'channelList_Component.dart';

class SubscribedCourses extends StatelessWidget {
  final _title = 'Your Classes';
  final List classrooms;
  final refreshKey;
  final Function onRefresh;
  const SubscribedCourses(
      {Key key, this.classrooms, this.refreshKey, this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          ChannelList(
              classrooms: this.classrooms,
              refreshKey: refreshKey,
              onRefresh: onRefresh),
        ],
      ),
    );
  }
}
