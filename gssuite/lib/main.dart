import 'package:flutter/material.dart';
import 'package:gssuite/Components/Register_Screen/register.dart';
import 'Components/Login_Screen/login.dart';
import 'Components/Dashboard/dashboard.dart';
import 'package:page_transition/page_transition.dart';
import 'Components/Create Class/create_class_form.dart';
import 'Components/Join Class/joinClassForm.dart';
import './Components/AdvancedOptions/advanced_options.dart';
import './Components/Splash/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GS Suite',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/register':
            return PageTransition(
              child: SignUp(),
              type: PageTransitionType.rightToLeftWithFade,
            );
            break;
          case '/login':
            return PageTransition(
              child: SignIn(),
              type: PageTransitionType.rightToLeftWithFade,
            );
            break;
          case '/dashboard':
            return PageTransition(
              child: Dashboard(),
              type: PageTransitionType.rightToLeftWithFade,
            );
            break;
          case '/create_class':
            return PageTransition(
              child: CreateClass(),
              type: PageTransitionType.rightToLeftWithFade,
            );
            break;
          case '/join_class':
            return PageTransition(
              child: JoinClassForm(),
              type: PageTransitionType.rightToLeftWithFade,
            );
            break;

          case '/advanced_options':
            return PageTransition(
              child: AdvancedOption(),
              type: PageTransitionType.rightToLeftWithFade,
            );
            break;

          default:
            return null;
        }
      },
      // routes: <String, WidgetBuilder>{
      //   '/register': (BuildContext context) => new SignUp(),
      //   '/login': (BuildContext context) => new SignIn(),
      //   '/dashboard': (BuildContext context) => new Dashboard(),
      // },
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash(),
    );
  }
}
