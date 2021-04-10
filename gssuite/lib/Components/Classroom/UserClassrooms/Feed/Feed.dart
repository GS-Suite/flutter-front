import 'package:flutter/material.dart';
import './Announcement/Announcement.dart';
import './Lectures/Lecture.dart';
import './Playlist/Playlist.dart';

class Feed extends StatefulWidget {
  final classId;
  final firstIndex;
  const Feed({Key key, this.classId, this.firstIndex}) : super(key: key);
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Container(
          child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.teal[400],
              labelColor: Colors.teal[400],
              unselectedLabelColor: Colors.black54,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.list),
                  child: Text('Lectures'),
                ),
                Tab(
                  icon: Icon(Icons.playlist_play_outlined),
                  child: Text('Playlists'),
                ),
                Tab(
                  icon: Icon(Icons.announcement_outlined),
                  child: Text('Alerts'),
                ),
              ]),
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          Lecture(
            classId: this.widget.classId,
          ),
          PlayList(
            classId: this.widget.classId,
          ),
          Announcement(
            classId: this.widget.classId,
          ),
        ],
        controller: _tabController,
      ),
    );
  }
}
