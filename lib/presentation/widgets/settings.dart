import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key, required this.popup});
  final void Function(BuildContext context) popup;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: colors.onSurface,
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
