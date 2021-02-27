import 'package:flutter/material.dart';
import '../Drawer Component/drawer.dart';
import './createClassTitle.dart';
import '../Classroom/ClassroomPanel.dart';

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
                if (value.contains('!@#^&*')) {
                  setState(() {
                    isClassNameValid = false;
                  });
                }
              },
              style: TextStyle(fontSize: 25),
              decoration: InputDecoration(
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  errorText: isClassNameValid ? null : "Invalid classname"),
              controller: classNameController,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 40,
            child: Material(
              borderRadius: BorderRadius.circular(10),
              color: Colors.teal[400],
              elevation: 7.0,
              child: InkWell(
                onTap: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ClassroomPanel(
                            classId: '1',
                            className: classNameController.text,
                          )))
                },
                child: Center(
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                ),
              ),
            ),
          )
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
