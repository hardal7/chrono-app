import '../style.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Setting> settings = [
    Setting(
      label: 'Language',
      icon: Icons.language_outlined,
      onChanged: (bool isEnabled) {},
      isSelection: true,
      currentSelection: 'English',
    ),
    Setting(
      label: 'Dark Mode',
      icon: Icons.dark_mode_outlined,
      onChanged: (bool isEnabled) {},
    ),
    Setting(
      label: 'Notifications',
      icon: Icons.notifications_outlined,
      onChanged: (bool isEnabled) {},
    ),
    Setting(
      label: 'Hide Account',
      icon: Icons.lock_outlined,
      onChanged: (bool isEnabled) {},
    ),
    Setting(
      label: 'Hide Location',
      icon: Icons.location_on_outlined,
      onChanged: (bool isEnabled) {},
    ),
    Setting(
      label: 'Report a Problem',
      icon: Icons.bug_report_outlined,
      onChanged: (bool isEnabled) {},
    ),
  ];

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
            child: Column(children: [...settings]),
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

    this.isSelection = false,
    this.currentSelection = '',
  });

  final String label;
  final IconData icon;
  final ValueChanged<bool> onChanged;

  final bool isSelection;
  final String currentSelection;

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
        widget.isSelection
            ? Row(
                children: [
                  Text(widget.currentSelection, style: bodySmallGrey),
                  Icon(Icons.chevron_right, size: 40, color: secondaryColor),
                ],
              )
            : Switch(
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
