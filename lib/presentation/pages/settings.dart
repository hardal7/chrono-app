import '../style.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

// TODO: Send feedback
class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;

        return Material(
          color: backgroundColor,
          child: Padding(
            padding: pageInset,
            child: Column(
              children: [
                Setting(
                  label: 'Language',
                  icon: Icons.language,
                  onChanged: (bool isEnabled) {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Setting extends StatefulWidget {
  const Setting({
    super.key,
    required this.label,
    required this.icon,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final ValueChanged<bool> onChanged;

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 10,
          children: [
            Icon(widget.icon, color: foregroundColor, size: 32),
            Text(widget.label, style: bodyMedium),
          ],
        ),
        Switch(
          value: isEnabled,
          onChanged: (value) {
            setState(() {
              isEnabled = value;
              widget.onChanged(isEnabled);
            });
          },
          activeTrackColor: accentColor,
          activeThumbColor: foregroundColor,
          inactiveTrackColor: foregroundColor,
          inactiveThumbColor: secondaryColor,
        ),
      ],
    );
  }
}
