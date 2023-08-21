import 'dart:convert';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zotit/config.dart';
import 'package:zotit/src/app_router.dart';
import 'package:zotit/src/providers/login_provider/login_provider.dart';
import 'package:zotit/src/screens/common/components/show_hide_eye.dart';
import 'package:zotit/src/screens/home/note_details.dart';
import 'package:zotit/src/screens/home/providers/home_provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:zotit/src/screens/home/side_drawer.dart';

class Home extends ConsumerStatefulWidget {
  Home({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Home();
}

class _Home extends ConsumerState<Home> {
  bool isVisible = true;
  _submit(context, text, isVisible) async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final config = Config();
    final uri = Uri(scheme: config.scheme, host: config.host, port: config.port, path: "api/notes");

    try {
      final res = await http.post(
        uri,
        headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
        body: jsonEncode({"text": text, "is_obscure": isVisible}),
      );
      if (res.statusCode == 200) {
      } else {
        showDialog<void>(
          context: context,
          builder: (c) {
            return ProviderScope(
              parent: ProviderScope.containerOf(context),
              child: AlertDialog(
                title: const Text('Error'),
                content: Text(res.body),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {
                      Navigator.pop(context, 'OK'),
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      showDialog<void>(
        context: context,
        builder: (c) {
          return ProviderScope(
            parent: ProviderScope.containerOf(context),
            child: AlertDialog(
              title: const Text('Error'),
              content: Text(e.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () => {
                    Navigator.pop(context, 'OK'),
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  _shareNote(BuildContext? context, String note) async {
    final box = context?.findRenderObject() as RenderBox?;
    await Scrollable.ensureVisible(
      context!,
      duration: const Duration(seconds: 1), // duration for scrolling time
      alignment: .5, // 0 mean, scroll to the top, 0.5 mean, half
      curve: Curves.easeInOutCubic,
    );
    await Share.share(
      "$note \nShared from https://web.zotit.app",
      subject: "note shared from Zotit | Note anywhere",
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  _updateNote(context, id, String isObScure) async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final config = Config();
    final uri = Uri(scheme: config.scheme, host: config.host, port: config.port, path: "api/notes");

    try {
      final res = await http.put(uri,
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
          body: jsonEncode({"id": id, "is_obscure": isObScure}));
      if (res.statusCode != 200) {
        showDialog<void>(
          context: context,
          builder: (c) {
            return ProviderScope(
              parent: ProviderScope.containerOf(context),
              child: AlertDialog(
                title: const Text('Error'),
                content: Text(res.body),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {
                      Navigator.pop(context, 'OK'),
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      showDialog<void>(
        context: context,
        builder: (c) {
          return ProviderScope(
            parent: ProviderScope.containerOf(context),
            child: AlertDialog(
              title: const Text('Error'),
              content: Text(e.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () => {
                    Navigator.pop(context, 'OK'),
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  _shareNoteWithUser(context, userName, noteId) async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final config = Config();
    final uri = Uri(scheme: config.scheme, host: config.host, port: config.port, path: "api/share-note");
    if (userName == "") {
      return showDialog<void>(
        context: context,
        builder: (c) {
          return ProviderScope(
            parent: ProviderScope.containerOf(context),
            child: AlertDialog(
              title: const Text('Error'),
              content: Text("Please enter username of the receiver"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => {
                    Navigator.pop(context, 'OK'),
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      );
    }
    try {
      final res = await http.post(
        uri,
        headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
        body: jsonEncode({"user_name": userName, "note_id": noteId}),
      );
      if (res.statusCode == 200) {
        showDialog<void>(
          context: context,
          builder: (c) {
            return ProviderScope(
              parent: ProviderScope.containerOf(context),
              child: AlertDialog(
                title: const Text('Success'),
                content: Text(res.body),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {
                      rcvrUsernameC.text = "",
                      Navigator.pop(context, 'OK'),
                      Navigator.pop(context, 'OK'),
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        );
        return;
      } else {
        showDialog<void>(
          context: context,
          builder: (c) {
            return ProviderScope(
              parent: ProviderScope.containerOf(context),
              child: AlertDialog(
                title: const Text('Error'),
                content: Text(res.body),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {
                      Navigator.pop(context, 'OK'),
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      showDialog<void>(
        context: context,
        builder: (c) {
          return ProviderScope(
            parent: ProviderScope.containerOf(context),
            child: AlertDialog(
              title: const Text('Error'),
              content: Text(e.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () => {
                    Navigator.pop(context, 'OK'),
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  _shareNoteWithUserBS(context, globalKey, noteEntry) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Wrap(
        children: [
          ListTile(
              trailing: ElevatedButton(
                onPressed: () async {
                  _shareNoteWithUser(context, rcvrUsernameC.text, noteEntry.value.id);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color(0xFF3A568E)),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                ),
                child: const Icon(Icons.share),
              ),
              title: Padding(
                padding: const EdgeInsets.all(2),
                child: TextFormField(
                  controller: rcvrUsernameC,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      fontFamily: 'Satisfy',
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Enter zotit username of receiver',
                  ),
                ),
              )),
          ListTile(
            title: ElevatedButton(
              onPressed: () async {
                _shareNote(globalKey.currentContext, noteEntry.value.text.toString());
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color(0xFF3A568E)),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 10)),
              ),
              child: const Text("Search via other apps"),
            ),
          ),
        ],
      ),
    );
  }

  _deleteNote(context, ref, id) async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final config = Config();
    final uri = Uri(scheme: config.scheme, host: config.host, port: config.port, path: "api/notes");
    return showDialog<void>(
      context: context,
      builder: (c) {
        return ProviderScope(
          parent: ProviderScope.containerOf(context),
          child: AlertDialog(
            title: const Text('Delete this note'),
            content: const Text("Are you sure ?"),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'OK');
                  try {
                    final res = await http.delete(
                      uri,
                      headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
                      body: jsonEncode({
                        "id": id,
                      }),
                    );
                    if (res.statusCode == 200) {
                      final _ = ref.refresh(noteListProvider.future);
                    } else {
                      showDialog<void>(
                        context: context,
                        builder: (c) {
                          return ProviderScope(
                            parent: ProviderScope.containerOf(context),
                            child: AlertDialog(
                              title: const Text('Error'),
                              content: Text(res.body),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => {
                                    Navigator.pop(context, 'OK'),
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  } catch (e) {
                    showDialog<void>(
                      context: context,
                      builder: (c) {
                        return ProviderScope(
                          parent: ProviderScope.containerOf(context),
                          child: AlertDialog(
                            title: const Text('Error'),
                            content: Text(e.toString()),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => {
                                  Navigator.pop(context, 'OK'),
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  TextEditingController textC = TextEditingController(text: "");
  TextEditingController rcvrUsernameC = TextEditingController(text: "");
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        ref.read(noteListProvider.notifier).getNotesByPage();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginData = ref.watch(loginTokenProvider.notifier);
    final notesData = ref.watch(noteListProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SideDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3A568E),
        title: Row(children: [
          const Text(
            "ZotIt ",
            style: TextStyle(fontFamily: 'Satisfy', fontSize: 35),
          ),
          Text("  |  @${loginData.getData().username}"),
        ]),
        actions: [
          // IconButton(
          //   onPressed: () => Navigator.pushNamed(context, AppRoutes.searchPage),
          //   icon: const Icon(Icons.search),
          // ),
          IconButton(
            onPressed: () => ref.refresh(noteListProvider.future),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Card(
              elevation: 2.0,
              shadowColor: Colors.grey,
              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10.0,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ShowHideEye(
                            isVisible: !isVisible,
                            onChange: (isTrue) async {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            })
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: textC,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                  fontFamily: 'Satisfy',
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Zot it',
                                hintText: 'What needs to be zoted...'),
                            minLines: 5,
                            maxLines: 20,
                          ),
                        ),
                        const Gap(10),
                        ElevatedButton(
                          onPressed: () async {
                            if (textC.text != '') {
                              await _submit(context, textC.text, !isVisible);
                              textC.text = '';
                              final _ = ref.refresh(noteListProvider);
                            }
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 20)),
                              backgroundColor: MaterialStateProperty.all(const Color(0xFF3A568E))),
                          child: const Icon(Icons.done),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: notesData.when(
                data: (notes) => ListView(
                    controller: _scrollController,
                    children: notes.notes.isNotEmpty
                        ? notes.notes.asMap().entries.map((noteEntry) {
                            final globalKey = GlobalKey();
                            return Card(
                              elevation: 2.0,
                              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                dense: true,
                                leading: Text(
                                  "test",
                                  style: TextStyle(color: Color(noteEntry.value.tag!.color)),
                                ),
                                title: Column(
                                  key: globalKey,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            TextButton.icon(
                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(text: noteEntry.value.text));
                                              },
                                              style: ButtonStyle(
                                                foregroundColor:
                                                    MaterialStateProperty.all<Color>(const Color(0xFF3A568E)),
                                              ),
                                              icon: const Icon(Icons.copy),
                                              label: const Text("Copy"),
                                            ),
                                            TextButton.icon(
                                              onPressed: () {
                                                Navigator.of(context).push(MaterialPageRoute<dynamic>(
                                                  builder: (_) => NoteDetails(
                                                    note: noteEntry.value,
                                                    noteIndex: noteEntry.key,
                                                  ),
                                                ));
                                              },
                                              style: ButtonStyle(
                                                foregroundColor:
                                                    MaterialStateProperty.all<Color>(const Color(0xFF3A568E)),
                                              ),
                                              icon: const Icon(Icons.edit_document),
                                              label: const Text("Edit"),
                                            ),
                                            ShowHideEye(
                                                isVisible: !noteEntry.value.is_obscure,
                                                onChange: (isTrue) async {
                                                  ref
                                                      .watch(noteListProvider.notifier)
                                                      .updateLocalNote(noteEntry.value.text, !isTrue, noteEntry.key);
                                                  await _updateNote(
                                                      context, noteEntry.value.id, !isTrue ? "true" : "false");
                                                })
                                          ],
                                        ),
                                        PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_vert),
                                          onSelected: (val) async {
                                            switch (val) {
                                              case "share":
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return _shareNoteWithUserBS(context, globalKey, noteEntry);
                                                  },
                                                );
                                                // _shareNote(globalKey.currentContext, noteEntry.value.text.toString());
                                                break;
                                              case "delete":
                                                await _deleteNote(context, ref, noteEntry.value.id);
                                                break;

                                              default:
                                            }
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return [
                                              const PopupMenuItem<String>(
                                                value: "share",
                                                child: Row(children: [
                                                  Icon(
                                                    Icons.share,
                                                    color: Color(0xFF3A568E),
                                                  ),
                                                  Gap(10),
                                                  Text(
                                                    "Share",
                                                    style: TextStyle(color: Color(0xFF3A568E)),
                                                  )
                                                ]),
                                              ),
                                              const PopupMenuItem<String>(
                                                value: "delete",
                                                child: Row(children: [
                                                  Icon(Icons.delete, color: Color(0xFF3A568E)),
                                                  Gap(10),
                                                  Text(
                                                    "Delete",
                                                    style: TextStyle(color: Color(0xFF3A568E)),
                                                  )
                                                ]),
                                              ),
                                            ];
                                          },
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                                subtitle: noteEntry.value.is_obscure
                                    ? ImageFiltered(
                                        imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                        child: Linkify(
                                          text: noteEntry.value.text,
                                          options: const LinkifyOptions(humanize: false),
                                          linkStyle: const TextStyle(fontSize: 16),
                                          onOpen: (LinkableElement link) async {
                                            if (!await launchUrl(Uri.parse(link.url))) {
                                              throw Exception('Could not launch ${link.url}');
                                            }
                                          },
                                        ),
                                      )
                                    : Linkify(
                                        text: noteEntry.value.text,
                                        options: const LinkifyOptions(humanize: false),
                                        linkStyle: const TextStyle(fontSize: 16),
                                        onOpen: (LinkableElement link) async {
                                          if (!await launchUrl(Uri.parse(link.url))) {
                                            throw Exception('Could not launch ${link.url}');
                                          }
                                        },
                                      ),
                              ),
                            );
                          }).toList()
                        : [
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(50),
                                child: Text(
                                  "No Notes Found",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ]),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (err, stack) => Text('Error: $err'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
