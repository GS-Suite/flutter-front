// // import 'dart:html';

// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// // import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// // import 'package:webview_flutter/webview_flutter.dart';
// // import 'package:flutter/services.dart' show rootBundle;
// // import 'dart:convert';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   // WebViewController _controller;
//   // final AssetBundle rootBundle = _initRootBundle();
//   //
//   InAppWebViewController webView;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(

//         title: Text(widget.title),
//       ),
//       body: Container(
//         child: ElevatedButton(
//             child: Container(
//               child: Text('Pick file...'),
//             ),
//             onPressed: () async {
//               FilePickerResult result = await FilePicker.platform.pickFiles();

//               if(result != null) {
//                 PlatformFile file = result.files.first;

//                 print(file.name);
//                 print(file.bytes);
//                 print(file.size);
//                 print(file.extension);
//                 print(file.path);

//                 String classroom_uid = '';

//                 var url = Uri.parse('https://gs-suite-dev.herokuapp.com/resources/upload_file/');
//                 var request = http.MultipartRequest('POST', url);
//                 request.headers['token'] ='' ;

//                 request.fields['classroom_uid'] = classroom_uid;
//                 request.fields['path'] = '/classrooms/' + classroom_uid;
//                 request.files.add(
//                   http.MultipartFile(
//                     'file',
//                     File(file.path).readAsBytes().asStream(),
//                     File(file.path).lengthSync(),
//                     filename: file.name
//                     )
//                   );
//                   var resp = await request.send();
//                   var responseData = await resp.stream.toBytes();
//                   var respString = utf8.decode(responseData);
//                   print(jsonDecode(respString));

//               } else {
//                 // User canceled the picker
//               }
//               print('Hello');
//             }
//           )

//       )
//     );
//   }
// }

// The Splash Screen
//

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:youtube_player/Page.dart';

// void main() {
//   runApp(MyApp());
// }

// class Page extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   @override
//   void initState() {
//     super.initState();
//     Timer(Duration(seconds: 3), () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => Page())
//       )
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           fit: StackFit.expand,
//           children: <Widget>[
//             Container(
//               decoration: BoxDecoration(color: Colors.white54),
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ClipOval(
//                           child: Image.asset(
//                             'assets/growth.gif',
//                             height: 200,
//                             width: 200,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 50.0,
//                         ),
//                         Text(
//                           'GS Suite.',
//                           style: TextStyle(
//                             fontSize: 30.0,
//                             color: Colors.greenAccent
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         backgroundColor: Colors.yellow,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(top: 20.0),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
