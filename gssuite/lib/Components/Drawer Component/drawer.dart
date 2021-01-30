import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  Widget _createHeader() {
    return DrawerHeader(
      child: Stack(children: <Widget>[
        Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text("",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500))),
      ]),
      decoration: BoxDecoration(
        color: Colors.teal[400],
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.create_new_folder_outlined, text: 'Create Class'),
          _createDrawerItem(
            icon: Icons.note_outlined,
            text: 'Saved Notes',
          ),
          _createDrawerItem(
              icon: Icons.collections_bookmark_outlined, text: 'Bookmarks'),
          Divider(),
          _createDrawerItem(
              icon: Icons.fingerprint_outlined, text: 'Attendance'),
          _createDrawerItem(icon: Icons.forum_outlined, text: 'Forums'),
          Divider(),
          _createDrawerItem(
              icon: Icons.bug_report_outlined, text: 'Report an issue'),
          ListTile(
            title: Text('0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
