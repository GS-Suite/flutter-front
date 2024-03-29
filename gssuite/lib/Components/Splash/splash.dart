import 'package:flutter/material.dart';
import 'dart:async';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => Navigator.pushNamed(context, '/login'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white54),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/plant_grow.gif',
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Text(
                        'GS Suite.',
                        style: TextStyle(
                            fontSize: 30.0, color: Colors.greenAccent),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: Colors.yellow,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
