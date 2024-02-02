import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit/config.dart';
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

  _submit(context, name, int color, NoteTagList noteList) async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final config = Config();
    final uri = Uri(
        scheme: config.scheme,
        host: config.host,
        port: config.port,
        path: "api/tags");

    try {
      Response res;
      if (noteIndex == -1) {
        res = await http.post(
          uri,
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          body: jsonEncode({
            "name": name,
            "color": color,
          }),
        );
      } else {
        res = await http.put(
          uri,
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          body: jsonEncode({
            "name": name,
            "id": noteTag.id,
            "color": color,
          }),
        );
      }

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
    Color selectedColor = Color(noteTag.color);
    return Scaffold(
      appBar: AppBar(
        title: noteIndex == -1
            ? const Text("Create Tag")
            : const Text("Update Tag"),
        backgroundColor: const Color(0xFF3A568E),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: textC,
                            maxLength: 10,
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
                              await _submit(context, textC.text,
                                  selectedColor.value, notesData);
                              final _ = ref.refresh(noteTagListProvider.future);
                              if (noteIndex != -1) {
                                notesData.updateLocalNoteTag(
                                    textC.text, selectedColor.value, noteIndex);
                              }

                              textC.text = '';
                            }
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 20)),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF3A568E))),
                          child: const Icon(Icons.done),
                        ),
                      ],
                    ),
                    BlockPicker(
                      pickerColor: selectedColor,
                      onColorChanged: (Color color) {
                        selectedColor = color;
                      },
                      useInShowDialog: true,
                      layoutBuilder: ((context, colors, child) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Gap(20),
                              const Text(
                                "Pick a Color",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Gap(2),
                              SizedBox(
                                height: 220,
                                child: GridView.count(
                                  primary: true,
                                  crossAxisCount: 7,
                                  crossAxisSpacing: 6.0,
                                  mainAxisSpacing: 6.0,
                                  shrinkWrap: true,
                                  children:
                                      colors.map((e) => child(e)).toList(),
                                ),
                              )
                            ],
                          )),
                      itemBuilder: (Color color, bool isCurrentColor,
                          void Function() changeColor) {
                        return Container(
                          margin: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            boxShadow: [
                              BoxShadow(
                                  color: color.withOpacity(0.8),
                                  offset: const Offset(1, 2),
                                  blurRadius: 5)
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
                                child: Icon(Icons.done,
                                    color: useWhiteForeground(color)
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
