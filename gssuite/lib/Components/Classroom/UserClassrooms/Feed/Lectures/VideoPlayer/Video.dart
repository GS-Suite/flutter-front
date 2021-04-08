import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Video extends StatefulWidget {
  final url;

  const Video({Key key, this.url}) : super(key: key);
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  var _id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _id = this.widget.url.toString().substring(8).startsWith('www')
        ? this.widget.url.toString().substring(12).startsWith('you')
            ? this.widget.url.toString().substring(
                  this.widget.url.length - 11,
                )
            : false
        : this.widget.url.toString().substring(8).startsWith('you')
            ? this.widget.url.toString().substring(
                  this.widget.url.length - 11,
                )
            : false;
  }

  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    print(this.widget.url.toString().substring(8));
    return Container(
      child: InAppWebView(
        initialUrl: this._id == false
            ? this.widget.url
            : 'https://www.youtube.com/embed/' + _id.toString(),
        onWebViewCreated: (InAppWebViewController controller) {
          webView = controller;
        },
      ),
    );
  }
}
