import 'package:flutter/material.dart';

class PlayList extends StatefulWidget {
  final classId;

  const PlayList({Key key, this.classId}) : super(key: key);

  @override
  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Playlist'),
    );
  }
}
