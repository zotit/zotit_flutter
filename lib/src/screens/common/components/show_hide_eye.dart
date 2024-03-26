import 'package:flutter/material.dart';

@immutable
class ShowHideEye extends StatefulWidget {
  final Function onChange;
  final bool isVisible;
  const ShowHideEye(
      {super.key, required this.isVisible, required this.onChange});

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
    final bool isBigScreen = MediaQuery.of(context).size.width > 400;
    if (isBigScreen) {
      return TextButton.icon(
        icon: Icon(!isVisible ? Icons.visibility : Icons.visibility_off),
        label: isVisible ? const Text("Hide") : const Text("Show"),
        onPressed: () {
          setState(
            () {
              isVisible = !isVisible;
              widget.onChange(isVisible);
            },
          );
        },
      );
    } else {
      return IconButton(
          icon: Icon(!isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(
              () {
                isVisible = !isVisible;
                widget.onChange(isVisible);
              },
            );
          });
    }
  }
}
