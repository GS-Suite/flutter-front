import 'package:flutter/material.dart';
import '../Drawer Component/drawer.dart';
import '../Profile/profile.dart';

class UniversalSearchPanel extends StatelessWidget {
  final userList;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UniversalSearchPanel({Key key, this.userList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      text: 'Users', // To be changed
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Container(
                      width: 250,
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Profile(
                                    username: userList[index]['username'],
                                    userId: '',
                                  )))
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 0, bottom: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.account_box_outlined,
                                            size: 35,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            userList[index]['username'],
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.grey[600]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              }),
        ),
      )),
    );
  }
}
