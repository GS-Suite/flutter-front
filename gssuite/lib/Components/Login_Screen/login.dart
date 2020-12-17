import 'package:flutter/material.dart';
import 'package:gssuite/Components/Login_Screen/TitleComponent.dart';
import 'TextField_Component.dart';
import 'SignInButton_Component.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignIn createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [TitleComponent(), TextFieldComponent(), SignInButtons()],
          ),
        ),
      ),
    );
  }
}
