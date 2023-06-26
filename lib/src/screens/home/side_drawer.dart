import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          DrawerHeader(
            child: Center(
                child: Text(
              "ZotIt ",
              style: TextStyle(fontFamily: 'Satisfy', fontSize: 35),
            )),
            decoration: const BoxDecoration(
              color: Color(0xfff3e0dd),
            ),
            margin: const EdgeInsets.all(0),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async {},
          ),
        ],
      ),
    );
  }
}
