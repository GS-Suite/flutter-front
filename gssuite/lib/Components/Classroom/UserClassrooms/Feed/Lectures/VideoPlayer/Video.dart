import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Video extends StatefulWidget {
  final url;

  const Video({Key key, this.url}) : super(key: key);
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InAppWebView(
        initialUrl: this.widget.url,
        onWebViewCreated: (InAppWebViewController controller) {
          webView = controller;
        },
      ),
    );
  }
}
