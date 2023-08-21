import 'dart:convert';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zotit/config.dart';
import 'package:zotit/src/providers/login_provider/login_provider.dart';
import 'package:zotit/src/screens/common/components/show_hide_eye.dart';
import 'package:zotit/src/screens/home/note_details.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:zotit/src/screens/home/side_drawer.dart';
import 'package:zotit/src/screens/tags/note_tag_details.dart';
import 'package:zotit/src/screens/tags/providers/note_tags_provider.dart';

class NoteTags extends ConsumerStatefulWidget {
  const NoteTags({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteTags();
}

class _NoteTags extends ConsumerState<NoteTags> {
  bool isVisible = true;
  _submit(context, name, color) async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final config = Config();
    final uri = Uri(scheme: config.scheme, host: config.host, port: config.port, path: "api/tags");

    try {
      final res = await http.post(
        uri,
        headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
        body: jsonEncode({"name": name, "color": color}),
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
      duration: Duration(seconds: 1), // duration for scrolling time
      alignment: .5, // 0 mean, scroll to the top, 0.5 mean, half
      curve: Curves.easeInOutCubic,
    );
    await Share.share(
      "$note \nShared from https://web.zotit.app",
      subject: "note shared from Zotit | Note anywhere",
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  _updateNote(context, id, String name) async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final config = Config();
    final uri = Uri(scheme: config.scheme, host: config.host, port: config.port, path: "api/tags");

    try {
      final res = await http.put(uri,
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
          body: jsonEncode({"id": id, "name": name}));
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

  _deleteNote(context, ref, id) async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final config = Config();
    final uri = Uri(scheme: config.scheme, host: config.host, port: config.port, path: "api/tags");
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
                      final _ = ref.refresh(noteTagListProvider.future);
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
  final ScrollController _scrollController = ScrollController();
  Color _selectedColor = Color(0xff9e9e9e);

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        ref.read(noteTagListProvider.notifier).getNoteTagsByPage();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginData = ref.watch(loginTokenProvider.notifier);
    final noteTagsData = ref.watch(noteTagListProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3A568E),
        title: Text("Tags"),
        actions: [
          IconButton(
            onPressed: () => ref.refresh(noteTagListProvider.future),
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
                          Expanded(
                            child: TextFormField(
                              controller: textC,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter a name for tag',
                              ),
                            ),
                          ),
                          const Gap(10),
                          ElevatedButton(
                            onPressed: () async {
                              if (textC.text != '') {
                                await _submit(
                                  context,
                                  textC.text,
                                  _selectedColor.value,
                                );
                                textC.text = '';
                                final _ = ref.refresh(noteTagListProvider);
                              }
                            },
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 20)),
                                backgroundColor: MaterialStateProperty.all(const Color(0xFF3A568E))),
                            child: const Icon(Icons.done),
                          ),
                        ],
                      ),
                      BlockPicker(
                        pickerColor: _selectedColor,
                        onColorChanged: (Color color) {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        useInShowDialog: true,
                        layoutBuilder: ((context, colors, child) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Gap(20),
                                Text(
                                  "Pick a Color",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Gap(2),
                                SizedBox(
                                  height: 220,
                                  child: GridView.count(
                                    primary: true,
                                    crossAxisCount: 7,
                                    crossAxisSpacing: 6.0,
                                    mainAxisSpacing: 6.0,
                                    shrinkWrap: true,
                                    children: colors.map((e) => child(e)).toList(),
                                  ),
                                )
                              ],
                            )),
                        itemBuilder: (Color color, bool isCurrentColor, void Function() changeColor) {
                          return Container(
                            margin: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                              boxShadow: [
                                BoxShadow(color: color.withOpacity(0.8), offset: const Offset(1, 2), blurRadius: 5)
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: changeColor,
                                borderRadius: BorderRadius.circular(50),
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 210),
                                  opacity: isCurrentColor ? 1 : 0,
                                  child:
                                      Icon(Icons.done, color: useWhiteForeground(color) ? Colors.white : Colors.black),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  )),
            ),
            Expanded(
              child: noteTagsData.when(
                data: (noteTags) => ListView(
                    controller: _scrollController,
                    children: noteTags.noteTags.isNotEmpty
                        ? noteTags.noteTags.asMap().entries.map((noteEntry) {
                            final globalKey = GlobalKey();
                            return Card(
                              elevation: 2.0,
                              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                dense: true,
                                trailing: PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert),
                                  onSelected: (val) async {
                                    switch (val) {
                                      case "edit":
                                        Navigator.of(context).push(MaterialPageRoute<dynamic>(
                                          builder: (_) => NoteTagDetails(
                                            noteTag: noteEntry.value,
                                            noteIndex: noteEntry.key,
                                          ),
                                        ));
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
                                        value: "edit",
                                        child: Row(children: [
                                          Icon(
                                            Icons.edit,
                                            color: Color(0xFF3A568E),
                                          ),
                                          Gap(10),
                                          Text(
                                            "Edit",
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
                                title: Text(noteEntry.value.name),
                              ),
                            );
                          }).toList()
                        : [
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(50),
                                child: Text(
                                  "No Tags Found",
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
