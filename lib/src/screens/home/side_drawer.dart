import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zotit/src/app_router.dart';
import 'package:zotit/src/providers/login_provider/login_provider.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginData = ref.watch(loginTokenProvider.notifier);
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          const DrawerHeader(
            child: Center(
                child: Text(
              "ZotIt ",
              style: TextStyle(fontFamily: 'Satisfy', fontSize: 35),
            )),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 221, 229, 243),
            ),
            margin: EdgeInsets.all(0),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Update Profile'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.updateProfile);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async {
              loginData.logout();
            },
          ),
        ],
      ),
    );
  }
}
