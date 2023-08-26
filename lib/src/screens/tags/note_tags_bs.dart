import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit/config.dart';
import 'package:http/http.dart' as http;
import 'package:zotit/src/screens/tags/providers/note_tag.dart';
import 'package:zotit/src/screens/tags/providers/note_tags_provider.dart';

class NoteTagsBS extends ConsumerStatefulWidget {
  final NoteTag noteTag;
  final String noteId;

  NoteTagsBS({
    super.key,
    required this.noteTag,
    required this.noteId,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteTagsBS();
}

class _NoteTagsBS extends ConsumerState<NoteTagsBS> {
  late var selectedId = widget.noteTag.id;

  TextEditingController textC = TextEditingController(text: "");
  final ScrollController _scrollController = ScrollController();
  assignTag(context) async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final config = Config();
    final uri = Uri(scheme: config.scheme, host: config.host, port: config.port, path: "api/notes/assign-tag");

    try {
      Response res = await http.put(
        uri,
        headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
        body: jsonEncode({
          "id": widget.noteId,
          "tag_id": selectedId,
        }),
      );

      if (res.statusCode == 200) {
        Navigator.pop(context, 'OK');
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

  removeTag(context) async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final config = Config();
    final uri = Uri(scheme: config.scheme, host: config.host, port: config.port, path: "api/notes/remove-tag");

    try {
      Response res = await http.put(
        uri,
        headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
        body: jsonEncode({
          "id": widget.noteId,
        }),
      );

      if (res.statusCode == 200) {
        Navigator.pop(context, 'OK');
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
    final noteTagsData = ref.watch(noteTagListProvider);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Expanded(
        child: noteTagsData.when(
          data: (noteTags) => Wrap(
              children: noteTags.noteTags.isNotEmpty
                  ? noteTags.noteTags.asMap().entries.map((noteEntry) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: ChoiceChip(
                          avatar: noteEntry.value.id == selectedId
                              ? Icon(
                                  Icons.done,
                                  color: useWhiteForeground(Color(noteEntry.value.color)) ? Colors.white : Colors.black,
                                )
                              : null,
                          label: Text(
                            noteEntry.value.name,
                            style: TextStyle(
                              color: useWhiteForeground(Color(noteEntry.value.color)) ? Colors.white : Colors.black,
                            ),
                          ),
                          backgroundColor: Color(noteEntry.value.color),
                          selectedColor: Color(noteEntry.value.color),
                          selected: noteEntry.value.id == selectedId,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedId = selected ? noteEntry.value.id : "";
                            });
                            if (selected) {
                              assignTag(context);
                            } else {
                              removeTag(context);
                            }
                          },
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
          loading: () => Container(
            height: 50,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (err, stack) => Text('Error: $err'),
        ),
      ),
    );
  }
}
