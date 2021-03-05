import 'package:http/http.dart' as http;
import '../apis/api.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

tokenRefresh() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var refreshedToken = await http.post(refreshToken,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'token': prefs.getString('token')}));
  print('refreshedToken ');
  print(json.decode(refreshedToken.body.toString()));
}
