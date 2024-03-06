import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zotit/src/screens/home/providers/deleted_notes_provider.dart';
import 'package:zotit/src/screens/tags/providers/note_tag.dart';
import 'package:zotit/src/utils/httpn.dart';

class DeletedNotes extends ConsumerStatefulWidget {
  const DeletedNotes({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeletedNotes();
}

class _DeletedNotes extends ConsumerState<DeletedNotes> {
  bool isVisible = true;
  bool isSearching = false;
  NoteTag selectedTag = NoteTag(id: "", name: "default", color: 0xff9e9e9e);

  TextEditingController textC = TextEditingController(text: "");
  TextEditingController searchC = TextEditingController(text: "");
  TextEditingController rcvrUsernameC = TextEditingController(text: "");
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ref.read(deletedNoteListProvider.notifier).getNotesByPage(searchC.text);
      }
    });
    super.initState();
  }

  _unDeleteNote(context, id, int noteIndex) async {
    return showDialog<void>(
      context: context,
      builder: (c) {
        return ProviderScope(
          parent: ProviderScope.containerOf(context),
          child: AlertDialog(
            title: const Text('Restore this note'),
            content: const Text("Are you sure ?"),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'OK');
                  try {
                    final res = await httpPut("api/notes/restore", {}, {
                      "id": id,
                    });

                    if (res.statusCode == 200) {
                      ref
                          .watch(deletedNoteListProvider.notifier)
                          .deleteLocalNote(noteIndex);
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
                child: const Text('Restore'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesData = ref.watch(deletedNoteListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text("Deleted Notes"),
            const Text(
              "All trashed notes will be auto deleted in 15 days",
              style: TextStyle(fontSize: 11),
            )
          ],
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: notesData.when(
                data: (notes) => ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    controller: _scrollController,
                    children: notes.notes.isNotEmpty
                        ? notes.notes.asMap().entries.map((noteEntry) {
                            final globalKey = GlobalKey();
                            return Card(
                              elevation: 2.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 0.0),
                                dense: true,
                                title: Column(
                                  key: globalKey,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            ActionChip(
                                              padding: const EdgeInsets.all(2),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          style:
                                                              BorderStyle.none),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                              backgroundColor: Color(
                                                  noteEntry.value.tag!.color),
                                              label: Text(
                                                noteEntry.value.tag!.name,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: useWhiteForeground(
                                                          Color(noteEntry.value
                                                              .tag!.color))
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              onPressed: () {},
                                            ),
                                            Gap(20),
                                            TextButton.icon(
                                              onPressed: () {
                                                _unDeleteNote(
                                                    context,
                                                    noteEntry.value.id,
                                                    noteEntry.key);
                                              },
                                              icon: const Icon(
                                                Icons.restore,
                                                size: 16,
                                              ),
                                              label: const Text("Restore"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                                subtitle: Linkify(
                                  text: noteEntry.value.text,
                                  options:
                                      const LinkifyOptions(humanize: false),
                                  linkStyle: const TextStyle(fontSize: 16),
                                  onOpen: (LinkableElement link) async {
                                    if (!await launchUrl(Uri.parse(link.url))) {
                                      throw Exception(
                                          'Could not launch ${link.url}');
                                    }
                                  },
                                ),
                              ),
                            );
                          }).toList()
                        : [
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(50),
                                child: Text(
                                  "No Deleted Notes Found",
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
