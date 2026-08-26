import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../handler/location.dart';
import '../../handler/user.dart';
import '../../l10n/app_localizations.dart';
import '../style.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Setting> settings(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return [
      Setting(
        label: l10n.language,
        icon: Icons.language_outlined,
        settingType: SettingType.selection,
        currentSelection: 'English',
        onPressed: (value) {},
      ),
      Setting(
        label: l10n.darkMode,
        icon: Icons.dark_mode_outlined,
        settingType: SettingType.bool,
        onPressed: (value) {
          themeNotifier.value = (value) ? darkTheme : lightTheme;
        },
      ),
      Setting(
        label: l10n.hideAccount,
        icon: Icons.lock_outlined,
        settingType: SettingType.bool,
        onPressed: (value) {
          setAccountPrivacy(value);
        },
      ),
      Setting(
        label: l10n.hideLocation,
        icon: Icons.location_on_outlined,
        settingType: SettingType.bool,
        onPressed: (value) {
          setLocationPrivacy(value);
        },
      ),
      Setting(
        label: l10n.reportAProblem,
        icon: Icons.bug_report_outlined,
        settingType: SettingType.button,
        onPressed: (value) {
          final url = Uri.parse('${dotenv.get('SITE_URL')}/report');
          launchUrl(url);
        },
      ),
      Setting(
        label: l10n.requestAFeature,
        icon: Icons.lightbulb,
        settingType: SettingType.button,
        onPressed: (value) {
          final url = Uri.parse('${dotenv.get('SITE_URL')}/feature');
          launchUrl(url);
        },
      ),
      Setting(
        label: l10n.privacyPolicy,
        icon: Icons.privacy_tip,
        settingType: SettingType.button,
        onPressed: (value) {
          final url = Uri.parse('${dotenv.get('SITE_URL')}/privacy');
          launchUrl(url);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;

        return Material(
          child: Padding(
            padding: pageInset.add(EdgeInsetsGeometry.only(top: height / 20)),
            child: Column(children: [...settings(context)]),
          ),
        );
      },
    );
  }
}

enum SettingType { selection, bool, button }

class Setting extends StatefulWidget {
  const Setting({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,

    required this.settingType,
    this.currentSelection = '',
  });

  final String label;
  final IconData icon;
  final void Function(bool value) onPressed;

  final SettingType settingType;
  final String currentSelection;

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () async {
        setState(() {
          widget.onPressed(true);
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 10,
            children: [
              Icon(widget.icon, color: colors.onSurface, size: 32),
              Text(widget.label, style: bodyMedium),
            ],
          ),
          switch (widget.settingType) {
            SettingType.selection => Row(
              children: [
                Text(
                  widget.currentSelection,
                  style: bodySmall.copyWith(color: colors.secondary),
                ),
                Icon(Icons.chevron_right, size: 40, color: colors.secondary),
              ],
            ),
            SettingType.bool => Switch(
              value: isEnabled,
              onChanged: (value) {
                setState(() {
                  isEnabled = !isEnabled;
                  widget.onPressed(value);
                });
              },
            ),
            SettingType.button => SizedBox.shrink(),
          },
        ],
      ),
    );
  }
}
