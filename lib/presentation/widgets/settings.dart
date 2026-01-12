import 'package:flutter/material.dart';

import '../style.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key, required this.settingsPage});
  final Widget settingsPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0, right: 30.0),
          child: IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: foregroundColor,
              size: 36,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => settingsPage,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
