import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit_flutter/src/screens/home/providers/home_provider.dart';
import 'package:zotit_flutter/src/screens/home/providers/note.dart';
import 'package:http/http.dart' as http;

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
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final uri = Uri.https('zotit.twobits.in', '/notes');

    try {
      final res = await http.put(uri, headers: {
        "Authorization": "Bearer $token"
      }, body: {
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
                title: const Text('AlertDialog Title'),
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
              title: const Text('AlertDialog Title'),
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
    final notesData = ref.watch(noteListProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text("Note details"),
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
                    const InputDecoration(border: OutlineInputBorder(), labelText: 'Text', hintText: 'Zot it ...'),
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
                  notesData.update((p0) {
                    final newNote = Note(id: p0[noteIndex].id, text: textC.text);
                    p0[noteIndex] = newNote;
                    return p0;
                  });
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