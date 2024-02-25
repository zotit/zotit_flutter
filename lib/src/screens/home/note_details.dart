import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit/config.dart';
import 'package:zotit/src/screens/home/providers/home_provider.dart';
import 'package:zotit/src/screens/home/providers/note.dart';
import 'package:http/http.dart' as http;
import 'package:zotit/src/utils/httpn.dart';

@immutable
class NoteDetails extends ConsumerWidget {
  final Note note;

  final int noteIndex;

  const NoteDetails({
    super.key,
    required this.note,
    required this.noteIndex,
  });

  _submit(context, text, NoteList noteList) async {
    try {
      final res = await httpPut("api/notes", {}, {
        "text": text,
        "id": note.id,
      });

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
    TextEditingController textC = TextEditingController(text: note.text);
    final notesData = ref.read(noteListProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note details"),
        backgroundColor: const Color(0xFF3A568E),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: textC,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Text',
                    hintText: 'Zot it ...'),
                minLines: 5,
                maxLines: 20,
              ),
            ),
            SizedBox(
              height: 40,
              width: 250,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF3A568E))),
                onPressed: () {
                  _submit(context, textC.text, notesData);
                  notesData.updateLocalNote(
                    textC.text,
                    false,
                    noteIndex,
                    null,
                    false,
                  );
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
