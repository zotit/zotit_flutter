import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit/config.dart';
import 'package:zotit/src/providers/login_provider/login_provider.dart';
import 'package:http/http.dart' as http;
import 'package:zotit/src/screens/tags/note_tag_details.dart';
import 'package:zotit/src/screens/tags/providers/note_tag.dart';
import 'package:zotit/src/screens/tags/providers/note_tags_provider.dart';
import 'package:zotit/src/utils/httpn.dart';

class NoteTags extends ConsumerStatefulWidget {
  const NoteTags({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteTags();
}

class _NoteTags extends ConsumerState<NoteTags> {
  bool isVisible = true;
  _deleteNote(context, ref, id) async {
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
                    final res = await httpDelete("api/tags", {}, {
                      "id": id,
                    });

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
  final Color _selectedColor = const Color(0xff9e9e9e);

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ref.read(noteTagListProvider.notifier).getNoteTagsByPage();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final noteTagsData = ref.watch(noteTagListProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<dynamic>(
            builder: (_) => NoteTagDetails(
              noteTag: NoteTag(color: _selectedColor.value, id: "", name: ""),
              noteIndex: -1,
            ),
          ));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Tags"),
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: noteTagsData.when(
                data: (noteTags) => ListView(
                    controller: _scrollController,
                    children: noteTags.noteTags.isNotEmpty
                        ? noteTags.noteTags.asMap().entries.map((noteEntry) {
                            return Card(
                              elevation: 2.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                dense: true,
                                trailing: PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert),
                                  onSelected: (val) async {
                                    switch (val) {
                                      case "edit":
                                        Navigator.of(context)
                                            .push(MaterialPageRoute<dynamic>(
                                          builder: (_) => NoteTagDetails(
                                            noteTag: noteEntry.value,
                                            noteIndex: noteEntry.key,
                                          ),
                                        ));
                                        break;
                                      case "delete":
                                        await _deleteNote(
                                            context, ref, noteEntry.value.id);
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
                                          ),
                                          Gap(10),
                                          Text(
                                            "Edit",
                                          )
                                        ]),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: "delete",
                                        child: Row(children: [
                                          Icon(Icons.delete),
                                          Gap(10),
                                          Text(
                                            "Delete",
                                          )
                                        ]),
                                      ),
                                    ];
                                  },
                                ),
                                leading: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(noteEntry.value.color),
                                  ),
                                  child: Icon(
                                    Icons.local_offer_outlined,
                                    size: 16,
                                    color: useWhiteForeground(
                                            Color(noteEntry.value.color))
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),

                                // Chip(
                                //   backgroundColor: Color.fromARGB(31, 112, 112, 112),
                                //   avatar: CircleAvatar(
                                //     backgroundColor: Color(noteEntry.value.color),
                                //     child: Icon(
                                //       Icons.done,
                                //       size: 14,
                                //       color: useWhiteForeground(Color(noteEntry.value.color))
                                //           ? Colors.white
                                //           : Colors.black,
                                //     ),
                                //   ),
                                //   label: Text(
                                //     noteEntry.value.name,
                                //   ),
                                //   onPressed: () {},
                                // ),
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
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
