import 'package:flutter/material.dart';

import '../style.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key, required this.popup});
  final void Function(BuildContext context) popup;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: foregroundColor,
              size: 36,
            ),
            onPressed: () {
              popup(context);
            },
          ),
        ),
      ],
    );
  }
}
