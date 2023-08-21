import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit/config.dart';
import 'package:zotit/src/screens/home/providers/home_provider.dart';
import 'package:http/http.dart' as http;
import 'package:zotit/src/screens/tags/providers/note_tag.dart';
import 'package:zotit/src/screens/tags/providers/note_tags_provider.dart';

@immutable
class NoteTagDetails extends ConsumerWidget {
  final NoteTag noteTag;

  final int noteIndex;

  const NoteTagDetails({
    super.key,
    required this.noteTag,
    required this.noteIndex,
  });

  _submit(context, name, NoteTagList noteList) async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final config = Config();
    final uri = Uri(scheme: config.scheme, host: config.host, port: config.port, path: "api/tags");

    try {
      final res = await http.put(
        uri,
        headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "id": noteTag.id,
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
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController textC = TextEditingController(text: noteTag.name);
    final notesData = ref.read(noteTagListProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Tag"),
        backgroundColor: Color(0xFF3A568E),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: textC,
                decoration:
                    const InputDecoration(border: OutlineInputBorder(), labelText: 'Text', hintText: 'Update Tag'),
                minLines: 5,
                maxLines: 20,
              ),
            ),
            Container(
              height: 40,
              width: 250,
              child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF3A568E))),
                onPressed: () {
                  _submit(context, textC.text, notesData);
                  notesData.updateLocalNoteTag(textC.text, 1235413, noteIndex);
                },
                child: const Text(
                  'Update Text',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
