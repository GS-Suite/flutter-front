import 'package:flutter/material.dart';
import './Announcement/Announcement.dart';
import './Lectures/Lecture.dart';

class Feed extends StatefulWidget {
  final classId;

  const Feed({Key key, this.classId}) : super(key: key);
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with TickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material(
        color: Colors.white,
        child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.teal,
            labelColor: Colors.teal,
            unselectedLabelColor: Colors.black54,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.list),
              ),
              Tab(
                icon: Icon(Icons.announcement_outlined),
              ),
            ]),
      ),
      body: TabBarView(
        children: <Widget>[
          Lecture(),
          Announcement(
            classId: this.widget.classId,
          ),
        ],
        controller: _tabController,
      ),
    );
  }
}
