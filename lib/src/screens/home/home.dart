import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit_flutter/src/providers/login_provider/login_provider.dart';
import 'package:zotit_flutter/src/screens/home/note_details.dart';
import 'package:zotit_flutter/src/screens/home/providers/home_provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  _submit(context, text) async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final uri = Uri.https('zotit.twobits.in', '/notes');

    try {
      final res = await http.post(uri, headers: {
        "Authorization": "Bearer $token"
      }, body: {
        "text": text,
      });
      if (res.statusCode == 200) {
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

  _shareNote(String note) async {
    Share.share("$note \nShared from https://zotit.twobits.in", subject: "note shared from Zotit | Zot anywhere");
  }

  _deleteNote(context, ref, id) async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final uri = Uri.https('zotit.twobits.in', '/notes');
    return showDialog<void>(
      context: context,
      builder: (c) {
        return ProviderScope(
          parent: ProviderScope.containerOf(context),
          child: AlertDialog(
            title: const Text('AlertDialog Title'),
            content: const Text("Are you sure ?"),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'OK');
                  try {
                    final res = await http.delete(uri, headers: {
                      "Authorization": "Bearer $token"
                    }, body: {
                      "id": id,
                    });
                    if (res.statusCode == 200) {
                      final _ = ref.refresh(noteListProvider.future);
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
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginData = ref.watch(loginTokenProvider.notifier);
    TextEditingController textC = TextEditingController(text: "");
    final notesData = ref.watch(noteListProvider);
    return Scaffold(
      backgroundColor: Colors.white,
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
          IconButton(
            onPressed: () => ref.refresh(noteListProvider.future),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              loginData.logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10.0,
              ),
              child: Row(
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
                      await _submit(context, textC.text);
                      final _ = ref.refresh(noteListProvider.future);
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 20)),
                        backgroundColor: MaterialStateProperty.all(const Color(0xFF3A568E))),
                    child: const Icon(Icons.done),
                  ),
                ],
              ),
            ),
            Expanded(
              child: notesData.when(
                data: (notes) => ListView(
                  children: [
                    if (notes.length > 0)
                      for (int i = 0; i < notes.length; i++)
                        Card(
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            // decoration: const BoxDecoration(color: Color(0xFF3A568E)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(text: notes[i].text));
                                        },
                                        style: ButtonStyle(
                                          foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3A568E)),
                                        ),
                                        icon: const Icon(Icons.copy),
                                        label: const Text("Copy"),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute<dynamic>(
                                            builder: (_) => NoteDetails(
                                              note: notes[i],
                                              noteIndex: i,
                                            ),
                                          ));
                                        },
                                        style: ButtonStyle(
                                          foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3A568E)),
                                        ),
                                        icon: const Icon(Icons.edit_document),
                                        label: const Text("Edit"),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          _shareNote(notes[i].text);
                                        },
                                        style: ButtonStyle(
                                          foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3A568E)),
                                        ),
                                        icon: const Icon(Icons.share),
                                        label: const Text("Share"),
                                      ),
                                      TextButton.icon(
                                        onPressed: () async {
                                          await _deleteNote(context, ref, notes[i].id);
                                        },
                                        style: ButtonStyle(
                                          foregroundColor: MaterialStateProperty.all<Color>(
                                            const Color(0xFF3A568E),
                                          ),
                                        ),
                                        icon: const Icon(Icons.delete),
                                        label: const Text("Delete"),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  const Gap(5),
                                  Text(
                                    notes[i].text,
                                    style: const TextStyle(color: Color(0xFF3A568E), fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    else
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(50),
                          child: Text(
                            "No Notes Found",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
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
