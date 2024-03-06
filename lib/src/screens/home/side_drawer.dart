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
            margin: EdgeInsets.all(0),
            child: Center(
                child: Text(
              "ZotIt ",
              style: TextStyle(fontFamily: 'Satisfy', fontSize: 35),
            )),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Notes'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_delete),
            title: const Text('Deleted Notes'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.deletedNotesPage);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Update Profile'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.updateProfile);
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_offer_outlined),
            title: const Text('Tags'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.tagList);
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
