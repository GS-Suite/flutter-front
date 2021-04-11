import 'package:flutter/material.dart';
import 'package:gssuite/apis/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../../apis/api.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future<String> downloadLink(String path, String classId) async {
  print('get download link');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> _headers = {'token': prefs.getString('token')};
  var _body = json.encode({
    'classroom_uid': classId,
    "path": path,
  });
  print(_body);
  var response =
      await http.post(getDownloadLink, body: _body, headers: _headers);
  var res = json.decode(response.body.toString());
  print(res);
  if (res['success'] == true) {
    prefs.setString('token', res['token'].toString());
    return res['data'];
  } else {
    return 'false';
  }
}

class Resource extends StatefulWidget {
  final owner;
  final classId;

  const Resource({Key key, this.classId, this.owner}) : super(key: key);
  @override
  _ResourceState createState() => _ResourceState();
}

class _ResourceState extends State<Resource> {
  var _isResEmpty;
  var _isLoading = true;
  var _resList = [];

  @override
  void initState() {
    // TODO: implement initState
    print('init');
    getResources();
    // super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 15, top: 15),
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text: '# ',
              style: TextStyle(color: Colors.teal[400], fontSize: 30),
              children: <TextSpan>[
                TextSpan(
                    text: 'Resources', // To be changed
                    style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: DataSearch(_resList ?? [], this.widget.classId));
              })
        ],
      ),
      body: Container(
        child: Container(
            child: !_isLoading
                ? _isResEmpty
                    ? Center(child: Text('No resources uploaded yet'))
                    : Container(
                        color: Colors.white,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: _resList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                var link = await downloadLink(
                                    this._resList[index]['path'],
                                    this.widget.classId);
                                await canLaunch(link)
                                    ? await launch(link)
                                    : throw 'Could not launch';
                              },
                              child: Container(
                                height: 100,
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                            'https://findicons.com/files/icons/1579/devine/256/file.png'),
                                      ),
                                      Text(
                                        _resList[index]['name'],
                                        style: TextStyle(
                                            fontFamily: 'Montseratt',
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                            );
                          },
                        ))
                : Center(
                    child: SpinKitThreeBounce(
                      color: Colors.teal[400],
                    ),
                  )),
      ),
      floatingActionButton: this.widget.owner == true
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () async {
                FilePickerResult result = await FilePicker.platform.pickFiles();

                if (result != null) {
                  PlatformFile file = result.files.first;

                  print(file.name);
                  print(file.bytes);
                  print(file.size);
                  print(file.extension);
                  print(file.path);

                  String classroom_uid = this.widget.classId;

                  var url = uploadResource;
                  var request = http.MultipartRequest('POST', url);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  request.headers['token'] = prefs.getString('token');

                  request.fields['classroom_uid'] = classroom_uid;
                  request.fields['path'] = '/classrooms/' + classroom_uid;
                  request.files.add(http.MultipartFile(
                      'file',
                      File(file.path).readAsBytes().asStream(),
                      File(file.path).lengthSync(),
                      filename: file.name));
                  var res = jsonDecode(utf8
                      .decode(await (await request.send()).stream.toBytes()));
                  //   var responseData = await resp.stream.toBytes();
                  //   var respString = utf8.decode(responseData);
                  //  var res = jsonDecode(respString);
                  print(res);
                  if (res['success'] == true) {
                    getResources();
                  }
                } else {
                  // User canceled the picker
                  print('User canceled the picker');
                }
                print('Hello');
              },
              child: Icon(
                Icons.add,
                color: Colors.teal[400],
              ),
            )
          : null,
    );
  }

  void getResources() async {
    print('get resource');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> _headers = {'token': prefs.getString('token')};
    var _body = json.encode({
      'classroom_uid': this.widget.classId.toString(),
      "path": "/classrooms/" + this.widget.classId.toString(),
    });
    print(_body);
    var response =
        await http.post(getAllResources, body: _body, headers: _headers);
    var res = json.decode(response.body.toString());
    print(res);
    if (res['success'] == true) {
      setState(() {
        if (mounted) {
          _isResEmpty = false;
          _resList = res['data'];
          _isLoading = false;
        }
      });
      prefs.setString('token', res['token']);
    } else {
      if (res['message'] == 'No files have been uploaded' ||
          res['message'] == 'Files could not be retrieved') {
        if (mounted) {
          {
            setState(() {
              _isResEmpty = true;
              _isLoading = false;
            });
          }
        }
        print('Response didn\'t fetch');
        print(res);
      }
    }
  }
}

class DataSearch extends SearchDelegate {
  final resources;
  final classId;

  DataSearch(this.resources, this.classId);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final _resList = query.isEmpty
        ? this.resources
        : this
            .resources
            .where((obj) => obj['name']
                .toString()
                .toLowerCase()
                .startsWith(query.toLowerCase()))
            .toList();
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _resList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            var link = await downloadLink(_resList[index]['path'], classId);
            await canLaunch(link)
                ? await launch(link)
                : throw 'Could not launch';
          },
          child: Container(
            height: 100,
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                        'https://findicons.com/files/icons/1579/devine/256/file.png'),
                  ),
                  Text(
                    _resList[index]['name'],
                    style: TextStyle(fontFamily: 'Montseratt', fontSize: 18),
                  ),
                ],
              ),
            )),
          ),
        );
      },
    );
  }
}
