import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit/config.dart';
import 'package:http/http.dart' as http;
import 'package:zotit/src/app_router.dart';
import 'package:zotit/src/screens/home/providers/home_provider.dart';
import 'package:zotit/src/screens/tags/providers/note_tag.dart';
import 'package:zotit/src/screens/tags/providers/note_tags_provider.dart';
import 'package:zotit/src/utils/httpn.dart';

class NoteTagsBS extends ConsumerStatefulWidget {
  final NoteTag noteTag;
  final String noteId;
  final int noteIndex;

  const NoteTagsBS({
    super.key,
    required this.noteTag,
    required this.noteId,
    required this.noteIndex,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteTagsBS();
}

class _NoteTagsBS extends ConsumerState<NoteTagsBS> {
  late var selectedId = widget.noteTag.id;

  TextEditingController textC = TextEditingController(text: "");
  final ScrollController _scrollController = ScrollController();
  assignTag(context) async {
    try {
      Response res = await httpPut("api/notes/assign-tag", {}, {
        "id": widget.noteId,
        "tag_id": selectedId,
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

  removeTag(context) async {
    try {
      Response res = await httpPut("api/notes/remove-tag", {}, {
        "id": widget.noteId,
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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: noteTagsData.when(
        data: (noteTags) => Wrap(
          children: noteTags.noteTags.isNotEmpty
              ? [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(AppRoutes.tagList);
                      },
                      child: const Icon(Icons.settings),
                    ),
                  ),
                  ...noteTags.noteTags.asMap().entries.map((noteTagEntry) {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: ChoiceChip(
                        showCheckmark: true,
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        checkmarkColor:
                            useWhiteForeground(Color(noteTagEntry.value.color))
                                ? Colors.white
                                : Colors.black,
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(style: BorderStyle.none),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        label: Text(
                          noteTagEntry.value.name,
                          style: TextStyle(
                            color: useWhiteForeground(
                                    Color(noteTagEntry.value.color))
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        backgroundColor: Color(noteTagEntry.value.color),
                        selectedColor: Color(noteTagEntry.value.color),
                        selected: noteTagEntry.value.id == selectedId,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedId = selected ? noteTagEntry.value.id : "";
                          });
                          if (selected) {
                            assignTag(context);
                            ref
                                .watch(noteListProvider.notifier)
                                .updateLocalNote(null, null, widget.noteIndex,
                                    noteTagEntry.value, false);
                          } else {
                            removeTag(context);
                            ref
                                .watch(noteListProvider.notifier)
                                .updateLocalNote(
                                    null, null, widget.noteIndex, null, true);
                          }
                        },
                      ),
                    );
                  }).toList()
                ]
              : [
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.all(50),
                        child: Column(
                          children: [
                            const Text(
                              "No Tags Found",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Gap(20),
                            ElevatedButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 10)),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFF3A568E))),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.tagList);
                              },
                              child: const Text("Manage Tags"),
                            )
                          ],
                        )),
                  ),
                ],
        ),
        loading: () => const SizedBox(
          height: 50,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (err, stack) => Text('Error: $err'),
      ),
    );
  }
}
