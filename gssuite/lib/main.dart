import 'package:flutter/material.dart';
import 'package:gssuite/Components/Register_Screen/register.dart';
import 'Components/Login_Screen/login.dart';
import 'Components/Dashboard/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/register': (BuildContext context) => new SignUp(),
        '/login': (BuildContext context) => new SignIn(),
        '/dashboard': (BuildContext context) => new Dashboard(),
      },
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignIn(title: 'Flutter Demo Home Page'),
    );
  }
}
