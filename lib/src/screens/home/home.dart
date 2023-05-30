import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit_flutter/src/providers/login_provider/login_provider.dart';
import 'package:zotit_flutter/src/screens/home/note_details.dart';
import 'package:zotit_flutter/src/screens/home/providers/home_provider.dart';
import 'package:http/http.dart' as http;

final makeListTile = ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: const EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(border: new Border(right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: const Icon(Icons.note_alt, color: Colors.white),
    ),
    title: const Text(
      "Introduction to Driving",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

    subtitle: const Row(
      children: <Widget>[
        Icon(Icons.linear_scale, color: Colors.yellowAccent),
        Text(" Intermediate", style: TextStyle(color: Colors.white))
      ],
    ),
    trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));
final makeCard = Card(
  elevation: 8.0,
  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
  child: Container(
    decoration: const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
    child: makeListTile,
  ),
);

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginData = ref.watch(loginTokenProvider.notifier);
    TextEditingController textC = TextEditingController(text: "");
    final notesData = ref.watch(noteListProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF3A568E),
        title: Text(
          "ZotIt",
          style: TextStyle(fontFamily: 'Satisfy', fontSize: 35),
        ),
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
              padding: EdgeInsets.symmetric(
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
                  Gap(10),
                  ElevatedButton(
                    child: const Icon(Icons.done),
                    onPressed: () async {
                      await _submit(context, textC.text);
                      final _ = ref.refresh(noteListProvider.future);
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 20)),
                        backgroundColor: MaterialStateProperty.all(Color(0xFF3A568E))),
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
                                          foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF3A568E)),
                                        ),
                                        icon: const Icon(Icons.copy),
                                        label: Text("Copy"),
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
                                          foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF3A568E)),
                                        ),
                                        icon: const Icon(Icons.edit_document),
                                        label: Text("Edit"),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF3A568E)),
                                        ),
                                        icon: const Icon(Icons.share),
                                        label: Text("Share"),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          foregroundColor: MaterialStateProperty.all<Color>(
                                            Color(0xFF3A568E),
                                          ),
                                        ),
                                        icon: const Icon(Icons.delete),
                                        label: Text("Delete"),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Gap(5),
                                  Text(
                                    notes[i].text,
                                    style: TextStyle(color: Color(0xFF3A568E), fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    else
                      Center(
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
