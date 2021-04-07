import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

class Video extends StatefulWidget {
  final url;

  const Video({Key key, this.url}) : super(key: key);
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: "AIzaSyB4aDtQwesmWPxwscZWowaFb8HXKwVLUQM",
      videoUrl: "https://www.youtube.com/watch?v=UkEA5cSYgdE",
    ));
  }
}
