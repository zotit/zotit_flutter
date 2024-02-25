import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zotit/src/screens/tags/providers/note_tag.dart';
import 'package:zotit/src/screens/tags/providers/note_tags_provider.dart';

class NoteTagSList extends ConsumerStatefulWidget {
  final String noteTagId;
  final Function(NoteTag?) onSelected;

  const NoteTagSList({
    super.key,
    required this.noteTagId,
    required this.onSelected,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteTagSList();
}

class _NoteTagSList extends ConsumerState<NoteTagSList> {
  late var selectedId = widget.noteTagId;

  TextEditingController textC = TextEditingController(text: "");
  final ScrollController _scrollController = ScrollController();

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
    return noteTagsData.when(
      data: (noteTags) => noteTags.noteTags.isNotEmpty
          ? SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: noteTags.noteTags.asMap().entries.map((noteEntry) {
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: ChoiceChip(
                      showCheckmark: true,
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      checkmarkColor:
                          useWhiteForeground(Color(noteEntry.value.color))
                              ? Colors.white
                              : Colors.black,
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(style: BorderStyle.none),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      label: Text(
                        noteEntry.value.name,
                        style: TextStyle(
                          color:
                              useWhiteForeground(Color(noteEntry.value.color))
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      backgroundColor: Color(noteEntry.value.color),
                      selectedColor: Color(noteEntry.value.color),
                      selected: noteEntry.value.id == selectedId,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedId = selected ? noteEntry.value.id : "";
                        });
                        widget.onSelected(selected ? noteEntry.value : null);
                      },
                    ),
                  );
                }).toList(),
              ),
            )
          : const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "No Tags Found",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
      loading: () => const SizedBox(
        height: 50,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
