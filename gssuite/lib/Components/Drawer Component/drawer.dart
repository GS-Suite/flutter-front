import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../apis/api.dart';

class AppDrawer extends StatelessWidget {
  Widget _createHeader() {
    return DrawerHeader(
      child: Stack(children: <Widget>[
        Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("GS ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w500)),
                Text("Suite ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w500))
              ],
            )),
      ]),
      decoration: BoxDecoration(
        color: Colors.teal[400],
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback tap}) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 20),
      title: Row(
        children: <Widget>[
          Icon(
            icon,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(text),
          )
        ],
      ),
      onTap: tap,
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
              icon: Icons.local_fire_department_sharp,
              text: 'What\'s new',
              tap: () async => await canLaunch(whatsNew)
                  ? await launch(whatsNew)
                  : throw 'Could not launch'),
          _createDrawerItem(
              icon: Icons.collections_bookmark_outlined, text: 'Bookmarks'),
          Divider(
            indent: 5,
          ),
          _createDrawerItem(icon: Icons.forum_outlined, text: 'Forums'),
          Divider(),
          _createDrawerItem(
              icon: Icons.settings_outlined,
              text: 'Advanced Options',
              tap: () => Navigator.pushNamed(context, '/advanced_options')),
          SizedBox(
            height: 165,
          ),
          Divider(),
          _createDrawerItem(
              icon: Icons.power_settings_new_outlined,
              text: 'Log Out',
              tap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
                Navigator.pushNamed(context, '/login');
              }),
        ],
      ),
    );
  }
}
