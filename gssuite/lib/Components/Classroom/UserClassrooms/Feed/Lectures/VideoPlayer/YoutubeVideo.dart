// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class YoutubeVideo extends StatefulWidget {
//   final url;

//   const YoutubeVideo({Key key, this.url}) : super(key: key);
//   @override
//   _YoutubeVideoState createState() => _YoutubeVideoState();
// }

// class _YoutubeVideoState extends State<YoutubeVideo> {
//   YoutubePlayerController _controller;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: 'iLnmTe5Q2Qw',
//       flags: YoutubePlayerFlags(
//         autoPlay: true,
//         mute: true,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video'),
//       ),
//       body: YoutubePlayerBuilder(
//         player: YoutubePlayer(
//           bottomActions: [
//             CurrentPosition(),
//             ProgressBar(isExpanded: true),
//           ],
//           controller: _controller,
//         ),
//         builder: (context, player) {
//           return Column(
//             children: [
//               // some widgets
//               player,
//               //some other widgets
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
