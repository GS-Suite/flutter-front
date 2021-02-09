import 'package:flutter/material.dart';
import '../Drawer Component/drawer.dart';

class CreateClass extends StatefulWidget {
  @override
  _CreateClassState createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static bool _notice = true;

  @override
  void initState() {
    super.initState();
    print('init');
  }

  Widget _noticeModal() {
    final AlertDialog dialog = AlertDialog(
      title: Text('Terms and Conditions'),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 1; i <= 3; i++)
            ListTile(
              title: Text(
                'option $i',
              ),
              leading: Radio(
                value: i,
                groupValue: 1,
                onChanged: (_) {},
              ),
            ),
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () => () {
            print('Act 1');
          },
          child: Text('ACTION 1'),
        ),
        FlatButton(
          onPressed: () => () {},
          child: Text('ACTION 2'),
        ),
      ],
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 0, top: 15),
          child: GestureDetector(
            onTap: () => _scaffoldKey.currentState.openDrawer(),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: '# ',
                style: TextStyle(
                    color: Colors.teal[400],
                    fontWeight: FontWeight.bold,
                    fontSize: 33),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Create Class!', // To be changed
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: dialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _noticeModal();
  }
}
