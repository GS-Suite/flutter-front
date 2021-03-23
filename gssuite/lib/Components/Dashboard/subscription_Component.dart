import 'package:flutter/material.dart';
import 'channelList_Component.dart';

class SubscribedCourses extends StatelessWidget {
  final _title = 'Subscribed Channels';
  final List classrooms;
  const SubscribedCourses({Key key, this.classrooms}) : super(key: key);

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
              InkWell(
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 18,
                  color: Colors.teal[400],
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          ChannelList(
            classrooms: this.classrooms,
          ),
        ],
      ),
    );
  }
}
