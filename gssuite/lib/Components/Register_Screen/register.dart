import 'package:flutter/material.dart';
import 'package:gssuite/Components/Login_Screen/TitleComponent.dart';
import 'TextField_Component.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleComponent(),
              TextFieldComponent(),
            ],
          ),
        ),
      ),
    );
  }
}
