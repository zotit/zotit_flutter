import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextFieldNew extends StatefulWidget {
  const TextFieldNew({super.key, required this.onTextChanged});

  final Function(String) onTextChanged;

  @override
  State<StatefulWidget> createState() => TextFieldState();
}

class TextFieldState extends State<TextFieldNew> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadText();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Load text from SharedPreferences
  void _loadText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _textController.text = prefs.getString('text') ?? '';
    });
  }

  void _onTextChanged() {
    String newText = _textController.text;
    widget.onTextChanged(newText);
    _saveText(newText);
  }

  // Save text to SharedPreferences
  void _saveText(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('text', text);
  }

  // Method to reset the text field
  void resetText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _textController.text = '';
    });
    await prefs.setString('savedText', '');
    widget.onTextChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textController,
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: const InputDecoration(
          hintStyle: TextStyle(
            fontFamily: 'Satisfy',
          ),
          border: OutlineInputBorder(),
          labelText: 'Zot it',
          hintText: 'What needs to be zoted...'),
      minLines: 1,
      maxLines: 10,
    );
  }
}
