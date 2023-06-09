import 'package:flutter/material.dart';

@immutable
class ShowHideEye extends StatefulWidget {
  final Function onChange;
  final bool isVisible;
  const ShowHideEye({super.key, required this.isVisible, required this.onChange});

  @override
  State<ShowHideEye> createState() => _ShowHideEyeState();
}

class _ShowHideEyeState extends State<ShowHideEye> {
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    isVisible = widget.isVisible;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3A568E)),
      ),
      icon: Icon(!isVisible ? Icons.visibility : Icons.visibility_off),
      label: isVisible ? const Text("Obscure") : const Text("Visible"),
      onPressed: () {
        setState(
          () {
            isVisible = !isVisible;
            widget.onChange(isVisible);
          },
        );
      },
    );
  }
}
