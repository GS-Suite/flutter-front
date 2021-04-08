import 'package:flutter/material.dart';
import 'channelList_Component.dart';
import 'searchPanel.dart';

class SubscribedCourses extends StatelessWidget {
  final String title;
  final List classrooms;
  final Function onRefresh;
  final bool enrolled;
  final BuildContext context;
  const SubscribedCourses(
      {Key key,
      this.title,
      this.classrooms,
      this.onRefresh,
      this.enrolled,
      this.context})
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
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_outlined),
                  onPressed: () => {
                    showSearch(
                        context: context,
                        delegate: DataSearch(this.classrooms, this.enrolled))
                  },
                  color: Colors.black,
                  iconSize: 20,
                ),
              )
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

  // viewAll() {
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => SearchList(
  //             classList: this.classrooms,
  //             enrolled: this.enrolled,
  //           )));
  // }
}
