import 'package:flutter/material.dart';
import 'channelList_Component.dart';

class SubscribedCourses extends StatelessWidget {
  final String title;
  final List classrooms;
  final Function onRefresh;
  final bool enrolled;
  const SubscribedCourses(
      {Key key, this.title, this.classrooms, this.onRefresh, this.enrolled})
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
                this.title,
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
          ChannelList(classrooms: this.classrooms, enrolled: this.enrolled),
        ],
      ),
    );
  }
}
