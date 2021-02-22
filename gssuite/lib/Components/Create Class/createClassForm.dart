import 'package:flutter/material.dart';
import '../Drawer Component/drawer.dart';
import './createClassTitle.dart';

class CreateClassForm extends StatefulWidget {
  CreateClassForm({Key key}) : super(key: key);

  @override
  _CreateClassFormState createState() => _CreateClassFormState();
}

class _CreateClassFormState extends State<CreateClassForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController classNameController;
  bool isClassNameValid = true;

  @override
  void initState() {
    super.initState();
    classNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    classNameController.dispose();
  }

  Widget _textFieldComponent() {
    return Container(
      width: 400,
      padding: EdgeInsets.only(top: 35, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 60,
            child: TextField(
              onChanged: (value) {
                if (value.length > 5) {
                  setState(() {});
                }
              },
              style: TextStyle(fontSize: 25),
              decoration: InputDecoration(
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  errorText: isClassNameValid ? null : "Invalid username"),
              controller: classNameController,
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      key: _scaffoldKey,

      drawer: AppDrawer(),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [TitleComponent(), _textFieldComponent()],
            ),
          ),
        ),
      ),
    );
  }
}
