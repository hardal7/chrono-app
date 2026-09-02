import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../handler/location.dart';
import '../../handler/user.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../style.dart';
import 'package:flutter/material.dart';

//TODO: Outbox privacy change requests

class AppSettings {
  AppSettings({required this.prefs, required this.l10n});

  final SharedPreferences prefs;
  final AppLocalizations l10n;

  static const darkModeKey = 'dark_mode';
  static const hideAccountKey = 'hide_account';
  static const hideLocationKey = 'hide_location';
  static const languageKey = 'language';

  List<Setting> build() {
    return [
      Setting(
        label: l10n.language,
        icon: Icons.language_outlined,
        settingType: SettingType.selection,
        isEnabled: prefs.getString(languageKey) == 'en',
        onPressed: (value) async {
          final language = value ? 'en' : 'tr';

          await prefs.setString(languageKey, language);

          appNotifier.value = AppValues(
            theme: appNotifier.value.theme,
            locale: Locale(language),
          );
        },
      ),

      Setting(
        label: l10n.darkMode,
        icon: Icons.dark_mode_outlined,
        settingType: SettingType.bool,
        isEnabled: prefs.getBool(darkModeKey) ?? false,
        onPressed: (value) async {
          await prefs.setBool(darkModeKey, value);

          appNotifier.value = AppValues(
            theme: value ? darkTheme : lightTheme,
            locale: appNotifier.value.locale,
          );
        },
      ),

      Setting(
        label: l10n.hideAccount,
        icon: Icons.lock_outlined,
        settingType: SettingType.bool,
        isEnabled: prefs.getBool(hideAccountKey) ?? false,
        onPressed: (value) async {
          await prefs.setBool(hideAccountKey, value);

          setAccountPrivacy(value);
        },
      ),

      Setting(
        label: l10n.hideLocation,
        icon: Icons.location_on_outlined,
        settingType: SettingType.bool,
        isEnabled: prefs.getBool(hideLocationKey) ?? false,
        onPressed: (value) async {
          await prefs.setBool(hideLocationKey, value);

          setLocationPrivacy(value);
        },
      ),

      Setting(
        label: l10n.reportAProblem,
        icon: Icons.bug_report_outlined,
        settingType: SettingType.button,
        isEnabled: false,
        onPressed: (_) async {
          final url = Uri.parse('${dotenv.get('SITE_URL')}/report');

          await launchUrl(url);
        },
      ),

      Setting(
        label: l10n.requestAFeature,
        icon: Icons.lightbulb,
        settingType: SettingType.button,
        isEnabled: false,
        onPressed: (_) async {
          final url = Uri.parse('${dotenv.get('SITE_URL')}/feature');

          await launchUrl(url);
        },
      ),

      Setting(
        label: l10n.privacyPolicy,
        icon: Icons.privacy_tip,
        settingType: SettingType.button,
        isEnabled: false,
        onPressed: (_) async {
          final url = Uri.parse('${dotenv.get('SITE_URL')}/privacy');

          await launchUrl(url);
        },
      ),
    ];
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences? _prefs;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _prefs = prefs;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    if (_prefs == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final l10n = AppLocalizations.of(context)!;
    final settings = AppSettings(prefs: _prefs!, l10n: l10n);

    return Material(
      child: Padding(
        padding: pageInset.add(EdgeInsetsGeometry.only(top: 50)),
        child: Column(children: settings.build()),
      ),
    );
  }
}

class Setting extends StatefulWidget {
  const Setting({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.isEnabled,
    required this.settingType,
    this.currentSelection = 'English',
  });

  final String label;
  final IconData icon;
  final void Function(bool value) onPressed;
  final bool isEnabled;

  final SettingType settingType;
  final String currentSelection;

  @override
  State<Setting> createState() => _SettingState();
}

enum SettingType { selection, bool, button }

class _SettingState extends State<Setting> {
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isEnabled = !_isEnabled;
          widget.onPressed(_isEnabled);
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
              value: _isEnabled,
              onChanged: (value) {
                setState(() {
                  _isEnabled = value;
                });

                widget.onPressed(value);
              },
            ),
            SettingType.button => SizedBox.shrink(),
          },
        ],
      ),
    );
  }
}
